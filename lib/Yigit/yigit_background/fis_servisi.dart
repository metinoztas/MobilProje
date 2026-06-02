// ============================================================
// DOSYA: fis_servisi.dart
// KONUM: lib/Yigit/yigit_background/
// GÖREV: Fişlerle ilgili tüm iş mantığını yönetir:
//        - Örnek fişleri yükler
//        - Yeni fiş ekler
//        - Toplam harcamayı hesaplar
//        - Kategoriye göre filtreler
//        fis_camera.dart bu servisi kullanarak listeyi alır/günceller.
// ============================================================

import 'fis_modeli.dart';

class FisServisi {
  // Uygulama içi fiş listesi (normalde veritabanına bağlanır)
  final List<FisModeli> _fisler = [
    FisModeli(market: 'Migros',   tarih: '18 May 2025', tutar: 245.80, kategori: 'Market'),
    FisModeli(market: 'A101',     tarih: '15 May 2025', tutar: 89.50,  kategori: 'Market'),
    FisModeli(market: 'Teknosa',  tarih: '12 May 2025', tutar: 1299.00, kategori: 'Elektronik'),
  ];

  /// Tüm fişleri döner
  List<FisModeli> getFisler() => List.unmodifiable(_fisler);

  /// Yeni fiş ekler
  void fisBal(FisModeli fis) {
    _fisler.insert(0, fis);
  }

  /// Toplam harcama tutarını hesaplar
  double toplamHarcama() {
    return _fisler.fold(0, (toplam, fis) => toplam + fis.tutar);
  }

  /// Belirli kategorideki fişleri filtreler
  List<FisModeli> kategoriyeGoreFiltrele(String kategori) {
    return _fisler.where((f) => f.kategori == kategori).toList();
  }

  /// QR / kamera ile okunan ham veriyi FisModeli'ne çevirir
  /// (Gerçek uygulamada burada OCR/parse işlemi yapılır)
  FisModeli qrdenOku(String qrVerisi) {
    // Örnek: "Migros|20 May 2025|312.40|Market"
    final parcalar = qrVerisi.split('|');
    return FisModeli(
      market:    parcalar.isNotEmpty ? parcalar[0] : 'Bilinmeyen',
      tarih:     parcalar.length > 1 ? parcalar[1] : 'Tarih yok',
      tutar:     parcalar.length > 2 ? double.tryParse(parcalar[2]) ?? 0 : 0,
      kategori:  parcalar.length > 3 ? parcalar[3] : 'Genel',
    );
  }
}
