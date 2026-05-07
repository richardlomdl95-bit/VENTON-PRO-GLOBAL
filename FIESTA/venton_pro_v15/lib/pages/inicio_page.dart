import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/venton_config.dart';
import '../core/venton_helpers.dart';
import '../core/widgets/acceso_rapido.dart';
import '../core/widgets/banner_ad_slot.dart';
import '../core/widgets/banner_publicidad.dart';
import '../core/widgets/boton_whatsapp.dart';
import '../core/widgets/feed_reciente.dart';
import '../core/widgets/venton_logo.dart';
import 'cafe_page.dart';
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
      floatingActionButton: const BotonWhatsapp(),
      body: CustomScrollView(
        slivers: [
          _buildHeader(context),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 16),
                BannerPublicidad(
                  titulo: VentonConfig.slogan,
                  subtitulo: 'Productos premium · Turismo · Oportunidades',
                  icono: Icons.workspace_premium,
                  onTap: () => VentonHelpers.abrirWhatsApp(),
                ),
                const SizedBox(height: 24),
                _buildSeccionTitulo(context, 'Acceso rápido'),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AccesoRapido(
                    items: [
                      AccesoRapidoItem(
                        icono: Icons.terrain_rounded,
                        etiqueta: 'Turismo',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TurismoPage(),
                          ),
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
                          MaterialPageRoute(
                            builder: (_) => const QuimicosPage(),
                          ),
                        ),
                      ),
                      AccesoRapidoItem(
                        icono: Icons.casino_rounded,
                        etiqueta: 'Ruleta',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RuletaPage(),
                          ),
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
                        icono: Icons.chat_bubble_rounded,
                        etiqueta: 'Contacto',
                        color: AppTheme.whatsappGreen,
                        onTap: () => VentonHelpers.abrirWhatsApp(),
                      ),
                      AccesoRapidoItem(
                        icono: Icons.info_outline_rounded,
                        etiqueta: 'Info',
                        onTap: () => _mostrarAcercaDe(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildSeccionTitulo(context, 'Turismo destacado'),
                FeedReciente(
                  titulo: '',
                  items: MockData.turismoSantaRosa
                      .map(
                        (e) => FeedItem(
                          titulo: e.titulo,
                          subtitulo: VentonHelpers.formatearPrecio(e.precio),
                          imagenUrl: e.imagenUrl,
                          onTap: () => VentonHelpers.abrirWhatsApp(
                            mensaje:
                                'Hola VENTON PRO, me interesa: ${e.titulo}.',
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 8),
                _buildSeccionTitulo(context, 'Productos premium'),
                FeedReciente(
                  titulo: '',
                  items: MockData.quimicosPremium
                      .map(
                        (p) => FeedItem(
                          titulo: p.nombre,
                          subtitulo: VentonHelpers.formatearPrecio(p.precio),
                          imagenUrl: p.imagenUrl,
                          onTap: () => VentonHelpers.abrirWhatsApp(
                            mensaje:
                                'Hola VENTON PRO, quiero comprar: ${p.nombre}.',
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
      expandedHeight: 180,
      pinned: false,
      floating: false,
      backgroundColor: AppTheme.azulMarino,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.azulMarino,
                AppTheme.azulMarinoClaro,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -40,
                top: -20,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.bronce.withOpacity(0.1),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      const VentonProLogo(size: 64, conTexto: true),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              VentonConfig.appName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Text(
                              'Productos premium',
                              style: TextStyle(
                                color: AppTheme.bronceClaro,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          tooltip: 'Subir contenido',
                          icon: const Icon(
                            Icons.add_circle_outline,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SubirContenidoPage(),
                            ),
                          ),
                        ),
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

  Widget _buildSeccionTitulo(BuildContext context, String texto) {
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
          Text(
            texto,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.azulMarino,
                ),
          ),
        ],
      ),
    );
  }

  void _mostrarAcercaDe(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationIcon: const VentonProLogo(size: 64, conTexto: true),
      applicationName: VentonConfig.appName,
      applicationVersion: VentonConfig.appVersion,
      applicationLegalese: '© 2026 VENTON PRO\nProductos premium · Santa Rosa de Cabal, Risaralda',
    );
  }
}
