import 'package:flutter/material.dart';
import '../yigit_background/fis_servisi.dart';

class FisKameraPage extends StatefulWidget {
  const FisKameraPage({super.key});

  @override
  State<FisKameraPage> createState() => _FisKameraPageState();
}

class _FisKameraPageState extends State<FisKameraPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _simuleEtVeKaydet() {
    final servis = FisServisi();
    
    // Simüle edilmiş QR verisi
    final yeniFis = servis.qrdenOku("Migros|Bugün|345.50|Market");
    servis.fisBal(yeniFis);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Fiş başarıyla tarandı ve kaydedildi! (₺345.50)'),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Fiş / QR Tara',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Kamera Görünümü Simülasyonu (Koyu Desenli Arka Plan)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.qr_code_scanner_rounded,
                  size: 120,
                  color: Colors.white.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'Kamerayı fişin QR koduna yaklaştırın',
                  style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
                ),
              ],
            ),
          ),

          // Tarama Çerçevesi
          Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF7B61FF), width: 3),
                borderRadius: BorderRadius.circular(24),
              ),
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Stack(
                    children: [
                      // Kırmızı tarama çizgisi animasyonu
                      Positioned(
                        top: 280 * _animationController.value,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 3,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Simülasyon Butonu
          Positioned(
            bottom: 60,
            left: 30,
            right: 30,
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: _simuleEtVeKaydet,
                  icon: const Icon(Icons.flash_on, color: Colors.white),
                  label: const Text(
                    'Fiş Taramayı Simüle Et',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B61FF),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Bu buton gerçek kamera yerine örnek bir fişi tarayıp sisteme ekler.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
