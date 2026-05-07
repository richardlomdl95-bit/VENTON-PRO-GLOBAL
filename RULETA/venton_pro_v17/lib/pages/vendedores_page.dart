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
      appBar: AppBar(
        title: const Text('Vendedores'),
        actions: [
          IconButton(
            tooltip: 'Ser vendedor',
            icon: const Icon(Icons.person_add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const VendedorRegistroPage(),
              ),
            ),
          ),
        ],
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
