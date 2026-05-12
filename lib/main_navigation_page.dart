import 'package:flutter/material.dart';
import 'inicio_page.dart';
import 'turismo_page.dart';
import 'crear_page.dart';
import 'comunidad_page.dart';
import 'mas_page.dart';
import 'quimicos_page.dart';
import 'ruleta_page.dart';
import 'turismo_mapa_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;
  late PageController _pageController;
  late AnimationController _fabController;

  final List<Widget> _pages = [
    const InicioPage(),
    const TurismoPage(),
    const CrearPage(),
    const ComunidadPage(),
    const MasPage(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fabController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: Container(
        height: 80, // Altura extra para el botón central que sobresale
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Navegación normal
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Row(
                children: [
                  _buildNavItem(0, Icons.home, '🏠 Inicio'),
                  _buildNavItem(1, Icons.search, '🔍 Turismo'),
                  // Espacio para el botón central
                  Expanded(
                    child: Container(),
                  ),
                  _buildNavItem(3, Icons.group, '👥 Comunidad'),
                  _buildNavItem(4, Icons.settings, '⚙️ Más'),
                ],
              ),
            ),
            // Botón central destacado
            Positioned(
              left: MediaQuery.of(context).size.width / 2 - 32, // Centrado
              bottom: 20, // 20px sobre el bottom bar
              child: AnimatedBuilder(
                animation: _fabController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (_fabController.value * 0.1),
                    child: GestureDetector(
                      onTap: () => _onTabTapped(2),
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4A017),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFD4A017).withOpacity(0.4),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabTapped(index),
        child: Container(
          height: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? const Color(0xFFD4A017) : Colors.grey[400],
                size: 24,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFFD4A017) : Colors.grey[400],
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
