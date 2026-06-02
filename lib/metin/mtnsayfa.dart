// lib/metin/mtnsayfa.dart
// Ana sayfa — tüm widget ve servisler buradan çağrılır
// Çalıştırmak için: flutter run -t lib/metin/mtnsayfa.dart

import 'package:flutter/material.dart';
import 'model/hedef.dart';
import 'model/sabitler.dart';
import 'widgets/hedef_karti.dart';
import 'ai/ai_sohbet.dart';

class GoalsAiPage extends StatefulWidget {
  const GoalsAiPage({super.key});
  @override
  State<GoalsAiPage> createState() => _GoalsAiPageState();
}

class _GoalsAiPageState extends State<GoalsAiPage> {

  // Ana para — ileride gerçek değişkeniyle değiştirilecek
  double anaPara = 50000;

  // Tüm hedeflerin birikimlerinin toplamı
  double get _toplamBirikim => _hedefler.fold(0, (toplam, h) => toplam + h.birikim);

  // Toplam birikim ana parayı geçiyor mu?
  bool get _uyariVar => _toplamBirikim > anaPara;

  // Demo hedef verileri
  final List<Hedef> _hedefler = [
    Hedef(id: '1', baslik: 'Tatil Fonu',   aciklama: 'Yaz tatili için birikim',       birikim: 8450,  hedef: 15000,  renk: kPurple,                ikon: Icons.flight_rounded),
    Hedef(id: '2', baslik: 'Yeni Laptop',  aciklama: 'Çalışmalarım için yeni laptop', birikim: 12300, hedef: 20000,  renk: const Color(0xFF22C55E), ikon: Icons.laptop_rounded),
    Hedef(id: '3', baslik: 'Ev Peşinatı', aciklama: 'Kendi evime sahip olmak için',  birikim: 25000, hedef: 100000, renk: const Color(0xFFF59E0B), ikon: Icons.home_rounded),
  ];

