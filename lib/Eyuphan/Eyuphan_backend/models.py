# lib/Eyuphan_backend/models.py
from sqlalchemy import create_engine, Column, Integer, String, Float, DateTime, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship
from datetime import datetime

# 1. SQLite Veritabanı Dosyasını Tanımlıyoruz (Aynı klasörde finans.db adında oluşacak)
DATABASE_URL = "sqlite:///./finans.db"
engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

# ==========================================
# 1. KULLANICI TABLOSU (User)
# ==========================================
class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    isim = Column(String, index=True) # Örn: Metin, Eyüphan
    email = Column(String, unique=True, index=True)

    # Kullanıcının harcamalarıyla olan ilişkisi
    transactions = relationship("Transaction", back_populates="sahibi")

# ==========================================
# 2. İŞLEMLER TABLOSU (Transaction)
# ==========================================
class Transaction(Base):
    __tablename__ = "transactions"

    id = Column(Integer, primary_key=True, index=True)
    baslik = Column(String)       # Örn: Yemek, Toplu Taşıma, Market Alışverişi
    kategori = Column(String)     # Örn: Restoran, Ulaşım, Alışveriş, Eğlence, Faturalar
    miktar = Column(Float)         # Örn: -250.0 veya +8000.0 (Gelir/Gider ayrımı için)
    tarih = Column(DateTime, default=datetime.utcnow)
    user_id = Column(Integer, ForeignKey("users.id"))

    sahibi = relationship("User", back_populates="transactions")

# ==========================================
# 3. BÜTÇE AYARLARI TABLOSU (Budget)
# ==========================================
class Budget(Base):
    __tablename__ = "budgets"

    id = Column(Integer, primary_key=True, index=True)
    aylik_limit = Column(Float, default=10000.0) # Örn: Arayüzdeki 10.000 TL bütçe limiti
    user_id = Column(Integer, ForeignKey("users.id"))


# Veritabanı tablolarını otomatik oluşturma fonksiyonu
def veritabanini_olustur():
    # Base.metadata.create_engine(bind=engine)
    Base.metadata.create_all(bind=engine)