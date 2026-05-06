import 'package:flutter/material.dart';
import '../pages/inicio_page.dart';
import '../pages/turismo_page.dart';
import '../pages/negocios_page.dart';
import '../pages/vendedores_page.dart';
import '../pages/mas_page.dart';

/// Shell principal con NavigationBar inferior.
/// 5 destinos: Inicio, Turismo, Negocios, Vendedores, Más.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _indice = 0;

  static const List<Widget> _paginas = [
    InicioPage(),
    TurismoPage(),
    NegociosPage(),
    VendedoresPage(),
    MasPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _indice,
        children: _paginas,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: (i) => setState(() => _indice = i),
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
            icon: Icon(Icons.business_center_outlined),
            selectedIcon: Icon(Icons.business_center),
            label: 'Negocios',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups),
            label: 'Vendedores',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu),
            selectedIcon: Icon(Icons.menu_open),
            label: 'Más',
          ),
        ],
      ),
    );
  }
}
