import 'package:flutter/material.dart';

import '../modeller/harcama_kategorisi.dart';
import '../modeller/odeme_yontemi.dart';
import '../parcalar/butonlar/harcama_kaydet_butonu.dart';
import '../parcalar/form_alanlari/aciklama_alani.dart';
import '../parcalar/form_alanlari/kategori_secici.dart';
import '../parcalar/form_alanlari/not_alani.dart';
import '../parcalar/form_alanlari/odeme_yontemi_secici.dart';
import '../parcalar/form_alanlari/tarih_secici.dart';
import '../parcalar/tutar/tutar_giris_alani.dart';
import '../parcalar/ust_bar/harcama_ekle_ust_bar.dart';
import '../sabitler/renkler.dart';

class HarcamaEkleSayfasi extends StatefulWidget {
  const HarcamaEkleSayfasi({super.key});

  @override
  State<HarcamaEkleSayfasi> createState() => _HarcamaEkleSayfasiState();
}

class _HarcamaEkleSayfasiState extends State<HarcamaEkleSayfasi> {
  final TextEditingController _tutarController = TextEditingController();
  final TextEditingController _aciklamaController = TextEditingController();
  final TextEditingController _notController = TextEditingController();

  HarcamaKategorisi? _secilenKategori;
  OdemeYontemi? _secilenOdemeYontemi;
  DateTime? _secilenTarih;

  @override
  void dispose() {
    _tutarController.dispose();
    _aciklamaController.dispose();
    _notController.dispose();
    super.dispose();
  }

  void _harcamaKaydet() {
    if (_tutarController.text.trim().isEmpty) {
      _uyariGoster('Lütfen tutar giriniz');
      return;
    }
    if (_aciklamaController.text.trim().isEmpty) {
      _uyariGoster('Lütfen açıklama giriniz');
      return;
    }
    if (_secilenKategori == null) {
      _uyariGoster('Lütfen kategori seçiniz');
      return;
    }
    if (_secilenTarih == null) {
      _uyariGoster('Lütfen tarih seçiniz');
      return;
    }
    if (_secilenOdemeYontemi == null) {
      _uyariGoster('Lütfen ödeme yöntemi seçiniz');
      return;
    }

    debugPrint('--- Yeni Harcama ---');
    debugPrint('Tutar       : ${_tutarController.text}');
    debugPrint('Aciklama    : ${_aciklamaController.text}');
    debugPrint('Kategori    : ${_secilenKategori!.ad}');
    debugPrint('Tarih       : $_secilenTarih');
    debugPrint('Odeme       : ${_secilenOdemeYontemi!.ad}');
    debugPrint('Not         : ${_notController.text}');

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Harcama başarıyla kaydedildi'),
          backgroundColor: Renkler.basariliRengi,
          behavior: SnackBarBehavior.floating,
        ),
      );

    _formuTemizle();
  }

  void _formuTemizle() {
    _tutarController.clear();
    _aciklamaController.clear();
    _notController.clear();
    setState(() {
      _secilenKategori = null;
      _secilenOdemeYontemi = null;
      _secilenTarih = null;
    });
  }

  void _uyariGoster(String mesaj) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(mesaj),
          backgroundColor: Renkler.hataRengi,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Renkler.arkaPlan,
      appBar: const HarcamaEkleUstBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TutarGirisAlani(controller: _tutarController),
              const SizedBox(height: 18),
              AciklamaAlani(controller: _aciklamaController),
              const SizedBox(height: 18),
              KategoriSecici(
                secilenKategori: _secilenKategori,
                onChanged: (deger) => setState(() => _secilenKategori = deger),
              ),
              const SizedBox(height: 18),
              TarihSecici(
                secilenTarih: _secilenTarih,
                onChanged: (deger) => setState(() => _secilenTarih = deger),
              ),
              const SizedBox(height: 18),
              OdemeYontemiSecici(
                secilenOdemeYontemi: _secilenOdemeYontemi,
                onChanged: (deger) =>
                    setState(() => _secilenOdemeYontemi = deger),
              ),
              const SizedBox(height: 18),
              NotAlani(controller: _notController),
              const SizedBox(height: 28),
              HarcamaKaydetButonu(onPressed: _harcamaKaydet),
            ],
          ),
        ),
      ),
    );
  }
}
