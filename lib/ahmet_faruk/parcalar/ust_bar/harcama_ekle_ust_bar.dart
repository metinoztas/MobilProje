import 'package:flutter/material.dart';
import '../../sabitler/renkler.dart';

class HarcamaEkleUstBar extends StatelessWidget implements PreferredSizeWidget {
  const HarcamaEkleUstBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Renkler.arkaPlan,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: Renkler.metinKoyu),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          // Geri donus — simdilik bagli degil
        },
      ),
      title: const Text(
        'Harcama Ekle',
        style: TextStyle(
          color: Renkler.metinKoyu,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: () {
            // Yardim — simdilik bagli degil
          },
        ),
      ],
    );
  }
}
