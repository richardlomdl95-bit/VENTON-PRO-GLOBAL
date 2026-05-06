import 'package:flutter/material.dart';
import '../theme.dart';
import '../venton_helpers.dart';

/// FAB que abre WhatsApp con mensaje pre-cargado.
/// Reutilizable en cualquier página.
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
    return FloatingActionButton.extended(
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
      icon: const Icon(Icons.chat),
      label: Text(etiqueta),
    );
  }
}
