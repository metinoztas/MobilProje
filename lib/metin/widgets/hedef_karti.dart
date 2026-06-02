// lib/metin/widgets/hedef_karti.dart
// Hedef listesinde her satırda gösterilen kart widget'ı
// Progress bar slider olarak kullanılabilir

import 'package:flutter/material.dart';
import '../model/hedef.dart';
import '../model/sabitler.dart';

class HedefKarti extends StatefulWidget {
  final Hedef hedef;
  final VoidCallback onTap;
  final VoidCallback? onBirikimDegisti; // slider değişince üst widget'ı haberdar eder

  const HedefKarti({
    super.key,
    required this.hedef,
    required this.onTap,
    this.onBirikimDegisti,
  });

  @override
  State<HedefKarti> createState() => _HedefKartiState();
}

class _HedefKartiState extends State<HedefKarti> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kLine),
        ),
        child: Column(children: [

          // İkon + başlık + tutar
          Row(children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: widget.hedef.renk.withOpacity(0.18),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(widget.hedef.ikon, color: widget.hedef.renk, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.hedef.baslik,   style: const TextStyle(color: kText, fontWeight: FontWeight.w700, fontSize: 13)),
                  Text(widget.hedef.aciklama, style: const TextStyle(color: kGrey, fontSize: 11)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(paraFormat(widget.hedef.birikim), style: TextStyle(color: widget.hedef.renk, fontWeight: FontWeight.bold, fontSize: 13)),
                Text('/ ${paraFormat(widget.hedef.hedef)}', style: const TextStyle(color: kGrey, fontSize: 10)),
              ],
            ),
            const SizedBox(width: 4),
            const Icon(Icons.more_vert, color: kGrey, size: 16),
          ]),
          const SizedBox(height: 4),

          // Slider (progress bar gibi görünür ama sürüklenebilir)
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: widget.hedef.renk,
              inactiveTrackColor: kBg,
              thumbColor: widget.hedef.renk,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
              trackHeight: 5,
            ),
            child: Slider(
              value: widget.hedef.birikim,
              min: 0,
              max: widget.hedef.hedef,
              onChanged: (yeniDeger) {
                setState(() => widget.hedef.birikim = yeniDeger);
                widget.onBirikimDegisti?.call(); // üst widget'a haber ver
              },
            ),
          ),

          // Yüzde + kalan tutar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('%${widget.hedef.yuzdeInt} $kTamamlandi', style: const TextStyle(color: kGrey, fontSize: 10)),
              Text('$kKalan ${paraFormat(widget.hedef.kalan)}', style: const TextStyle(color: kGrey, fontSize: 10)),
            ],
          ),

        ]),
      ),
    );
  }
}