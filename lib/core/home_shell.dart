import 'package:flutter/material.dart';

// =============================================================================
// VENTON PRO - HOME SHELL
// =============================================================================
// Navegación principal con bottom navigation bar
// =============================================================================

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class HomeShellState extends State<HomeShell> {
  int _index = 0;

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
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Inicio'),
          NavigationDestination(
              icon: Icon(Icons.terrain_outlined),
              selectedIcon: Icon(Icons.terrain),
              label: 'Turismo'),
          NavigationDestination(
              icon: Icon(Icons.campaign_outlined),
              selectedIcon: Icon(Icons.campaign),
              label: 'Publicidad'),
          NavigationDestination(
              icon: Icon(Icons.coffee_outlined),
              selectedIcon: Icon(Icons.coffee),
              label: 'Café'),
          NavigationDestination(
              icon: Icon(Icons.menu_outlined),
              selectedIcon: Icon(Icons.menu),
              label: 'Más'),
        ],
      ),
    );
  }
}

// =============================================================================
// PLACEHOLDER CLASSES (estas serán importadas desde pages/ en FASE 2)
// =============================================================================

// Estas clases son placeholders para que el archivo compile sin dependencias circulares
// En FASE 2 serán reemplazadas por imports desde lib/pages/

class InicioPage extends StatelessWidget {
  const InicioPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('InicioPage - Placeholder')),
    );
  }
}

class TurismoPage extends StatelessWidget {
  const TurismoPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('TurismoPage - Placeholder')),
    );
  }
}

class PublicidadPage extends StatelessWidget {
  const PublicidadPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('PublicidadPage - Placeholder')),
    );
  }
}

class CafePage extends StatelessWidget {
  const CafePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('CafePage - Placeholder')),
    );
  }
}

class MasPage extends StatelessWidget {
  const MasPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('MasPage - Placeholder')),
    );
  }
}
