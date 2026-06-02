import 'package:flutter/material.dart';
import '../../sabitler/renkler.dart';

class HarcamaKaydetButonu extends StatelessWidget {
  final VoidCallback onPressed;

  const HarcamaKaydetButonu({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.check_circle, size: 22),
        label: const Text(
          'Kaydet',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Renkler.kaydetButonu,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
