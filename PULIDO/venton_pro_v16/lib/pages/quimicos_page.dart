import 'package:flutter/material.dart';
import '../core/venton_config.dart';
import 'widgets/_grilla_productos.dart';

class QuimicosPage extends StatelessWidget {
  const QuimicosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Químicos Premium')),
      body: GrillaProductos(productos: MockData.quimicosPremium),
    );
  }
}
