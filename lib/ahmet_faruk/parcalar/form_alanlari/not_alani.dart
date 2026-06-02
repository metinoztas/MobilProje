import 'package:flutter/material.dart';
import '../../sabitler/giris_dekoru.dart';
import '../../sabitler/renkler.dart';

class NotAlani extends StatelessWidget {
  final TextEditingController controller;

  const NotAlani({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AlanEtiketi('Not (isteğe bağlı)'),
        TextField(
          controller: controller,
          minLines: 1,
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
          style: const TextStyle(
            color: Renkler.metinKoyu,
            fontSize: 14,
          ),
          decoration: girisDekoru(
            hint: 'Not eklemek ister misin?',
            prefixIcon: const MorIkonKutu(Icons.edit_outlined),
          ),
        ),
      ],
    );
  }
}
