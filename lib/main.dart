import 'package:flutter/material.dart';
import 'package:butce_takip/Samet/frontend/login_screen.dart';
import 'package:butce_takip/Eyuphan/Arayuz/anasayfa_kart.dart';
import 'package:butce_takip/ahmet_faruk/sayfalar/harcama_ekle_sayfasi.dart';
import 'package:butce_takip/Yigit/ai_icgoruler/ai_sayfa.dart';
import 'package:butce_takip/metin/mtnsayfa.dart';

void main() {
  runApp(const ButceTakipApp());
}

class ButceTakipApp extends StatelessWidget {
  const ButceTakipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bütçe Takip',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    AnaSayfa(),
    HarcamaEkleSayfasi(),
    AiOngoruler(),
    GoalsAiPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDarkTab = _currentIndex == 3;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDarkTab ? const Color(0xFF0F172A) : Colors.white,
          selectedItemColor: isDarkTab ? const Color(0xFFC084FC) : const Color(0xff635BFF),
          unselectedItemColor: isDarkTab ? Colors.grey.shade500 : Colors.grey.shade600,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Özet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline_rounded),
              activeIcon: Icon(Icons.add_circle_rounded),
              label: 'Harcama Ekle',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart_rounded),
              label: 'Analiz',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.stars_outlined),
              activeIcon: Icon(Icons.stars_rounded),
              label: 'Hedefler & AI',
            ),
          ],
        ),
      ),
    );
  }
}
