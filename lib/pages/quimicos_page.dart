import 'package:flutter/material.dart';
import '../core/venton_config.dart';
import '../core/venton_helpers.dart';
import '../core/widgets/boton_whatsapp.dart';
import 'widgets/_grilla_productos.dart';

class QuimicosPage extends StatelessWidget {
  const QuimicosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Químicos Premium')),
      floatingActionButton: const BotonWhatsapp(
        mensaje: 'Hola VENTON PRO, quiero información de productos químicos.',
      ),
      body: GrillaProductos(
        productos: MockData.quimicosPremium,
        onPedir: (p) => VentonHelpers.abrirWhatsApp(
          mensaje: 'Hola VENTON PRO, quiero comprar: ${p.nombre}.',
        ),
      ),
    );
  }
}
