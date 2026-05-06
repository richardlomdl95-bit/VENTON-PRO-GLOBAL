import 'package:flutter/material.dart';
import '../core/venton_config.dart';
import '../core/venton_helpers.dart';
import 'cafe_page.dart';
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
      appBar: AppBar(title: const Text('Más')),
      body: ListView(
        children: [
          _seccion('Catálogo'),
          _item(
            context,
            icono: Icons.coffee,
            titulo: 'Café Premium',
            destino: const CafePage(),
          ),
          _item(
            context,
            icono: Icons.science,
            titulo: 'Químicos Premium',
            destino: const QuimicosPage(),
          ),
          _item(
            context,
            icono: Icons.casino,
            titulo: 'Ruleta VENTON',
            destino: const RuletaPage(),
          ),
          _item(
            context,
            icono: Icons.upload,
            titulo: 'Subir contenido',
            destino: const SubirContenidoPage(),
          ),
          const Divider(),
          _seccion('Cuenta'),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Eliminar mi cuenta y datos'),
            subtitle: const Text('Solicitar por WhatsApp'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _solicitarEliminacion(context),
          ),
          const Divider(),
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
          const Divider(),
          _seccion('Soporte'),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Contactar por WhatsApp'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => VentonHelpers.abrirWhatsApp(),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text('Acerca de ${VentonConfig.appName}'),
            subtitle: Text('Versión ${VentonConfig.appVersion}'),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: VentonConfig.appName,
              applicationVersion: VentonConfig.appVersion,
              applicationLegalese: '© 2026 VENTON PRO',
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _seccion(String titulo) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        titulo.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
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
      leading: Icon(icono),
      title: Text(titulo),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => destino),
      ),
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
