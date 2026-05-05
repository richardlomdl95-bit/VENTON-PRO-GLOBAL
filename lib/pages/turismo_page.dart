import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/venton_config.dart';
import '../core/venton_helpers.dart';

// =============================================================================

class TurismoPage extends StatelessWidget {
  const TurismoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Turismo Santa Rosa'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Descubre el Eje Cafetero',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text(
                    'Termales, cascadas, fincas cafeteras y la mejor gastronomía colombiana.',
                    style: TextStyle(color: Colors.white, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...VentonConfig.lugaresIniciales.map((lugar) =>
              _TurismoCard(lugar: lugar)),
          const SizedBox(height: 16),
          // ESPACIO PARA EXPERIENCIAS RESERVABLES
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(Icons.event_available,
                      size: 40, color: VentonConfig.brandPrimary),
                  const SizedBox(height: 12),
                  const Text('¿Eres operador turístico?',
                      style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text(
                      'Publica tus tours y experiencias en VENTON PRO. Llegamos a turistas de todo el mundo.',
                      textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () {
                      VentonHelpers.openWhatsApp(
                          'Hola, soy operador turístico y quiero publicar experiencias en VENTON PRO');
                    },
                    icon: const Icon(Icons.add_business),
                    label: const Text('Publicar mi experiencia'),
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

class _TurismoCard extends StatelessWidget {
  final Map<String, dynamic> lugar;
  const _TurismoCard({required this.lugar});

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
              imageUrl: lugar['imagen'],
              fit: BoxFit.cover,
              placeholder: (c, u) => Container(color: Colors.grey[200]),
              errorWidget: (c, u, e) => Container(color: Colors.grey[300]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lugar['nombre'],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(lugar['descripcion'],
                    style: TextStyle(color: Colors.grey[700])),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.attach_money,
                        size: 16, color: VentonConfig.brandPrimary),
                    Text(lugar['precio'],
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          VentonHelpers.logEvent('turismo_clicks',
                              {'destino': lugar['nombre']});
                          VentonHelpers.openWhatsApp(
                              'Hola, quiero información sobre ${lugar['nombre']}');
                        },
                        icon: const Icon(Icons.chat, size: 18),
                        label: const Text('Reservar'),
                        style: FilledButton.styleFrom(
                            backgroundColor: VentonConfig.brandSuccess),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      onPressed: () => VentonHelpers.abrirMapaExterno(
                          lugar['lat'], lugar['lng'],
                          nombre: lugar['nombre']),
                      icon: const Icon(Icons.directions),
                      tooltip: 'Cómo llegar',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
