// ============================================================
//  VENTON PRO - PÁGINA DE MAPA (OpenStreetMap, 100% gratis)
//  Archivo NUEVO e independiente. No toca ninguna pantalla
//  que ya esté hecha. Solo se suma.
// ============================================================
//
//  Qué hace:
//   - Muestra un mapa moderno (OpenStreetMap, sin tarjeta).
//   - Marca los negocios con un pin rojo.
//   - Al tocar un pin, abre el WhatsApp de ese negocio.
//
//  Lo único que usted edita aquí son los negocios de la lista
//  de abajo (nombre, tipo, ubicación y WhatsApp). Más adelante
//  estos saldrán solos desde Firebase y no tocará este archivo.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class PaginaMapa extends StatelessWidget {
  const PaginaMapa({super.key});

  // ----------------------------------------------------------
  //  NEGOCIOS DE EJEMPLO (zona Santa Rosa / Eje Cafetero).
  //  Cambie estos datos por sus negocios reales mientras
  //  conectamos Firebase. El WhatsApp va con código de país,
  //  sin "+" y sin espacios (Colombia = 57).
  // ----------------------------------------------------------
  static const List<Map<String, dynamic>> negocios = [
    {
      'nombre': 'Hotel Termales',
      'tipo': 'Hotel',
      'lat': 4.8333,
      'lng': -75.5500,
      'whatsapp': '573225609121',
    },
    {
      'nombre': 'Panadería La Esquina',
      'tipo': 'Panadería',
      'lat': 4.8702,
      'lng': -75.6210,
      'whatsapp': '573225609121',
    },
    {
      'nombre': 'Restaurante El Fogón',
      'tipo': 'Restaurante',
      'lat': 4.8675,
      'lng': -75.6240,
      'whatsapp': '573225609121',
    },
    {
      'nombre': 'Tienda Premium VENTON',
      'tipo': 'Productos',
      'lat': 4.8688,
      'lng': -75.6217,
      'whatsapp': '573225609121',
    },
  ];

  // Centro inicial del mapa (Santa Rosa de Cabal).
  static const LatLng _centro = LatLng(4.8688, -75.6217);

  // Abre el WhatsApp del negocio.
  Future<void> _abrirWhatsApp(String numero, String nombre) async {
    final mensaje = Uri.encodeComponent(
      'Hola $nombre, los vi en VENTON PRO y quiero más información.',
    );
    final url = Uri.parse('https://wa.me/$numero?text=$mensaje');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa VENTON PRO'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: _centro,
          initialZoom: 13,
          minZoom: 3,
          maxZoom: 18,
        ),
        children: [
          // Capa del mapa (OpenStreetMap, gratis).
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.ventonpro.app',
          ),

          // Pines de los negocios.
          MarkerLayer(
            markers: negocios.map((negocio) {
              return Marker(
                point: LatLng(
                  negocio['lat'] as double,
                  negocio['lng'] as double,
                ),
                width: 120,
                height: 70,
                child: GestureDetector(
                  onTap: () => _abrirWhatsApp(
                    negocio['whatsapp'] as String,
                    negocio['nombre'] as String,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: 3),
                          ],
                        ),
                        child: Text(
                          negocio['nombre'] as String,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 36,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          // Atribución a OpenStreetMap (requisito de la licencia
          // gratuita; no se quita).
          const RichAttributionWidget(
            attributions: [
              TextSourceAttribution('OpenStreetMap contributors'),
            ],
          ),
        ],
      ),
    );
  }
}
