import 'package:flutter/material.dart';
import '../core/venton_config.dart';
import '../core/venton_helpers.dart';
import '../core/widgets/acceso_rapido.dart';
import '../core/widgets/banner_publicidad.dart';
import '../core/widgets/boton_whatsapp.dart';
import '../core/widgets/feed_reciente.dart';
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
      appBar: AppBar(
        title: const Text(VentonConfig.appName),
        actions: [
          IconButton(
            tooltip: 'Subir contenido',
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SubirContenidoPage(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: const BotonWhatsapp(),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          BannerPublicidad(
            titulo: VentonConfig.slogan,
            subtitulo: 'Productos premium · Turismo · Oportunidades',
            icono: Icons.rocket_launch,
            onTap: () => VentonHelpers.abrirWhatsApp(),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Text(
              'Acceso rápido',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          AccesoRapido(
            items: [
              AccesoRapidoItem(
                icono: Icons.terrain,
                etiqueta: 'Turismo',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TurismoPage()),
                ),
              ),
              AccesoRapidoItem(
                icono: Icons.coffee,
                etiqueta: 'Café',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CafePage()),
                ),
              ),
              AccesoRapidoItem(
                icono: Icons.science,
                etiqueta: 'Químicos',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QuimicosPage()),
                ),
              ),
              AccesoRapidoItem(
                icono: Icons.casino,
                etiqueta: 'Ruleta',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RuletaPage()),
                ),
              ),
              AccesoRapidoItem(
                icono: Icons.person_add,
                etiqueta: 'Ser vendedor',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const VendedorRegistroPage(),
                  ),
                ),
              ),
              AccesoRapidoItem(
                icono: Icons.upload,
                etiqueta: 'Subir',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SubirContenidoPage(),
                  ),
                ),
              ),
              AccesoRapidoItem(
                icono: Icons.chat,
                etiqueta: 'Contacto',
                onTap: () => VentonHelpers.abrirWhatsApp(),
              ),
              AccesoRapidoItem(
                icono: Icons.info_outline,
                etiqueta: 'Info',
                onTap: () => showAboutDialog(
                  context: context,
                  applicationName: VentonConfig.appName,
                  applicationVersion: VentonConfig.appVersion,
                  applicationLegalese: '© 2026 VENTON PRO',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FeedReciente(
            titulo: 'Turismo destacado',
            items: MockData.turismoSantaRosa
                .map(
                  (e) => FeedItem(
                    titulo: e.titulo,
                    subtitulo: VentonHelpers.formatearPrecio(e.precio),
                    imagenUrl: e.imagenUrl,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          FeedReciente(
            titulo: 'Productos premium',
            items: MockData.quimicosPremium
                .map(
                  (p) => FeedItem(
                    titulo: p.nombre,
                    subtitulo: VentonHelpers.formatearPrecio(p.precio),
                    imagenUrl: p.imagenUrl,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
