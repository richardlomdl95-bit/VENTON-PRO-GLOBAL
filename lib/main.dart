import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pages/inicio_page.dart';
import 'pages/turismo_page.dart';
import 'pages/negocios_page.dart';
import 'pages/cafe_page.dart';
import 'pages/mas_page.dart';

// =============================================================================
// VENTON PRO v3.0 - main.dart (Modular)
// =============================================================================
// Compatible con Google Play Store policies (2026)
// Filosofía: "Un toque y listo. Lo más fácil del mundo."
// =============================================================================

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const VentonProApp());
}

class VentonProApp extends StatelessWidget {
  const VentonProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VENTON PRO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D47A1),
          brightness: Brightness.light,
        ),
      ),
      home: const HomeShell(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const InicioPage(),
    const TurismoPage(),
    const PublicidadPage(),
    const CafePage(),
    const MasPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.terrain_outlined),
            selectedIcon: Icon(Icons.terrain),
            label: 'Turismo',
          ),
          NavigationDestination(
            icon: Icon(Icons.campaign_outlined),
            selectedIcon: Icon(Icons.campaign),
            label: 'Publicidad',
          ),
          NavigationDestination(
            icon: Icon(Icons.coffee_outlined),
            selectedIcon: Icon(Icons.coffee),
            label: 'Café',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_outlined),
            selectedIcon: Icon(Icons.menu),
            label: 'Más',
          ),
        ],
      ),
    );
  }
}
