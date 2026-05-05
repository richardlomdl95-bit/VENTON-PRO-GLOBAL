import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../main_v3_backup.dart';

// =============================================================================

class InicioPage extends StatelessWidget {
  const InicioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VENTON PRO',
            style: TextStyle(
                fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        actions: [
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context, delegate: BusquedaGlobalDelegate());
              }),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // HERO de Santa Rosa
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 10,
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=1200',
                    fit: BoxFit.cover,
                    placeholder: (c, u) => Container(color: Colors.grey[300]),
                    errorWidget: (c, u, e) => Container(
                        color: VentonConfig.brandPrimary,
                        child: const Center(
                            child: Icon(Icons.terrain,
                                size: 80, color: Colors.white))),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Santa Rosa de Cabal',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(blurRadius: 8, color: Colors.black)
                              ])),
                      const SizedBox(height: 4),
                      Text('Patrimonio Cafetero · Termales · Cordillera',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.95),
                              fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Accesos rápidos
          const Text('Explora',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              _AccesoRapido(
                  icon: Icons.terrain,
                  titulo: 'Turismo',
                  color: const Color(0xFF2E7D32),
                  onTap: () =>
                      _irPagina(context, 1)),
              _AccesoRapido(
                  icon: Icons.campaign,
                  titulo: 'Publicidad',
                  color: const Color(0xFFE65100),
                  onTap: () => _irPagina(context, 2)),
              _AccesoRapido(
                  icon: Icons.coffee,
                  titulo: 'Café',
                  color: const Color(0xFF5D4037),
                  onTap: () => _irPagina(context, 3)),
              _AccesoRapido(
                  icon: Icons.handshake,
                  titulo: 'Vendedores',
                  color: const Color(0xFF6A1B9A),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const VendedoresPage()))),
            ],
          ),
          const SizedBox(height: 24),

          // Banner de invitación a vendedores
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [VentonConfig.brandPrimary, Color(0xFF1976D2)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Gana plata con VENTON PRO',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                const Text(
                    'Vendedores en Colombia y el mundo. Comisiones hasta 35%. Pago directo a tu cuenta.',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 14),
                FilledButton.icon(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const VendedorRegistroPage())),
                  icon: const Icon(Icons.handshake),
                  label: const Text('Quiero ser vendedor'),
                  style: FilledButton.styleFrom(
                      backgroundColor: VentonConfig.brandAccent,
                      foregroundColor: VentonConfig.brandPrimary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ESPACIO RESERVADO PARA ADMOB (apagado por ahora)
          // Cuando actives AdMob, descomenta y agrega google_mobile_ads
          // Container(height: 60, color: Colors.grey[200]),

          // Feed reciente
          const Text('Lo más reciente',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const FeedReciente(),
          const SizedBox(height: 24),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SubirContenidoPage())),
        backgroundColor: VentonConfig.brandAccent,
        foregroundColor: VentonConfig.brandPrimary,
        icon: const Icon(Icons.add_a_photo),
        label: const Text('Subir',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _irPagina(BuildContext context, int index) {
    final shell = context.findAncestorStateOfType<_HomeShellState>();
    shell?.setState(() => shell._index = index);
  }
}
