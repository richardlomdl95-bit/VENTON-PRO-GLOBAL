import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/venton_config.dart';
import '../core/venton_helpers.dart';

// =============================================================================

class CafePage extends StatelessWidget {
  const CafePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Café VENTON'),
        backgroundColor: const Color(0xFF5D4037),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF5D4037), Color(0xFF8D6E63)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Café de altura del Eje Cafetero',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text(
                    'Cultivado en las fincas de Santa Rosa de Cabal — Patrimonio Cultural Cafetero (UNESCO). Tostado fresco bajo demanda.',
                    style: TextStyle(color: Colors.white, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...VentonConfig.catalogoCafe
              .map((cafe) => _CafeCard(cafe: cafe)),
          const SizedBox(height: 16),
          Card(
            color: Colors.brown[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.subscriptions,
                      size: 36, color: Color(0xFF5D4037)),
                  const SizedBox(height: 8),
                  const Text('Suscripción Mensual',
                      style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text(
                      'Recibe tu kilo de café fresco cada mes. 15% descuento permanente + envío gratis dentro de Colombia.',
                      textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () {
                      VentonHelpers.openWhatsApp(
                          'Hola, quiero suscribirme al café mensual VENTON PRO');
                    },
                    icon: const Icon(Icons.coffee),
                    label: const Text('Suscribirme'),
                    style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF5D4037)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CafeCard extends StatelessWidget {
  final Map<String, dynamic> cafe;
  const _CafeCard({required this.cafe});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: CachedNetworkImage(
              imageUrl: cafe['imagen'],
              fit: BoxFit.cover,
              placeholder: (c, u) => Container(color: Colors.grey[200]),
              errorWidget: (c, u, e) => Container(
                  color: const Color(0xFF5D4037),
                  child: const Center(
                      child: Icon(Icons.coffee,
                          color: Colors.white, size: 60))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cafe['nombre'],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.terrain,
                        size: 14, color: Color(0xFF5D4037)),
                    const SizedBox(width: 4),
                    Text(cafe['altura'],
                        style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF5D4037),
                            fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(cafe['descripcion'],
                    style: TextStyle(color: Colors.grey[700])),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _PrecioBox(
                        titulo: 'LIBRA (500g)',
                        precioCOP: cafe['precioLibraCOP'],
                        precioUSD: cafe['precioLibraUSD'],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _PrecioBox(
                        titulo: 'KILO (1kg)',
                        precioCOP: cafe['precioKiloCOP'],
                        precioUSD: cafe['precioKiloUSD'],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      VentonHelpers.logEvent('cafe_pedido',
                          {'producto': cafe['nombre']});
                      _seleccionarFormato(context, cafe);
                    },
                    icon: const Icon(Icons.shopping_bag),
                    label: const Text('Pedir ahora'),
                    style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF5D4037),
                        padding: const EdgeInsets.symmetric(vertical: 12)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _seleccionarFormato(BuildContext context, Map<String, dynamic> cafe) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(cafe['nombre'],
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Selecciona presentación y molienda:'),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.scale),
              title: const Text('Libra (500g)'),
              onTap: () {
                Navigator.pop(ctx);
                _seleccionarMolienda(context, cafe, 'libra');
              },
            ),
            ListTile(
              leading: const Icon(Icons.scale),
              title: const Text('Kilo (1.000g)'),
              onTap: () {
                Navigator.pop(ctx);
                _seleccionarMolienda(context, cafe, 'kilo');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _seleccionarMolienda(
      BuildContext context, Map<String, dynamic> cafe, String formato) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('¿Cómo lo prefieres?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...['Grano entero', 'Molido grueso', 'Molido medio', 'Molido fino']
                .map((m) => ListTile(
                      leading: const Icon(Icons.coffee),
                      title: Text(m),
                      onTap: () {
                        Navigator.pop(ctx);
                        final precio = formato == 'libra'
                            ? cafe['precioLibraCOP']
                            : cafe['precioKiloCOP'];
                        VentonHelpers.openWhatsApp(
                            'Hola, quiero pedir:\n\n'
                            '${cafe['nombre']}\n'
                            'Presentación: $formato\n'
                            'Molienda: $m\n'
                            'Precio: \$${(precio / 1000).toStringAsFixed(0)}.000 COP');
                      },
                    )),
          ],
        ),
      ),
    );
  }
}

class _PrecioBox extends StatelessWidget {
  final String titulo;
  final int precioCOP;
  final int precioUSD;
  const _PrecioBox(
      {required this.titulo,
      required this.precioCOP,
      required this.precioUSD});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.brown[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(titulo,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D4037))),
          const SizedBox(height: 4),
          Text('\$${(precioCOP / 1000).toStringAsFixed(0)}.000',
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold)),
          Text('\$$precioUSD USD',
              style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }
}
