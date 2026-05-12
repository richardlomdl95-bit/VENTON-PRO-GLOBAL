import 'package:flutter/material.dart';
import 'pages/inicio_page.dart';
import 'pages/turismo_page.dart';
import 'pages/crear_page.dart';
import 'pages/comunidad_page.dart';
import 'pages/mas_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State {
  int _currentIndex = 0;
  final List _pages = const [
    InicioPage(),
    TurismoPage(),
    CrearPage(),
    ComunidadPage(),
    MasPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, -2))],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(0, Icons.home_rounded, 'Inicio'),
                _navItem(1, Icons.explore_rounded, 'Turismo'),
                _centerButton(),
                _navItem(3, Icons.people_rounded, 'Comunidad'),
                _navItem(4, Icons.apps_rounded, 'Más'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final bool active = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: active ? const Color(0xFFD4A017) : Colors.grey, size: 26),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: active ? const Color(0xFFD4A017) : Colors.grey, fontSize: 11, fontWeight: active ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _centerButton() {
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = 2),
      child: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFD4A017)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          boxShadow: [BoxShadow(color: Color(0x80D4A017), blurRadius: 12, spreadRadius: 2)],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 34),
      ),
    );
  }
}