  // ── Yeni hedef ekleme ──
  void _hedefEkle() {
    final baslikCtrl    = TextEditingController();
    final aciklamaCtrl  = TextEditingController();
    final hedefCtrl     = TextEditingController();
    Color seciliRenk    = kPurple;
    IconData seciliIkon = Icons.star_rounded;

    final renkler = [kPurple, const Color(0xFF22C55E), const Color(0xFFF59E0B),
                     const Color(0xFFEF4444), const Color(0xFF3B82F6), const Color(0xFFEC4899)];
    final ikonlar = [Icons.flight_rounded, Icons.laptop_rounded, Icons.home_rounded,
                     Icons.directions_car_rounded, Icons.school_rounded, Icons.savings_rounded,
                     Icons.favorite_rounded, Icons.star_rounded];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Başlık
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(kYeniHedef, style: TextStyle(color: kText, fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(icon: const Icon(Icons.close, color: kGrey), onPressed: () => Navigator.pop(ctx)),
                  ],
                ),
                const SizedBox(height: 16),

                // İkon seçimi
                const Text('İkon', style: TextStyle(color: kGrey, fontSize: 13)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: ikonlar.map((ikon) => GestureDetector(
                    onTap: () => setS(() => seciliIkon = ikon),
                    child: Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: seciliIkon == ikon ? seciliRenk.withOpacity(0.25) : kBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: seciliIkon == ikon ? seciliRenk : kLine),
                      ),
                      child: Icon(ikon, color: seciliIkon == ikon ? seciliRenk : kGrey, size: 20),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 16),

                // Renk seçimi
                const Text('Renk', style: TextStyle(color: kGrey, fontSize: 13)),
                const SizedBox(height: 8),
                Row(
                  children: renkler.map((r) => GestureDetector(
                    onTap: () => setS(() => seciliRenk = r),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 30, height: 30,
                      decoration: BoxDecoration(
                        color: r, shape: BoxShape.circle,
                        border: seciliRenk == r ? Border.all(color: Colors.white, width: 2.5) : null,
                      ),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 16),

                // Giriş alanları
                _input(baslikCtrl,   kHedefAdi,   'örn. Tatil Fonu'),
                const SizedBox(height: 10),
                _input(aciklamaCtrl, kAciklama,   'örn. Yaz tatili için birikim'),
                const SizedBox(height: 10),
                _input(hedefCtrl,    kHedefTutar, 'örn. 15000', sayi: true),
                const SizedBox(height: 20),

                // Kaydet butonu
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPurple, foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      final baslik     = baslikCtrl.text.trim();
                      final hedefTutar = double.tryParse(hedefCtrl.text.trim().replaceAll(',', '.')) ?? 0;
                      if (baslik.isEmpty || hedefTutar <= 0) return;
                      setState(() {
                        _hedefler.add(Hedef(
                          id: DateTime.now().toIso8601String(),
                          baslik: baslik,
                          aciklama: aciklamaCtrl.text.trim(),
                          birikim: 0,
                          hedef: hedefTutar,
                          renk: seciliRenk,
                          ikon: seciliIkon,
                        ));
                      });
                      Navigator.pop(ctx);
                    },
                    child: const Text(kEkle, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Hedef seçenekleri (para ekle / sil) ──
  void _hedefSecenekler(Hedef h) {
    showModalBottomSheet(
      context: context,
      backgroundColor: kCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(h.baslik, style: const TextStyle(color: kText, fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _secenek(Icons.add_circle_outline_rounded, kParaEkle, Colors.greenAccent, () { Navigator.pop(ctx); _paraEkle(h); }),
            const SizedBox(height: 8),
            _secenek(Icons.delete_outline_rounded, kSil, Colors.redAccent, () {
              setState(() => _hedefler.removeWhere((x) => x.id == h.id));
              Navigator.pop(ctx);
            }),
          ],
        ),
      ),
    );
  }

  // ── Para ekleme dialogu ──
  void _paraEkle(Hedef h) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: kCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text('${h.baslik} — $kParaEkle', style: const TextStyle(color: kText, fontSize: 15)),
        content: _input(ctrl, 'Tutar', '₺', sayi: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text(kIptal, style: TextStyle(color: kGrey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kPurple, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              final miktar = double.tryParse(ctrl.text.trim().replaceAll(',', '.')) ?? 0;
              if (miktar > 0) setState(() => h.birikim = (h.birikim + miktar).clamp(0, h.hedef));
              Navigator.pop(ctx);
            },
            child: const Text(kEkle),
          ),
        ],
      ),
    );
  }

  // ── Yardımcı: metin giriş alanı ──
  Widget _input(TextEditingController ctrl, String etiket, String ipucu, {bool sayi = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(etiket, style: const TextStyle(color: kGrey, fontSize: 12)),
        const SizedBox(height: 4),
        TextField(
          controller: ctrl,
          keyboardType: sayi ? TextInputType.number : TextInputType.text,
          style: const TextStyle(color: kText),
          decoration: InputDecoration(
            hintText: ipucu, hintStyle: const TextStyle(color: kGrey),
            filled: true, fillColor: kBg,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border:        OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kLine)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kLine)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kPurple)),
          ),
        ),
      ],
    );
  }

  // ── Yardımcı: seçenek satırı ──
  Widget _secenek(IconData ikon, String etiket, Color renk, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: renk.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: renk.withOpacity(0.2)),
        ),
        child: Row(children: [
          Icon(ikon, color: renk, size: 20),
          const SizedBox(width: 10),
          Text(etiket, style: TextStyle(color: renk, fontSize: 14, fontWeight: FontWeight.w500)),
        ]),
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final yukseklik = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(children: [

          // ══ ÜST YARI — Hedefler ════════════════════════════
          SizedBox(
            height: yukseklik * 0.5,
            child: Column(children: [

              // Selamlama + bildirim
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(kSelamlama, style: TextStyle(color: kText, fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 2),
                        Text(kSelSlogani, style: TextStyle(color: kGrey, fontSize: 12)),
                      ],
                    ),
                    // const Icon(Icons.notifications_outlined, color: kGrey),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // "Hedeflerin" + "Hedef Ekle" butonu
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(kHedeflerBaslik, style: TextStyle(color: kText, fontSize: 16, fontWeight: FontWeight.w700)),
                    GestureDetector(
                      onTap: _hedefEkle,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [kPurple, kPurple2]),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(children: [
                          Text(kHedefEkle, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                          SizedBox(width: 4),
                          Icon(Icons.add, color: Colors.white, size: 14),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),



              GestureDetector(

                onTap: () {

                  // BUTONA BASILINCA ÇALIŞACAK KISIM
                  double esitPara = anaPara / _hedefler.length;

                  setState(() {

                    for (var hedef in _hedefler) {

                      hedef.birikim = esitPara.clamp(0, hedef.hedef);
                    }
                  });

                },

                child: Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 270, 8),

                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.12),

                    borderRadius: BorderRadius.circular(10),

                    border: Border.all(
                      color: Colors.blue.withOpacity(0.4),
                    ),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: const [

                      Icon(
                        Icons.call_split,
                        color: Colors.white,
                        size: 15,
                      ),

                      SizedBox(width: 3),

                      Text(
                        "Parayı Eşit Böl",

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),




              // Ana para uyarısı — toplam birikim anaPara'yı geçince gösterilir
              if (_uyariVar)
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
                  ),
                  child: Row(children: const [
                    Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(kAnaParaUyari,
                          style: TextStyle(color: Colors.redAccent, fontSize: 11)),
                    ),
                  ]),
                ),

              // Hedef kartları
              Expanded(
                child: _hedefler.isEmpty
                    ? const Center(child: Text(kHenuzHedef, style: TextStyle(color: kGrey)))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _hedefler.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 18),
                        itemBuilder: (_, i) => HedefKarti(
                          hedef: _hedefler[i],
                          onTap: () => _hedefSecenekler(_hedefler[i]),
                          onBirikimDegisti: () => setState(() {}), // slider değişince ekranı yenile
                        ),
                      ),
              ),
            ]),
          ),

          // ══ ALT YARI — AI Sohbet ═══════════════════════════
          const Expanded(child: AiSohbet()),

        ]),
      ),
    );
  }
}

// ─── Çalıştırma noktası ────────────────────────────────────
void main() => runApp(const MaterialApp(
  debugShowCheckedModeBanner: false,
  home: GoalsAiPage(),
));