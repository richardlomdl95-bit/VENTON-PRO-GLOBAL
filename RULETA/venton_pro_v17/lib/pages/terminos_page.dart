import 'package:flutter/material.dart';
import '../core/venton_config.dart';
import '../core/venton_helpers.dart';

class TerminosPage extends StatelessWidget {
  const TerminosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Términos y condiciones')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('VENTON PRO – Términos de uso',
              style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),
          _seccion(
            theme,
            'Aceptación',
            'Al usar la app de VENTON PRO aceptás estos términos. Si no estás de acuerdo, te pedimos no continuar usándola.',
          ),
          _seccion(
            theme,
            'Uso permitido',
            'La app está destinada a personas mayores de edad interesadas en productos premium, turismo y oportunidades de negocio en Colombia, USA y Venezuela.',
          ),
          _seccion(
            theme,
            'Contenido de usuarios',
            'El contenido que subas debe ser propio o tener autorización. VENTON PRO se reserva el derecho de revisar, aprobar o rechazar publicaciones.',
          ),
          _seccion(
            theme,
            'Ruleta y promociones',
            'La Ruleta VENTON es una mecánica promocional sin valor monetario directo. Los premios se entregan según disponibilidad y bajo verificación por parte del equipo.',
          ),
          _seccion(
            theme,
            'Limitación de responsabilidad',
            'VENTON PRO actúa como plataforma de conexión. Los acuerdos comerciales finales se establecen directamente entre las partes.',
          ),
          _seccion(
            theme,
            'Modificaciones',
            'Estos términos pueden actualizarse. Los cambios se notificarán a través de la app.',
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => VentonHelpers.abrirUrl(VentonConfig.urlTerminos),
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
