import 'package:flutter/material.dart';
import '../core/venton_config.dart';
import '../core/venton_helpers.dart';
import '../core/widgets/boton_whatsapp.dart';
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
      floatingActionButton: const BotonWhatsapp(
        mensaje: 'Hola VENTON PRO, quiero contactar a un vendedor.',
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: vendedores.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final v = vendedores[i];
          return TarjetaVendedor(
            vendedor: v,
            onTap: () => VentonHelpers.abrirWhatsApp(
              mensaje:
                  'Hola, me interesa el perfil de ${v.nombre} en VENTON PRO.',
            ),
          );
        },
      ),
    );
  }
}
