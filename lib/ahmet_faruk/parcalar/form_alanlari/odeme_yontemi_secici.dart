import 'package:flutter/material.dart';
import '../../modeller/odeme_yontemi.dart';
import '../../sabitler/giris_dekoru.dart';
import '../../sabitler/renkler.dart';

class OdemeYontemiSecici extends StatelessWidget {
  final OdemeYontemi? secilenOdemeYontemi;
  final ValueChanged<OdemeYontemi?> onChanged;

  const OdemeYontemiSecici({
    super.key,
    required this.secilenOdemeYontemi,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AlanEtiketi('Ödeme Yöntemi'),
        DropdownButtonFormField<OdemeYontemi>(
          value: secilenOdemeYontemi,
          isExpanded: true,
          decoration: girisDekoru(
            hint: 'Ödeme yöntemi seçiniz',
            prefixIcon: const MorIkonKutu(Icons.account_balance_wallet_outlined),
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
          items: OdemeYontemi.values
              .map(
                (yontem) => DropdownMenuItem(
                  value: yontem,
                  child: Text(yontem.ad),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
