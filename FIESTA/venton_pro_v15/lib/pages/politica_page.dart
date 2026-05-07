import 'package:flutter/material.dart';
import '../core/venton_config.dart';
import '../core/venton_helpers.dart';

class PoliticaPage extends StatelessWidget {
  const PoliticaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Política de privacidad')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('VENTON PRO – Política de privacidad',
              style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Última actualización: 2026',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          _seccion(
            theme,
            'Información que recolectamos',
            'VENTON PRO solicita información mínima necesaria para conectarte con vendedores y oportunidades: nombre, ciudad, número de WhatsApp y datos del contenido que voluntariamente publiques en la app.',
          ),
          _seccion(
            theme,
            'Cómo usamos tu información',
            'Usamos tus datos exclusivamente para procesar tu solicitud, enviarte respuestas por WhatsApp, y mejorar el servicio. No vendemos ni compartimos tus datos con terceros sin tu consentimiento.',
          ),
          _seccion(
            theme,
            'Almacenamiento local',
            'La app guarda preferencias y progreso de la Ruleta en tu dispositivo. Estos datos se eliminan al desinstalar la app.',
          ),
          _seccion(
            theme,
            'Eliminación de cuenta y datos',
            'Podés solicitar la eliminación de tus datos en cualquier momento desde la opción "Eliminar cuenta" en el menú "Más", o escribiendo al WhatsApp oficial.',
          ),
          _seccion(
            theme,
            'Contacto',
            'Para cualquier consulta sobre tus datos, escribinos al WhatsApp oficial de VENTON PRO.',
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => VentonHelpers.abrirUrl(VentonConfig.urlPolitica),
            icon: const Icon(Icons.open_in_new),
            label: const Text('Ver versión completa en web'),
          ),
        ],
      ),
    );
  }

  Widget _seccion(ThemeData theme, String titulo, String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(texto, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
