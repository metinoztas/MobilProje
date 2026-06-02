import 'package:flutter/material.dart';
import '../../modeller/harcama_kategorisi.dart';
import '../../sabitler/giris_dekoru.dart';
import '../../sabitler/renkler.dart';

class KategoriSecici extends StatelessWidget {
  final HarcamaKategorisi? secilenKategori;
  final ValueChanged<HarcamaKategorisi?> onChanged;

  const KategoriSecici({
    super.key,
    required this.secilenKategori,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AlanEtiketi('Kategori'),
        DropdownButtonFormField<HarcamaKategorisi>(
          value: secilenKategori,
          isExpanded: true,
          decoration: girisDekoru(
            hint: 'Kategori seçiniz',
            prefixIcon: const MorIkonKutu(Icons.local_offer_outlined),
          ),
          icon: const Padding(
            padding: EdgeInsets.only(right: 4),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Renkler.metinAcik,
            ),
          ),
          dropdownColor: Colors.white,
          style: const TextStyle(
            color: Renkler.metinKoyu,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          items: HarcamaKategorisi.values
              .map(
                (kategori) => DropdownMenuItem(
                  value: kategori,
                  child: Text(kategori.ad),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
