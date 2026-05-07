import 'package:flutter/material.dart';
import '../core/venton_config.dart';
import 'widgets/_grilla_productos.dart';

class CafePage extends StatelessWidget {
  const CafePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Café Premium')),
      body: GrillaProductos(productos: MockData.cafeProductos),
    );
  }
}
