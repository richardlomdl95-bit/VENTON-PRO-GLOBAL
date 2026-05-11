import 'package:flutter/material.dart';
import '../core/venton_config.dart';
import '../core/widgets/tarjeta_vendedor.dart';
import 'vendedor_registro_page.dart';

class VendedoresPage extends StatelessWidget {
  const VendedoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vendedores = MockData.vendedoresDestacados;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        title: const Text(
          'Vendedores',
          style: TextStyle(
            color: Color(0xFFD4AF37),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
        actions: [
          IconButton(
            tooltip: 'Ser vendedor',
            icon: const Icon(Icons.person_add, color: Color(0xFFD4AF37)),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const VendedorRegistroPage(),
              ),
            ),
          ),
        ],
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: vendedores.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) => TarjetaVendedor(vendedor: vendedores[i]),
      ),
    );
  }
}
