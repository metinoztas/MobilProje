// ============================================================
// DOSYA: ai_sayfa.dart
// KONUM: lib/Yigit/ai_icgoruler/
// GÖREV: Ana içgörüler ekranı (beyaz/açık tema).
//        Veri için yigit_background/fis_servisi.dart kullanır.
//        Sağ üstte QR buton ile FisKameraPage'e yönlendirir.
// ============================================================

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../qr_sayfası/fis_camera.dart';
import '../yigit_background/fis_servisi.dart';

class AiOngoruler extends StatelessWidget {
  const AiOngoruler({super.key});

  @override
  Widget build(BuildContext context) {
    final servis = FisServisi();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text(
          'AI İçgörüler',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FisKameraPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Öne Çıkan İçgörüler ---
            _sectionTitle('Öne Çıkan İçgörüler'),
            const SizedBox(height: 10),

            _buildInsightCard(
              Icons.trending_up,
              const Color(0xFFFF6B6B),
              'Yemek harcamaların arttı',
              'Bu ay yemek harcamaların geçen aya göre %30 arttı.',
              '%30 ↑',
            ),
            _buildInsightCard(
              Icons.shopping_cart,
              const Color(0xFFFFB347),
              'Alışveriş harcamaların yüksek',
              'Alışveriş harcamaların toplam harcamalarının %28\'ini oluşturuyor.',
              '%28',
            ),
            _buildInsightCard(
              Icons.check_circle,
              const Color(0xFF4CAF50),
              'Tasarruf etme potansiyelin var',
              'Bazı gereksiz harcamalarını azaltarak bu ay ₺1.250 tasarruf edebilirsin.',
              '₺1.250',
            ),

            const SizedBox(height: 20),

            // --- AI Önerisi ---
            _sectionTitleWithAction('AI Önerisi', 'Tümünü Gör', () => _tumOnerileriGoster(context)),
            const SizedBox(height: 10),
            _buildAiOneriCard(),

            const SizedBox(height: 20),

            // --- Gelecek Tahmini ---
            _sectionTitle('Gelecek Tahmini'),
            const SizedBox(height: 10),
            _buildLineChart(),

            const SizedBox(height: 20),

            // --- Günün Finansal İpucu ---
            _sectionTitle('Günün Finansal İpucu'),
            const SizedBox(height: 10),
            _buildTipCard(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: Colors.black87,
      ),
    );
  }

