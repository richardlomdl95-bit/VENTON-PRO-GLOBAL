import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/venton_config.dart';
import '../core/venton_helpers.dart';
import '../core/widgets/acceso_rapido.dart';
import '../core/widgets/banner_ad_slot.dart';
import '../core/widgets/banner_publicidad.dart';
import '../core/widgets/feed_reciente.dart';
import '../core/widgets/seccion_ofertas.dart';
import '../core/widgets/venton_logo.dart';
import 'buscar_page.dart';
import 'cafe_page.dart';
import 'experiencia_detalle_page.dart';
import 'favoritos_page.dart';
import 'producto_detalle_page.dart';
import 'quimicos_page.dart';
import 'ruleta_page.dart';
import 'subir_contenido_page.dart';
import 'turismo_page.dart';
import 'vendedor_registro_page.dart';

class InicioPage extends StatelessWidget {
  const InicioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildHeader(context),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 12),
                BannerPublicidad(
                  titulo: VentonConfig.slogan,
                  subtitulo: 'Premium · Turismo · Oportunidades',
                  icono: Icons.workspace_premium,
                  onTap: () => VentonHelpers.abrirWhatsApp(),
                ),
                const SizedBox(height: 18),
                _seccionTitulo(context, 'Acceso rápido'),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AccesoRapido(items: _accesos(context)),
                ),
                const SizedBox(height: 20),
                if (MockData.productosEnOferta.isNotEmpty) ...[
                  _seccionTitulo(
                    context,
                    'Ofertas del momento',
                    icono: Icons.local_fire_department_rounded,
                  ),
                  const SizedBox(height: 6),
                  SeccionOfertas(productos: MockData.productosEnOferta),
                  const SizedBox(height: 16),
                ],
                _seccionTitulo(context, 'Turismo destacado'),
                FeedReciente(
                  titulo: '',
                  items: MockData.turismoSantaRosa
                      .map(
                        (e) => FeedItem(
                          titulo: e.titulo,
                          subtitulo: VentonHelpers.formatearPrecio(e.precio),
                          imagenUrl: e.imagenUrl,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ExperienciaDetallePage(experiencia: e),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
                _seccionTitulo(context, 'Productos premium'),
                FeedReciente(
                  titulo: '',
                  items: MockData.destacadosInicio
                      .map(
                        (p) => FeedItem(
                          titulo: p.nombre,
                          subtitulo: VentonHelpers.formatearPrecio(p.precio),
                          imagenUrl: p.imagenUrl,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductoDetallePage(producto: p),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16),
                BannerAdSlot(
                  onTap: () => VentonHelpers.abrirWhatsApp(
                    mensaje:
                        'Hola VENTON PRO, quiero anunciar mi negocio en la app.',
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 110,
      pinned: false,
      floating: true,
      backgroundColor: AppTheme.azulMarino,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          tooltip: 'Buscar',
          icon: const Icon(Icons.search_rounded, color: Colors.white),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BuscarPage()),
          ),
        ),
        IconButton(
          tooltip: 'Favoritos',
          icon: const Icon(Icons.favorite_border_rounded, color: Colors.white),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FavoritosPage()),
          ),
        ),
        const SizedBox(width: 4),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppTheme.azulMarino, AppTheme.azulMarinoClaro],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -30,
                top: -30,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.bronce.withOpacity(0.1),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      const VentonProLogo(size: 44, conTexto: false),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            VentonConfig.appName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            'Productos premium',
                            style: TextStyle(
                              color: AppTheme.bronceClaro,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<AccesoRapidoItem> _accesos(BuildContext context) {
    return [
      AccesoRapidoItem(
        icono: Icons.terrain_rounded,
        etiqueta: 'Turismo',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TurismoPage()),
        ),
      ),
      AccesoRapidoItem(
        icono: Icons.local_cafe_rounded,
        etiqueta: 'Café',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CafePage()),
        ),
      ),
      AccesoRapidoItem(
        icono: Icons.science_rounded,
        etiqueta: 'Químicos',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const QuimicosPage()),
        ),
      ),
      AccesoRapidoItem(
        icono: Icons.casino_rounded,
        etiqueta: 'Ruleta',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RuletaPage()),
        ),
      ),
      AccesoRapidoItem(
        icono: Icons.person_add_rounded,
        etiqueta: 'Vendedor',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const VendedorRegistroPage(),
          ),
        ),
      ),
      AccesoRapidoItem(
        icono: Icons.upload_rounded,
        etiqueta: 'Subir',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const SubirContenidoPage(),
          ),
        ),
      ),
      AccesoRapidoItem(
        icono: Icons.favorite_rounded,
        etiqueta: 'Favoritos',
        color: AppTheme.bronceOscuro,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FavoritosPage()),
        ),
      ),
      AccesoRapidoItem(
        icono: Icons.chat_bubble_rounded,
        etiqueta: 'Contacto',
        color: AppTheme.azulMarino,
        onTap: () => VentonHelpers.abrirWhatsApp(),
      ),
    ];
  }

  Widget _seccionTitulo(
    BuildContext context,
    String texto, {
    IconData? icono,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 22,
            decoration: BoxDecoration(
              gradient: AppTheme.gradienteBronce,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          if (icono != null) ...[
            Icon(icono, color: AppTheme.bronceOscuro, size: 18),
            const SizedBox(width: 6),
          ],
          Text(
            texto,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppTheme.azulMarino,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
