import 'package:flutter/material.dart';
import 'negocios_page.dart';
import 'vendedores_page.dart';
import 'ruleta_page.dart';
import 'quimicos_page.dart';
import 'favoritos_page.dart';
import 'turismo_mapa_page.dart';

class MasPage extends StatelessWidget {
  const MasPage({super.key});

  static const Color _crema = Color(0xFFFFF8E7);
  static const Color _azulOscuro = Color(0xFF0F1B3D);
  static const Color _dorado = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    final opciones = <Map<String, dynamic>>[
      {
        'icon': Icons.storefront_rounded,
        'label': 'Productos\nPremium',
        'color': _azulOscuro,
        'page': const NegociosPage(),
      },
      {
        'icon': Icons.handshake_rounded,
        'label': 'Vendedores',
        'color': const Color(0xFF2D5016),
        'page': const VendedoresPage(),
      },
      {
        'icon': Icons.casino_rounded,
        'label': 'Ruleta',
        'color': _dorado,
        'page': const RuletaPage(),
      },
      {
        'icon': Icons.science_rounded,
        'label': 'Químicos',
        'color': const Color(0xFFFF6B35),
        'page': const QuimicosPage(),
      },
      {
        'icon': Icons.favorite_rounded,
        'label': 'Favoritos',
        'color': const Color(0xFFE91E63),
        'page': const FavoritosPage(),
      },
      {
        'icon': Icons.map_rounded,
        'label': 'Mapa\nNegocios',
        'color': const Color(0xFF1976D2),
        'page': const TurismoMapaPage(),
      },
    ];

    return Scaffold(
      backgroundColor: _crema,
      appBar: AppBar(
        backgroundColor: _dorado,
        elevation: 0,
        title: const Text(
          'Más opciones',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            itemCount: opciones.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (_, i) {
              final o = opciones[i];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => o['page'] as Widget),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: (o['color'] as Color).withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          o['icon'] as IconData,
                          color: o['color'] as Color,
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        o['label'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _azulOscuro,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
