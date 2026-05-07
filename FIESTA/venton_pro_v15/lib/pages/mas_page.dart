import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/venton_config.dart';
import '../core/venton_helpers.dart';
import '../core/widgets/venton_logo.dart';
import 'cafe_page.dart';
import 'comunidad_page.dart';
import 'politica_page.dart';
import 'quimicos_page.dart';
import 'ruleta_page.dart';
import 'subir_contenido_page.dart';
import 'terminos_page.dart';

class MasPage extends StatelessWidget {
  const MasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: false,
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
                      AppTheme.azulMarinoOscuro,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const VentonProLogo(size: 100, conTexto: true),
                        const SizedBox(height: 8),
                        Text(
                          'Versión ${VentonConfig.appVersion}',
                          style: TextStyle(
                            color: AppTheme.bronceClaro,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 12),
              _seccion('Catálogo'),
              _item(
                context,
                icono: Icons.local_cafe_rounded,
                titulo: 'Café Premium',
                destino: const CafePage(),
              ),
              _item(
                context,
                icono: Icons.science_rounded,
                titulo: 'Químicos Premium',
                destino: const QuimicosPage(),
              ),
              _item(
                context,
                icono: Icons.casino_rounded,
                titulo: 'Ruleta VENTON',
                destino: const RuletaPage(),
              ),
              _item(
                context,
                icono: Icons.dynamic_feed_rounded,
                titulo: 'Comunidad VENTON',
                destino: const ComunidadPage(),
              ),
              _item(
                context,
                icono: Icons.upload_rounded,
                titulo: 'Subir contenido',
                destino: const SubirContenidoPage(),
              ),
              const Divider(indent: 56, height: 24),
              _seccion('Cuenta'),
              _itemAccion(
                context,
                icono: Icons.delete_outline_rounded,
                titulo: 'Eliminar mi cuenta y datos',
                subtitulo: 'Solicitar por WhatsApp',
                onTap: () => _solicitarEliminacion(context),
              ),
              const Divider(indent: 56, height: 24),
              _seccion('Legal'),
              _item(
                context,
                icono: Icons.privacy_tip_outlined,
                titulo: 'Política de privacidad',
                destino: const PoliticaPage(),
              ),
              _item(
                context,
                icono: Icons.description_outlined,
                titulo: 'Términos y condiciones',
                destino: const TerminosPage(),
              ),
              const Divider(indent: 56, height: 24),
              _seccion('Soporte'),
              _itemAccion(
                context,
                icono: Icons.chat_bubble_rounded,
                titulo: 'Contactar por WhatsApp',
                color: AppTheme.whatsappGreen,
                onTap: () => VentonHelpers.abrirWhatsApp(),
              ),
              _itemAccion(
                context,
                icono: Icons.info_outline_rounded,
                titulo: 'Acerca de ${VentonConfig.appName}',
                subtitulo: 'Versión ${VentonConfig.appVersion}',
                onTap: () => showAboutDialog(
                  context: context,
                  applicationIcon: const VentonProLogo(size: 64, conTexto: true),
                  applicationName: VentonConfig.appName,
                  applicationVersion: VentonConfig.appVersion,
                  applicationLegalese:
                      '© 2026 VENTON PRO\nProductos premium · Santa Rosa de Cabal, Risaralda',
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  'Hecho con ♥ en Colombia',
                  style: TextStyle(
                    color: AppTheme.azulMarino.withOpacity(0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _seccion(String titulo) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Text(
        titulo.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
          color: AppTheme.bronceOscuro,
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context, {
    required IconData icono,
    required String titulo,
    required Widget destino,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.azulMarino.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icono, color: AppTheme.azulMarino, size: 20),
      ),
      title: Text(
        titulo,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppTheme.bronce),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => destino),
      ),
    );
  }

  Widget _itemAccion(
    BuildContext context, {
    required IconData icono,
    required String titulo,
    String? subtitulo,
    Color? color,
    required VoidCallback onTap,
  }) {
    final c = color ?? AppTheme.azulMarino;
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: c.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icono, color: c, size: 20),
      ),
      title: Text(
        titulo,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: subtitulo != null ? Text(subtitulo) : null,
      trailing: const Icon(Icons.chevron_right, color: AppTheme.bronce),
      onTap: onTap,
    );
  }

  Future<void> _solicitarEliminacion(BuildContext context) async {
    final confirma = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar cuenta'),
        content: const Text(
          'Vamos a abrir WhatsApp para procesar tu solicitud de eliminación de cuenta y datos. ¿Continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
    if (confirma == true) {
      await VentonHelpers.abrirWhatsApp(
        mensaje:
            'Hola VENTON PRO, solicito la eliminación de mi cuenta y todos mis datos asociados.',
      );
    }
  }
}
