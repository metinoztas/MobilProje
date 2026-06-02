import 'package:flutter/material.dart';
import 'renkler.dart';

/// Form alanlari icin ortak InputDecoration olusturur.
InputDecoration girisDekoru({
  String? hint,
  Widget? prefixIcon,
  Widget? suffixIcon,
  String? counterText,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Renkler.metinAcik, fontSize: 14),
    prefixIcon: prefixIcon,
    prefixIconConstraints: const BoxConstraints(minWidth: 56, minHeight: 40),
    suffixIcon: suffixIcon,
    counterText: counterText,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: _kenar(),
    enabledBorder: _kenar(),
    focusedBorder: _kenar(odakli: true),
  );
}

OutlineInputBorder _kenar({bool odakli = false}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(
      color: odakli ? Renkler.morCerceve : Renkler.cerceve,
      width: odakli ? 1.4 : 1.0,
    ),
  );
}

/// Form alanlarinin solundaki yuvarlak mor ikon kutusu.
class MorIkonKutu extends StatelessWidget {
  final IconData ikon;

  const MorIkonKutu(this.ikon, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 4),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Renkler.morAcik,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Icon(ikon, color: Renkler.morKoyu, size: 18),
      ),
    );
  }
}

/// Form alanlarinin ustundeki etiket.
class AlanEtiketi extends StatelessWidget {
  final String metin;

  const AlanEtiketi(this.metin, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 2),
      child: Text(
        metin,
        style: const TextStyle(
          color: Renkler.metinKoyu,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
