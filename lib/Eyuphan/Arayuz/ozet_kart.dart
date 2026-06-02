// lib/Eyuphan/ozet_kart.dart
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false, // Sağ üstteki debug şeridini kaldırır
      home: Scaffold(
        backgroundColor: const Color(
          0xffF8F9FA,
        ), // Tasarımdaki açık gri arka plan
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: const [
                // Kartı test etmek için Expanded içine aldık
                Expanded(
                  child: OzetKart(
                    baslik: "Gelir",
                    miktar: "₺8.000,00",
                    ikon: Icons.arrow_downward,
                    ikonArkaPlan: Color(0xff27AE60),
                    miktarRenk: Color(0xff27AE60),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

// 2. SENİN TASARLADIĞIN WIDGET KODU
class OzetKart extends StatelessWidget {
  final String baslik;
  final String miktar;
  final IconData ikon;
  final Color ikonArkaPlan;
  final Color miktarRenk;

  const OzetKart({
    super.key,
    required this.baslik,
    required this.miktar,
    required this.ikon,
    required this.ikonArkaPlan,
    required this.miktarRenk,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // Kartın dikeyde gereksiz uzamasını önler
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: ikonArkaPlan.withOpacity(0.15),
            child: Icon(ikon, color: ikonArkaPlan, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            baslik,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            miktar,
            style: TextStyle(
              color: miktarRenk,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
