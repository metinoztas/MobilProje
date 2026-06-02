# lib/Eyuphan_backend/main.py
from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from sqlalchemy import func
import models

# Uygulama ayağa kalkarken tabloları otomatik oluşturur
models.veritabanini_olustur()

app = FastAPI(title="Akıllı Finans Asistanı API - Eyüphan")

# Flutter Web (Chrome) CORS İzinleri
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Veritabanı Oturum Yönetimi
def get_db():
    db = models.SessionLocal()
    try:
        yield db
    finally:
        db.close()

# =========================================================================
# 1. ENDPOINT: ANA EKRANIN TÜM VERİLERİNİ DİNAMİK HESAPLAYAN SERVİS (GET)
# =========================================================================
@app.get("/api/dashboard")
def get_dashboard(db: Session = Depends(get_db)):
    # Şimdilik sistemde 1 numaralı kullanıcı olan "Metin" üzerinden işlem yapıyoruz
    user = db.query(models.User).filter(models.User.id == 1).first()
    if not user:
        raise HTTPException(status_code=404, detail="Kullanıcı bulunamadı")

    # A. Bütçe Limitini Çek (Eğer ayarlanmadıysa varsayılan 10.000 TL)
    budget = db.query(models.Budget).filter(models.Budget.user_id == user.id).first()
    butce_limiti = budget.aylik_limit if budget else 10000.0

    # B. Toplam Gelir Hesapla (Miktarı 0'dan büyük olan işlemler)
    toplam_gelir = db.query(func.sum(models.Transaction.miktar)).filter(
        models.Transaction.user_id == user.id,
        models.Transaction.miktar > 0
    ).scalar() or 0.0

    # C. Toplam Harcama Hesapla (Miktarı 0'dan küçük olan işlemler)
    # SQL'de giderler eksi (-) tutulduğu için abs() ile pozitife çevirip arayüze gönderiyoruz
    toplam_harcama = db.query(func.sum(models.Transaction.miktar)).filter(
        models.Transaction.user_id == user.id,
        models.Transaction.miktar < 0
    ).scalar() or 0.0
    toplam_harcama_pozitif = abs(toplam_harcama)

    # D. Tasarruf Hesapla (Gelir - Harcama)
    # Toplam harcama zaten eksi değerde olduğu için toplama işlemi aslında çıkarma yapar
    tasarruf = toplam_gelir + toplam_harcama

    # E. Kategori Dağılımını Hesapla (Pasta Grafiği İçin)
    # Hangi kategoriye toplam ne kadar harcanmış SQL grup sorgusuyla buluyoruz
    kategori_sorgusu = db.query(
        models.Transaction.kategori,
        func.sum(models.Transaction.miktar)
    ).filter(
        models.Transaction.user_id == user.id,
        models.Transaction.miktar < 0 # Sadece giderleri grupla
    ).group_by(models.Transaction.kategori).all()

    # Flutter'ın pasta grafiği için kolayca okuyabileceği bir kategori sözlüğü oluşturuyoruz
    kategoriler = {kat: abs(toplam) for kat, toplam in kategori_sorgusu}

    # F. Son 3 İşlemi Getir (En yeni tarihten eskiye sıralı)
    son_islemler_sorgu = db.query(models.Transaction).filter(
        models.Transaction.user_id == user.id
    ).order_by(models.Transaction.tarih.desc()).limit(3).all()

    son_islemler_listesi = []
    for islem in son_islemler_sorgu:
        # Arayüze uygun formatlama yapıyoruz
        islem_tipi_isareti = "+" if islem.miktar > 0 else "-"
        son_islemler_listesi.append({
            "baslik": islem.baslik,
            "altBaslik": islem.kategori,
            "miktar": f"{islem_tipi_isareti}₺{abs(islem.miktar):,.2f}".replace(",", "."),
            "tarih": islem.tarih.strftime("%d.%m.%Y • %H:%M")
        })

    # Flutter'ın (Dart) tek bir HTTP isteğiyle tüm ana sayfayı dolduracağı o efsane JSON paketi:
    return {
        "kullanici": user.isim,
        "toplam_harcama": f"₺{toplam_harcama_pozitif:,.2f}".replace(",", "."),
        "ozet_kartlar": {
            "gelir": f"₺{toplam_gelir:,.2f}".replace(",", "."),
            "butce": f"₺{butce_limiti:,.2f}".replace(",", "."),
            "tasarruf": f"₺{tasarruf:,.2f}".replace(",", "."),
            "hedefler": "3 aktif" # Şimdilik statik, ileride tabloya bağlanabilir
        },
        "kategori_dagilimi": kategoriler,
        "son_islemler": son_islemler_listesi
    }

# =========================================================================
# 2. ENDPOINT: MOBİLDEN YENİ İŞLEM (HARCAMA/GELİR) EKLEME SERVİSİ (POST)
# =========================================================================
@app.post("/api/transactions/add")
def add_transaction(baslik: str, kategori: str, miktar: float, db: Session = Depends(get_db)):
    # Yeni harcamayı veritabanına kaydet (Metin kullanıcısına bağla -> user_id=1)
    yeni_islem = models.Transaction(
        baslik=baslik,
        kategori=kategori,
        miktar=miktar, # Gider eklerken mobilden eksi (-) değer yollayacağız
        user_id=1
    )
    db.add(yeni_islem)
    db.commit()
    db.refresh(yeni_islem)
    return {"durum": "başarılı", "mesaj": f"'{baslik}' işlemi başarıyla kaydedildi!"}


# VERİTABANINA İLK VERİLERİ YÜKLEYEN STARTUP EVENTİ
@app.on_event("startup")
def ilk_verileri_yukle():
    db = models.SessionLocal()
    if db.query(models.User).count() == 0:
        yeni_kullanici = models.User(isim="Metin", email="metin@universite.edu.tr")
        db.add(yeni_kullanici)
        db.commit()
        db.refresh(yeni_kullanici)

        yeni_butce = models.Budget(aylik_limit=10000.0, user_id=yeni_kullanici.id)
        db.add(yeni_butce)

        # İlk harcamaları ekliyoruz (Giderler eksi verilir)
        islem1 = models.Transaction(baslik="Yemek", kategori="Restoran", miktar=-1900.0, user_id=yeni_kullanici.id)
        islem2 = models.Transaction(baslik="Toplu Taşıma", kategori="Ulaşım", miktar=-1350.0, user_id=yeni_kullanici.id)
        islem3 = models.Transaction(baslik="Market Alışverişi", kategori="Alışveriş", miktar=-1080.0, user_id=yeni_kullanici.id)
        islem4 = models.Transaction(baslik="Sinema & Konser", kategori="Eğlence", miktar=-540.0, user_id=yeni_kullanici.id)
        islem5 = models.Transaction(baslik="Elektrik & İnternet", kategori="Faturalar", miktar=-560.0, user_id=yeni_kullanici.id)
        
        # 8000 TL Gelir ekle
        gelir = models.Transaction(baslik="Aylık Burs / Maaş", kategori="Gelir", miktar=8000.0, user_id=yeni_kullanici.id)

        db.add_all([islem1, islem2, islem3, islem4, islem5, gelir])
        db.commit()
    db.close()