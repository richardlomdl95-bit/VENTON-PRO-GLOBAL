import 'package:flutter/material.dart';
import '../theme.dart';
import '../venton_helpers.dart';

class BotonWhatsapp extends StatelessWidget {
  final String? mensaje;
  final String etiqueta;

  const BotonWhatsapp({
    super.key,
    this.mensaje,
    this.etiqueta = 'WhatsApp',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppTheme.whatsappGreen.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () async {
          final ok = await VentonHelpers.abrirWhatsApp(mensaje: mensaje);
          if (!ok && context.mounted) {
            VentonHelpers.mostrarSnack(
              context,
              'No se pudo abrir WhatsApp. Verificá que esté instalado.',
            );
          }
        },
        backgroundColor: AppTheme.whatsappGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        icon: const Icon(Icons.chat_bubble, size: 22),
        label: Text(
          etiqueta,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
