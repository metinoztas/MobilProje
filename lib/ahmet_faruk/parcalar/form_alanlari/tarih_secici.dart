import 'package:flutter/material.dart';
import '../../sabitler/giris_dekoru.dart';
import '../../sabitler/renkler.dart';

class TarihSecici extends StatelessWidget {
  final DateTime? secilenTarih;
  final ValueChanged<DateTime> onChanged;

  const TarihSecici({
    super.key,
    required this.secilenTarih,
    required this.onChanged,
  });

  // Turkce ay ve gun isimleri (paket kullanmadan)
  static const List<String> _aylar = [
    'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
    'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık',
  ];

  static const List<String> _gunler = [
    'Pazartesi', 'Salı', 'Çarşamba', 'Perşembe',
    'Cuma', 'Cumartesi', 'Pazar',
  ];

  String _bicimle(DateTime t) {
    // ornek: "24 Mayıs 2024, Cuma"
    return '${t.day} ${_aylar[t.month - 1]} ${t.year}, ${_gunler[t.weekday - 1]}';
  }

  Future<void> _tarihSec(BuildContext context) async {
    final simdi = DateTime.now();
    final secilen = await showDatePicker(
      context: context,
      initialDate: secilenTarih ?? simdi,
      firstDate: DateTime(2000),
      lastDate: DateTime(simdi.year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Renkler.morKoyu,
              onPrimary: Colors.white,
              onSurface: Renkler.metinKoyu,
            ),
          ),
          child: child!,
        );
      },
    );
    if (secilen != null) {
      onChanged(secilen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AlanEtiketi('Tarih'),
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _tarihSec(context),
          child: InputDecorator(
            decoration: girisDekoru(
              prefixIcon: const MorIkonKutu(Icons.calendar_today_outlined),
              suffixIcon: const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Renkler.metinAcik,
                ),
              ),
            ),
            child: Text(
              secilenTarih == null ? 'Tarih seçiniz' : _bicimle(secilenTarih!),
              style: TextStyle(
                color: secilenTarih == null
                    ? Renkler.metinAcik
                    : Renkler.metinKoyu,
                fontSize: 14,
                fontWeight: secilenTarih == null
                    ? FontWeight.normal
                    : FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
