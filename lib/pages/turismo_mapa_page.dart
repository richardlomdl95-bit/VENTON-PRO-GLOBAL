// ============================================================================
// VENTON PRO - MÓDULO MAPA TURISMO SANTA ROSA DE CABAL
// Versión: 1.0  |  Flutter 3.24  |  Costo: $0
// ============================================================================
// Tecnología premium SIN Google Maps SDK:
// - Mapa: OpenStreetMap + tiles CartoDB Dark Matter (gratis, sin tarjeta)
// - Datos: 5 hoteles hardcoded (sin API calls)
// - Navegación: Google Maps externo vía url_launcher (sin SDK, sin API key)
// - Reservas: WhatsApp directo al dueño del hotel
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:url_launcher/url_launcher.dart';

class TurismoMapaPage extends StatefulWidget {
  const TurismoMapaPage({super.key});

  @override
  State<TurismoMapaPage> createState() => _TurismoMapaPageState();
}

class _TurismoMapaPageState extends State<TurismoMapaPage>
    with TickerProviderStateMixin {
  // Centro Santa Rosa de Cabal
  static const LatLng _santaRosa = LatLng(4.8587, -75.6133);

  // Paleta VENTON
  static const Color _negro = Color(0xFF0A0A0A);
  static const Color _grafito = Color(0xFF1A1A1A);
  static const Color _dorado = Color(0xFFD4AF37);
  static const Color _gris = Color(0xFF666666);

  final MapController _mapController = MapController();

  // 5 hoteles hardcoded de Santa Rosa de Cabal
  final List<HotelData> _hoteles = [
    HotelData(
      id: '1',
      nombre: 'Hotel Termales Santa Rosa',
      descripcion: 'Hoteles recomendados VENTON',
      foto: '',
      whatsapp: '573225609121',
      lat: 4.8693,
      lng: -75.6310,
      activo: true,
      recomendado: true,
    ),
    HotelData(
      id: '2',
      nombre: 'Hotel Tacurrumbi',
      descripcion: 'Hoteles recomendados VENTON',
      foto: '',
      whatsapp: '573225609121',
      lat: 4.8721,
      lng: -75.6234,
      activo: true,
      recomendado: true,
    ),
    HotelData(
      id: '3',
      nombre: 'Hostal Casa Verde',
      descripcion: 'Hoteles recomendados VENTON',
      foto: '',
      whatsapp: '573225609121',
      lat: 4.8689,
      lng: -75.6298,
      activo: true,
      recomendado: true,
    ),
    HotelData(
      id: '4',
      nombre: 'Hotel Las Heliconias',
      descripcion: 'Hoteles recomendados VENTON',
      foto: '',
      whatsapp: '573225609121',
      lat: 4.8745,
      lng: -75.6256,
      activo: true,
      recomendado: true,
    ),
    HotelData(
      id: '5',
      nombre: 'Eco-Hotel Termales del Otoño',
      descripcion: 'Hoteles recomendados VENTON',
      foto: '',
      whatsapp: '573225609121',
      lat: 4.8612,
      lng: -75.6189,
      activo: true,
      recomendado: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _negro,
      body: Stack(
        children: [
          // Mapa OpenStreetMap
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _santaRosa,
              initialZoom: 14.0,
              minZoom: 12.0,
              maxZoom: 18.0,
            ),
            children: [
              // Tiles de OpenStreetMap (CartoDB Dark Matter)
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.ventonpro.app',
              ),
              // Marcadores de hoteles
              MarkerLayer(
                markers: _hoteles.map((hotel) => _construirMarcador(hotel)).toList(),
              ),
            ],
          ),
          // Header personalizado
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Row(
                children: [
                  _BotonRedondo(
                    icono: Icons.arrow_back,
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: _grafito,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: _dorado, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.location_on,
                              color: _dorado, size: 18),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'SANTA ROSA DE CABAL',
                                  style: TextStyle(
                                    color: _dorado,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.4,
                                  ),
                                ),
                                Text(
                                  'Hoteles recomendados VENTON',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // CONSTRUCTOR DE MARCADORES
  // --------------------------------------------------------------------------
  Marker _construirMarcador(HotelData h) {
    return Marker(
      point: LatLng(h.lat, h.lng),
      width: 70,
      height: 90,
      child: GestureDetector(
        onTap: () => _mostrarTarjetaHotel(h),
        child: Stack(
          children: [
            // Pin principal
            Container(
              decoration: BoxDecoration(
                color: h.recomendado ? _dorado : _gris,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: h.foto.isNotEmpty
                    ? Image.network(
                        h.foto,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            Container(color: _grafito),
                        errorWidget: (_, __, ___) => const Icon(
                            Icons.hotel,
                            color: _dorado,
                            size: 22),
                      )
                    : const Icon(Icons.hotel,
                        color: _dorado, size: 22),
              ),
            ),
            if (h.recomendado)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: _dorado,
                    shape: BoxShape.circle,
                    border: Border.all(color: _negro, width: 2),
                  ),
                  child: const Icon(Icons.star,
                      color: _negro, size: 10),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // TARJETA DE HOTEL CON WHATSAPP
  // --------------------------------------------------------------------------
  void _mostrarTarjetaHotel(HotelData hotel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: _grafito,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Línea decorativa
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: _dorado,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            // Nombre del hotel
            Text(
              hotel.nombre,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Descripción
            Text(
              hotel.descripcion,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            // Botón WhatsApp
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final url = Uri.parse(
                    'https://wa.me/573225609121?text=Hola%20me%20interesa%20${Uri.encodeComponent(hotel.nombre)}',
                  );
                  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No se pudo abrir WhatsApp')),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.chat, color: Colors.white),
                label: const Text(
                  'Hablar con dueño',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// MODELO DE DATOS SIMPLIFICADO
// ============================================================================
class HotelData {
  final String id;
  final String nombre;
  final String descripcion;
  final String foto;
  final String whatsapp;
  final double lat;
  final double lng;
  final bool activo;
  final bool recomendado;

  const HotelData({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.foto,
    required this.whatsapp,
    required this.lat,
    required this.lng,
    required this.activo,
    required this.recomendado,
  });
}

// ============================================================================
// WIDGETS AUXILIARES
// ============================================================================
class _BotonRedondo extends StatelessWidget {
  final IconData icono;
  final VoidCallback onTap;

  const _BotonRedondo({
    required this.icono,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: _grafito,
          shape: BoxShape.circle,
          border: Border.all(color: _dorado, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icono, color: _dorado, size: 20),
      ),
    );
  }
}