  Widget _sectionTitleWithAction(String title, String action, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: const Text(
            'Tümünü Gör →',
            style: TextStyle(
              color: Color(0xFF7B61FF),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInsightCard(
    IconData icon,
    Color iconColor,
    String title,
    String subtitle,
    String value,
  ) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: Colors.black54),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: iconColor,
                fontSize: 13,
              ),
            ),
            const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildAiOneriCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF7B61FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.restaurant, color: Color(0xFF7B61FF), size: 24),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dışarıdan yemek siparişini azalt',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Bu ay 8 kez yemek siparişi verdin. Haftada 1-2 kez sipariş vererek tasarruf edebilirsin.',
                    style: TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      _StatChip(label: 'Tahmini Tasarruf', value: '₺450 / ay'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    final List<FlSpot> gercekVeri = [
      const FlSpot(0, 3200),
      const FlSpot(1, 3800),
      const FlSpot(2, 3400),
      const FlSpot(3, 4100),
      const FlSpot(4, 3900),
    ];

    final List<FlSpot> tahminVeri = [
      const FlSpot(4, 3900),
      const FlSpot(5, 5900),
    ];

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Haziran ayı tahmini',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  Text(
                    '₺5.900',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Tahmini Harcama',
                    style: TextStyle(fontSize: 11, color: Colors.black38),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 140,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: Colors.grey.shade100,
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        getTitlesWidget: (value, _) => Text(
                          '${(value / 1000).toStringAsFixed(0)}K',
                          style: const TextStyle(
                            color: Colors.black38,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          const aylar = ['Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz'];
                          final idx = value.toInt();
                          if (idx < 0 || idx >= aylar.length) return const SizedBox();
                          return Text(
                            idx == 4
                                ? 'Mayıs\n(Gerçek)'
                                : idx == 5
                                    ? 'Haziran\n(Tahmin)'
                                    : aylar[idx],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black38,
                              fontSize: 8,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 5,
                  minY: 2000,
                  maxY: 7000,
                  lineBarsData: [
                    // Gerçekleşen
                    LineChartBarData(
                      spots: gercekVeri,
                      isCurved: true,
                      color: const Color(0xFF7B61FF),
                      barWidth: 2.5,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFF7B61FF).withOpacity(0.15),
                            const Color(0xFF7B61FF).withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                    // Tahmin (kesik çizgi)
                    LineChartBarData(
                      spots: tahminVeri,
                      isCurved: true,
                      color: const Color(0xFF7B61FF).withOpacity(0.5),
                      barWidth: 2,
                      dashArray: [6, 4],
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (_, _, _, _) => FlDotCirclePainter(
                          radius: 5,
                          color: const Color(0xFF7B61FF),
                          strokeWidth: 0,
                        ),
                      ),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard() {
    return Card(
      elevation: 0,
      color: const Color(0xFFEEFBEE),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: const Padding(
        padding: EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(Icons.lightbulb_outline, color: Color(0xFF4CAF50), size: 22),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Küçük tasarruflar, büyük değişimler yaratır. Bugün küçük bir adım at!',
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _tumOnerileriGoster(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '🤖 AI Tasarruf Önerileri',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.grey),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        _buildOneriDetayCard(
                          icon: Icons.restaurant,
                          color: const Color(0xFF7B61FF),
                          baslik: 'Dışarıdan yemek siparişini azalt',
                          aciklama: 'Bu ay 8 kez yemek siparişi verdin. Haftada 1-2 kez sipariş vererek ev yemeği yemeyi tercih edebilir ve ciddi miktarda tasarruf edebilirsin.',
                          tutar: '₺450 / ay',
                        ),
                        _buildOneriDetayCard(
                          icon: Icons.subscriptions_rounded,
                          color: const Color(0xFFFF6B6B),
                          baslik: 'Kullanılmayan abonelikleri iptal et',
                          aciklama: 'Son 3 aydır aktif olarak kullanmadığın 2 adet dijital yayın/eğlence aboneliğin tespit edildi. Bunları dondurmak veya iptal etmek bütçene doğrudan nefes aldıracaktır.',
                          tutar: '₺280 / ay',
                        ),
                        _buildOneriDetayCard(
                          icon: Icons.shopping_bag_rounded,
                          color: const Color(0xFF4CAF50),
                          baslik: 'Planlı market alışverişi',
                          aciklama: 'Market alışverişine liste hazırlamadan çıkmak, kasada plansız abur cubur ve gereksiz ürün harcamalarını %20 oranında tetikliyor. Haftalık liste yapmayı deneyin.',
                          tutar: '₺500 / ay',
                        ),
                        _buildOneriDetayCard(
                          icon: Icons.directions_bus_rounded,
                          color: const Color(0xFFFFB347),
                          baslik: 'Ulaşım giderlerini optimize et',
                          aciklama: 'Kısa mesafeli (3 km altı) yolculuklarda lüks taksi tercihleri yerine yürüyüş yapmayı veya toplu taşıma araçlarını tercih ederek bütçenizi koruyabilirsiniz.',
                          tutar: '₺350 / ay',
                        ),
                        _buildOneriDetayCard(
                          icon: Icons.coffee_rounded,
                          color: const Color(0xFF8B5A2B),
                          baslik: 'Günlük kahve rutinleri',
                          aciklama: 'Her gün dışarıda kahve zincirlerinden kahve almak yerine, evde demlenmiş kahve hazırlayıp termosunuza koyarak hem çevreye hem de cüzdanınıza katkı sağlayabilirsiniz.',
                          tutar: '₺180 / ay',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOneriDetayCard({
    required IconData icon,
    required Color color,
    required String baslik,
    required String aciklama,
    required String tutar,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  baslik,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  aciklama,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Potansiyel Tasarruf: $tutar',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF7B61FF).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(
          fontSize: 10,
          color: Color(0xFF7B61FF),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}