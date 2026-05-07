import 'package:flutter/material.dart';
import '../core/venton_config.dart';
import '../core/venton_helpers.dart';
import '../core/widgets/boton_whatsapp.dart';
import 'widgets/_grilla_productos.dart';

class CafePage extends StatelessWidget {
  const CafePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Café Premium')),
      floatingActionButton: const BotonWhatsapp(
        mensaje: 'Hola VENTON PRO, quiero comprar café premium.',
      ),
      body: GrillaProductos(
        productos: MockData.cafeProductos,
        onPedir: (p) => VentonHelpers.abrirWhatsApp(
          mensaje: 'Hola VENTON PRO, quiero comprar: ${p.nombre}.',
        ),
      ),
    );
  }
}
