import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../theme.dart';
import '../venton_helpers.dart';

class BotonesPublicacion extends StatelessWidget {
  final String? whatsappNumero;
  final String? titulo;
  final String? descripcion;

  const BotonesPublicacion({
    super.key,
    this.whatsappNumero,
    this.titulo,
    this.descripcion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildBoton(
                  context,
                  icono: Icons.message_rounded,
                  texto: 'WhatsApp',
                  color: const Color(0xFF25D366),
                  onTap: () {
                    final mensaje = titulo != null && descripcion != null
                        ? 'Hola, estoy interesado en: $titulo\n\n$descripcion'
                        : 'Hola, quiero información sobre esta publicación.';
                    VentonHelpers.abrirWhatsApp(
                      numero: whatsappNumero,
                      mensaje: mensaje,
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildBoton(
                  context,
                  icono: Icons.share_rounded,
                  texto: 'Compartir',
                  color: AppTheme.bronce,
                  onTap: () {
                    // Compartir app
                    final text = '''
Descarga VENTON PRO GLOBAL 🚀
Publicidad, negocios, turismo y comunidad.
👉 https://github.com/richardlomdl95-bit/VENTON-PRO-GLOBAL
''';
                    
                    Share.share(
                      text,
                      subject: 'VENTON PRO GLOBAL - La mejor app para negocios',
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildBoton(
                  context,
                  icono: Icons.report_problem_rounded,
                  texto: 'Reportar',
                  color: Colors.orange,
                  onTap: () {
                    // TODO: Implementar reportar
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Función de reportar próximamente'),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildBoton(
                  context,
                  icono: Icons.block_rounded,
                  texto: 'Bloquear usuario',
                  color: Colors.red,
                  onTap: () {
                    // TODO: Implementar bloquear
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Función de bloquear próximamente'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBoton(
    BuildContext context, {
    required IconData icono,
    required String texto,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icono, size: 18),
      label: Text(texto),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
