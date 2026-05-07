import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'venton_config.dart';

/// Utilidades reutilizables: WhatsApp, URLs y formato.
class VentonHelpers {
  VentonHelpers._();

  /// Abre WhatsApp con un mensaje pre-cargado al número oficial de VENTON PRO.
  static Future<bool> abrirWhatsApp({
    String? mensaje,
    String? numeroPersonalizado,
  }) async {
    final numero = numeroPersonalizado ?? VentonConfig.whatsappNumber;
    final texto = Uri.encodeComponent(
      mensaje ?? VentonConfig.mensajeBienvenida,
    );
    final uri = Uri.parse('https://wa.me/$numero?text=$texto');

    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  /// Abre cualquier URL externa.
  static Future<bool> abrirUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  /// Formatea un precio en COP de forma legible.
  /// Ej: 180000 -> "$ 180.000"
  static String formatearPrecio(double valor, {String moneda = 'COP'}) {
    final entero = valor.toInt();
    final str = entero.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    final simbolo = moneda == 'COP' ? r'$' : moneda;
    return '$simbolo ${buffer.toString()}';
  }

  /// Muestra SnackBar de error/aviso de forma centralizada.
  static void mostrarSnack(BuildContext context, String mensaje) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
