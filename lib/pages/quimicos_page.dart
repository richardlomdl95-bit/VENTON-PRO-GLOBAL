import 'package:flutter/material.dart';
import '../core/venton_config.dart';
import '../widgets/franja_venton.dart';
import 'widgets/_grilla_productos.dart';

class QuimicosPage extends StatelessWidget {
  const QuimicosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        title: const Text(
          'Químicos Premium',
          style: TextStyle(
            color: Color(0xFFD4AF37),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
        elevation: 0,
      ),
      body: Column(
        children: [
          const FranjaVenton(
            mensajes: [
              '🧪 QUÍMICOS PREMIUM VENTON',
              '📲 Pedidos: WhatsApp 322 560 9121',
              '🚚 ENVÍOS A TODO COLOMBIA',
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GrillaProductos(productos: MockData.quimicosPremium),
          ),
        ],
      ),
    );
  }
}
