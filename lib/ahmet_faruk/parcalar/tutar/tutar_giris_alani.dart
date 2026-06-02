import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../sabitler/giris_dekoru.dart';
import '../../sabitler/renkler.dart';

class TutarGirisAlani extends StatelessWidget {
  final TextEditingController controller;

  const TutarGirisAlani({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AlanEtiketi('Tutar'),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*[\.,]?\d{0,2}')),
          ],
          style: const TextStyle(
            color: Renkler.metinKoyu,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          decoration: girisDekoru(
            hint: '0,00',
            prefixIcon: const MorIkonKutu(Icons.currency_lira),
            suffixIcon: const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(
                Icons.calculate_outlined,
                color: Renkler.metinAcik,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
