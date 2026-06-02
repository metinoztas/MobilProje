import 'package:flutter/material.dart';
import '../../sabitler/giris_dekoru.dart';
import '../../sabitler/renkler.dart';

class AciklamaAlani extends StatefulWidget {
  final TextEditingController controller;

  const AciklamaAlani({super.key, required this.controller});

  @override
  State<AciklamaAlani> createState() => _AciklamaAlaniState();
}

class _AciklamaAlaniState extends State<AciklamaAlani> {
  int _karakterSayisi = 0;

  static const int _maks = 100;

  @override
  void initState() {
    super.initState();
    _karakterSayisi = widget.controller.text.length;
    widget.controller.addListener(_guncelle);
  }

  void _guncelle() {
    if (!mounted) return;
    if (widget.controller.text.length != _karakterSayisi) {
      setState(() => _karakterSayisi = widget.controller.text.length);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_guncelle);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AlanEtiketi('Açıklama'),
        Stack(
          children: [
            TextField(
              controller: widget.controller,
              maxLength: _maks,
              maxLines: 2,
              minLines: 2,
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(
                color: Renkler.metinKoyu,
                fontSize: 14,
              ),
              decoration: girisDekoru(
                hint: 'Harcama açıklaması girin...',
                counterText: '',
              ),
            ),
            Positioned(
              right: 12,
              bottom: 8,
              child: Text(
                '$_karakterSayisi/$_maks',
                style: const TextStyle(
                  color: Renkler.metinAcik,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
