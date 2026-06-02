// lib/metin/model/hedef.dart
// Finansal hedef veri modeli

import 'package:flutter/material.dart';

class Hedef {
  String id, baslik, aciklama;
  double birikim, hedef;
  Color renk;
  IconData ikon;

  Hedef({
    required this.id,
    required this.baslik,
    required this.aciklama,
    required this.birikim,
    required this.hedef,
    required this.renk,
    required this.ikon,
  });

  // Hesaplanan alanlar
  double get yuzde    => (birikim / hedef).clamp(0.0, 1.0);
  double get kalan    => hedef - birikim;
  int    get yuzdeInt => (yuzde * 100).round();
}

// ─── Para formatlama ───────────────────────────────────────
// 8450.0 → ₺8.450,00
String paraFormat(double tutar) {
  final parcalar = tutar.toStringAsFixed(2).split('.');
  final tam   = parcalar[0];
  final kurus = parcalar[1];
  String sonuc = '';
  for (int i = 0; i < tam.length; i++) {
    if (i > 0 && (tam.length - i) % 3 == 0) sonuc += '.';
    sonuc += tam[i];
  }
  return '₺$sonuc,$kurus';
}