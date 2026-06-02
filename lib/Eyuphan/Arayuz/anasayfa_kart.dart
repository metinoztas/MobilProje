// lib/Eyuphan/Arayuz/anasayfa_kart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'ozet_kart.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: AnaSayfa()),
  );
}

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  String kullaniciAdi = "Metin";
  double numToplamHarcama = 5430.0;
  double numGelir = 15000.0;
  double numButce = 20000.0;

  double katYemek = 1900.0;
  double katFaturalar = 560.0;
  double katGiyim = 800.0;
  double katUlasim = 650.0;
  double katOdemeler = 1200.0;
  double katTeknoloji = 1500.0;
  double katBuyukHarcamalar = 2500.0;
  double katKucukHarcamalar = 320.0;

  List sonIslemler = [
    {
      "baslik": "Yemek Alışverişi",
      "altBaslik": "Yemek",
      "miktar": "-₺250,00",
      "tarih": "Bugün • 13:45",
    },
    {
      "baslik": "Aylık İnternet",
      "altBaslik": "Faturalar",
      "miktar": "-₺560,00",
      "tarih": "Bugün • 09:10",
    },
    {
      "baslik": "Kışlık Mont",
      "altBaslik": "Giyim",
      "miktar": "-₺800,00",
      "tarih": "Dün • 18:30",
    },
  ];

  // 🎯 HEDEFLER İÇİN YENİ DEĞİŞKENLER
  int aktifHedefSayisi = 0;
  String hedefAdi = "";
  double hedefFiyat = 0.0;
  double hedefAylikAyirilan = 0.0;
  String hedefHesaplananZaman = "";
  bool hedefVarMi = false;

  bool yukleniyor = true;
  bool backendBaglantisiVar = false;

  @override
  void initState() {
    super.initState();
    verileriBackenddenCek();
  }

  Future<void> verileriBackenddenCek() async {
    try {
      final url = Uri.parse('http://127.0.0.1:8000/api/dashboard');
      final response = await http.get(url).timeout(const Duration(seconds: 1));
      if (response.statusCode == 200) {
        setState(() {
          kullaniciAdi = "Metin";
          backendBaglantisiVar = true;
          yukleniyor = false;
        });
      }
    } catch (e) {
      setState(() {
        backendBaglantisiVar = false;
        yukleniyor = false;
      });
    }
  }

  // 🎯 SİHİRLİ HEDEF PLANLAMA VE MATEMATİKSEL HESAPLAMA PENCERESİ
  void hedefPlanlaPenceresi() {
    final TextEditingController isimController = TextEditingController();
    final TextEditingController fiyatController = TextEditingController();
    final TextEditingController aylikController = TextEditingController();
    String anlikSonuc = "Lütfen bilgileri girin...";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalState) {
            // Kullanıcı sayıları girdikçe anlık canlı hesaplama yapan iç mekanizma
            void zamanHesapla() {
              double? fiyat = double.tryParse(fiyatController.text);
              double? aylik = double.tryParse(aylikController.text);

              if (fiyat != null && aylik != null && aylik > 0 && fiyat > 0) {
                double toplamAy = fiyat / aylik;
                int tamAy = toplamAy.floor(); // Tam ay kısmı
                int kalanGun = ((toplamAy - tamAy) * 30)
                    .round(); // Küsurattan gün hesaplama

                modalState(() {
                  if (tamAy == 0) {
                    anlikSonuc =
                        "🎯 Yaklaşık $kalanGun gün sonra hedefine ulaşıyorsun!";
                  } else if (kalanGun == 0) {
                    anlikSonuc = "🎯 Tam $tamAy ay sonra hedefine ulaşıyorsun!";
                  } else {
                    anlikSonuc =
                        "🎯 $tamAy Ay, $kalanGun Gün sonra hedefine ulaşıyorsun!";
                  }
                });
              } else {
                modalState(() {
                  anlikSonuc = "Lütfen geçerli miktarlar girin...";
                });
              }
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Yeni Birikim Hedefi Koy 🎯",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff635BFF),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: isimController,
                      decoration: const InputDecoration(
                        labelText: "Ne almak istiyorsun?",
                        hintText: "Örn: PlayStation 5, Zara Ceket",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: fiyatController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => zamanHesapla(),
                      decoration: const InputDecoration(
                        labelText: "Hedefin Toplam Fiyatı (₺)",
                        hintText: "Örn: 18000",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: aylikController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => zamanHesapla(),
                      decoration: const InputDecoration(
                        labelText: "Aylık Ayırmayı Planladığın Miktar (₺)",
                        hintText: "Örn: 2000",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Canlı Sonuç Gösterim Kutusu
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xff635BFF).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xff635BFF).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        anlikSonuc,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff635BFF),
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff635BFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (isimController.text.isNotEmpty &&
                              double.tryParse(fiyatController.text) != null &&
                              double.tryParse(aylikController.text) != null) {
                            setState(() {
                              hedefVarMi = true;
                              aktifHedefSayisi = 1;
                              hedefAdi = isimController.text;
                              hedefFiyat = double.parse(fiyatController.text);
                              hedefAylikAyirilan = double.parse(
                                aylikController.text,
                              );
                              hedefHesaplananZaman = anlikSonuc.replaceAll(
                                "🎯 ",
                                "",
                              );
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          "Hedefi Cüzdana Ekle",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void gelirBelirlePenceresi() {
    final TextEditingController gelirController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Aylık Sabit Gelir Gir",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: gelirController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: "Örn: 25000",
            suffixText: "₺",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("İptal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff27AE60),
            ),
            onPressed: () {
              if (gelirController.text.isNotEmpty) {
                setState(() {
                  numGelir = double.tryParse(gelirController.text) ?? numGelir;
                });
                Navigator.pop(context);
              }
            },
            child: const Text(
              "Güncelle",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void harcamaEklePenceresi() {
    final TextEditingController miktarController = TextEditingController();
    final TextEditingController baslikController = TextEditingController();
    String secilenKategori = "Yemek";
    final List<String> kategoriler = [
      "Yemek",
      "Faturalar",
      "Giyim",
      "Ulaşım",
      "Ödemeler",
      "Teknoloji",
      "Büyük Harcamalar",
      "Küçük Harcamalar",
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Yeni Harcama Ekle",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: baslikController,
                      decoration: const InputDecoration(
                        labelText: "Harcama Başlığı / Detay",
                        hintText: "Örn: Burger King",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: miktarController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Harcama Miktarı (₺)",
                        hintText: "0.00",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Kategori Seçin:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 160,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListView.builder(
                        itemCount: kategoriler.length,
                        itemBuilder: (context, index) {
                          return RadioListTile<String>(
                            title: Text(kategoriler[index]),
                            value: kategoriler[index],
                            groupValue: secilenKategori,
                            activeColor: const Color(0xff635BFF),
                            onChanged: (value) {
                              modalState(() {
                                secilenKategori = value!;
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff635BFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          double? girilenMiktar = double.tryParse(
                            miktarController.text,
                          );
                          String girilenBaslik =
                              baslikController.text.isNotEmpty
                              ? baslikController.text
                              : secilenKategori;
                          if (girilenMiktar != null && girilenMiktar > 0) {
                            setState(() {
                              numToplamHarcama += girilenMiktar;
                              if (secilenKategori == "Yemek") {
                                katYemek += girilenMiktar;
                              }
                              if (secilenKategori == "Faturalar") {
                                katFaturalar += girilenMiktar;
                              }
                              if (secilenKategori == "Giyim") {
                                katGiyim += girilenMiktar;
                              }
                              if (secilenKategori == "Ulaşım") {
                                katUlasim += girilenMiktar;
                              }
                              if (secilenKategori == "Ödemeler") {
                                katOdemeler += girilenMiktar;
                              }
                              if (secilenKategori == "Teknoloji") {
                                katTeknoloji += girilenMiktar;
                              }
                              if (secilenKategori == "Büyük Harcamalar") {
                                katBuyukHarcamalar += girilenMiktar;
                              }
                              if (secilenKategori == "Küçük Harcamalar") {
                                katKucukHarcamalar += girilenMiktar;
                              }

                              sonIslemler.insert(0, {
                                "baslik": girilenBaslik,
                                "altBaslik": secilenKategori,
                                "miktar":
                                    "-₺${girilenMiktar.toStringAsFixed(2).replaceAll(".", ",")}",
                                "tarih": "Şimdi • Canlı",
                              });
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          "Harcamayı Kaydet",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (yukleniyor) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xff635BFF)),
        ),
      );
    }

    double tasarrufHesapla = numGelir - numToplamHarcama;

    return Scaffold(
      backgroundColor: const Color(0xffF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black),
        title: Text(
          backendBaglantisiVar
              ? "Sunucu: Bağlı 🟢"
              : "Sunucu: Çevrimdışı (Manuel Sunum Modu) 🟡",
          style: TextStyle(
            fontSize: 11,
            color: backendBaglantisiVar ? Colors.green : Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Icon(Icons.notifications_none, color: Colors.black),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Merhaba, $kullaniciAdi! 👋",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Finansal durumunu kontrol et.",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),

            // MOR TOPLAM HARCAMA KARTI
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xff8E7CFF), Color(0xff635BFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Toplam Harcama",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "₺${numToplamHarcama.toStringAsFixed(2).replaceAll(".", ",")}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                              size: 14,
                            ),
                            SizedBox(width: 4),
                            Text(
                              "Bu ay",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white38,
                    size: 64,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4'LÜ ÖZET KARTLAR SATIRI
            Row(
              children: [
                Expanded(
                  child: OzetKart(
                    baslik: "Gelir",
                    miktar: "₺${numGelir.toStringAsFixed(0)}",
                    ikon: Icons.arrow_downward,
                    ikonArkaPlan: const Color(0xff27AE60),
                    miktarRenk: const Color(0xff27AE60),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: OzetKart(
                    baslik: "Bütçe",
                    miktar: "₺${numButce.toStringAsFixed(0)}",
                    ikon: Icons.pie_chart_outline,
                    ikonArkaPlan: const Color(0xff2F80ED),
                    miktarRenk: const Color(0xff2F80ED),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: OzetKart(
                    baslik: "Tasarruf",
                    miktar: "₺${tasarrufHesapla.toStringAsFixed(0)}",
                    ikon: Icons.account_balance_wallet_outlined,
                    ikonArkaPlan: const Color(0xffF2994A),
                    miktarRenk: tasarrufHesapla >= 0
                        ? const Color(0xff27AE60)
                        : const Color(0xffEB5757),
                  ),
                ),
                const SizedBox(width: 4),

                // 🎯 BUTONA DÖNÜŞTÜRÜLMÜŞ HEDEFLER KARTI
                Expanded(
                  child: GestureDetector(
                    onTap:
                        hedefPlanlaPenceresi, // Tıklayınca üstteki sihirli pencere açılır
                    child: OzetKart(
                      baslik: "Hedefler",
                      miktar: aktifHedefSayisi == 0
                          ? "Koyulmadı"
                          : "$aktifHedefSayisi Aktif",
                      ikon: Icons.track_changes,
                      ikonArkaPlan: const Color(0xff635BFF),
                      miktarRenk: const Color(0xff635BFF),
                    ),
                  ),
                ),
              ],
            ),

            // 🎯 YENİ EKLENEN KISIM: CANLI HEDEF DURUM PANELİ
            if (hedefVarMi) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xff635BFF).withOpacity(0.15),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.stars,
                          color: Color(0xffF2994A),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Mevcut Hedef: $hedefAdi",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "₺${hedefFiyat.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      hedefHesaplananZaman,
                      style: const TextStyle(
                        color: Color(0xff635BFF),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Tasarımsal İlerleme Çubuğu (Simülasyon için %25 dolu gösteriyoruz)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: const LinearProgressIndicator(
                        value: 0.25,
                        minHeight: 6,
                        backgroundColor: Color(0xffF1F3F5),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xff635BFF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // GELİR KONTROL PANELİ SATIRI
            Row(
              children: [
                const Text(
                  "Gelir Ayarları",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    side: const BorderSide(color: Color(0xffE0E0E0)),
                  ),
                  onPressed: gelirBelirlePenceresi,
                  icon: const Icon(Icons.edit, size: 14, color: Colors.black87),
                  label: const Text(
                    "Gelir Tanımla",
                    style: TextStyle(color: Colors.black87, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff27AE60).withOpacity(0.1),
                    elevation: 0,
                  ),
                  onPressed: () => setState(() => numGelir += 1000),
                  icon: const Icon(
                    Icons.add,
                    size: 14,
                    color: Color(0xff27AE60),
                  ),
                  label: const Text(
                    "+1000",
                    style: TextStyle(
                      color: Color(0xff27AE60),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // HARCAMA DAĞILIMI
            const Text(
              "Harcama Dağılımı",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Stack(
                      children: [
                        PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 35,
                            sections: [
                              PieChartSectionData(
                                color: const Color(0xff635BFF),
                                value: katYemek == 0 ? 1 : katYemek,
                                title: '',
                                radius: 18,
                              ),
                              PieChartSectionData(
                                color: const Color(0xffEB5757),
                                value: katFaturalar == 0 ? 1 : katFaturalar,
                                title: '',
                                radius: 18,
                              ),
                              PieChartSectionData(
                                color: const Color(0xffF2994A),
                                value: katGiyim == 0 ? 1 : katGiyim,
                                title: '',
                                radius: 18,
                              ),
                              PieChartSectionData(
                                color: const Color(0xff2F80ED),
                                value: katUlasim == 0 ? 1 : katUlasim,
                                title: '',
                                radius: 18,
                              ),
                              PieChartSectionData(
                                color: const Color(0xff9B51E0),
                                value: katOdemeler == 0 ? 1 : katOdemeler,
                                title: '',
                                radius: 18,
                              ),
                              PieChartSectionData(
                                color: const Color(0xff56CCF2),
                                value: katTeknoloji == 0 ? 1 : katTeknoloji,
                                title: '',
                                radius: 18,
                              ),
                              PieChartSectionData(
                                color: const Color(0xff27AE60),
                                value: katBuyukHarcamalar == 0
                                    ? 1
                                    : katBuyukHarcamalar,
                                title: '',
                                radius: 18,
                              ),
                              PieChartSectionData(
                                color: const Color(0xff333333),
                                value: katKucukHarcamalar == 0
                                    ? 1
                                    : katKucukHarcamalar,
                                title: '',
                                radius: 18,
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Text(
                            "₺${numToplamHarcama.toStringAsFixed(0)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        _buildKategoriSatir(
                          "Yemek",
                          "₺${katYemek.toStringAsFixed(0)}",
                          const Color(0xff635BFF),
                        ),
                        _buildKategoriSatir(
                          "Faturalar",
                          "₺${katFaturalar.toStringAsFixed(0)}",
                          const Color(0xffEB5757),
                        ),
                        _buildKategoriSatir(
                          "Giyim",
                          "₺${katGiyim.toStringAsFixed(0)}",
                          const Color(0xffF2994A),
                        ),
                        _buildKategoriSatir(
                          "Ulaşım",
                          "₺${katUlasim.toStringAsFixed(0)}",
                          const Color(0xff2F80ED),
                        ),
                        _buildKategoriSatir(
                          "Ödemeler",
                          "₺${katOdemeler.toStringAsFixed(0)}",
                          const Color(0xff9B51E0),
                        ),
                        _buildKategoriSatir(
                          "Teknoloji",
                          "₺${katTeknoloji.toStringAsFixed(0)}",
                          const Color(0xff56CCF2),
                        ),
                        _buildKategoriSatir(
                          "Büyük Harc.",
                          "₺${katBuyukHarcamalar.toStringAsFixed(0)}",
                          const Color(0xff27AE60),
                        ),
                        _buildKategoriSatir(
                          "Küçük Harc.",
                          "₺${katKucukHarcamalar.toStringAsFixed(0)}",
                          const Color(0xff333333),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // SON İŞLEMLER
            Row(
              children: [
                const Text(
                  "Son İşlemler",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(
                  onPressed: harcamaEklePenceresi,
                  child: const Row(
                    children: [
                      Text(
                        "Yeni Ekle (Test)",
                        style: TextStyle(
                          color: Color(0xff635BFF),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.add_circle_outline,
                        color: Color(0xff635BFF),
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sonIslemler.length,
                separatorBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(height: 1, color: Color(0xffF1F3F5)),
                ),
                itemBuilder: (context, index) {
                  final islem = sonIslemler[index];
                  IconData ikonData = Icons.shopping_bag;
                  if (islem['altBaslik'] == "Yemek") {
                    ikonData = Icons.restaurant;
                  }
                  if (islem['altBaslik'] == "Faturalar") {
                    ikonData = Icons.receipt_long;
                  }
                  if (islem['altBaslik'] == "Ulaşım") {
                    ikonData = Icons.directions_bus;
                  }
                  if (islem['altBaslik'] == "Teknoloji") {
                    ikonData = Icons.computer;
                  }

                  return _buildIslemSatiri(
                    baslik: islem['baslik'],
                    altBaslik: islem['altBaslik'],
                    tarihSaat: islem['tarih'],
                    miktar: islem['miktar'],
                    ikon: ikonData,
                    ikonRenk: const Color(0xff635BFF),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildKategoriSatir(String baslik, String miktar, Color renk) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: renk, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            baslik,
            style: const TextStyle(fontSize: 11, color: Colors.black87),
          ),
          const Spacer(),
          Text(
            miktar,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildIslemSatiri({
    required String baslik,
    required String altBaslik,
    required String tarihSaat,
    required String miktar,
    required IconData ikon,
    required Color ikonRenk,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: ikonRenk.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(ikon, color: ikonRenk, size: 18),
      ),
      title: Text(
        baslik,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
      subtitle: Text(
        altBaslik,
        style: const TextStyle(color: Colors.grey, fontSize: 11),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            miktar,
            style: const TextStyle(
              color: Color(0xffEB5757),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            tarihSaat,
            style: const TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
