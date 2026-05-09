// ============================================================================
// VENTON PRO - MÓDULO MAPA TURISMO SANTA ROSA DE CABAL
// Versión: 1.0  |  Flutter 3.24  |  Costo: $0
// ============================================================================
// Tecnología premium SIN Google Maps SDK:
// - Mapa: OpenStreetMap + tiles CartoDB Dark Matter (gratis, sin tarjeta)
// - Datos: Firestore (collection: hoteles_santa_rosa)
// - Navegación: Google Maps externo vía url_launcher (sin SDK, sin API key)
// - Reservas: WhatsApp directo al dueño del hotel
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

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
  final List<HotelData> _hoteles = [];
  bool _cargando = true;
  String? _error;
  LatLng? _miUbicacion;

  @override
  void initState() {
    super.initState();
    _cargarHoteles();
    _intentarUbicacion();
  }

  // --------------------------------------------------------------------------
  // CARGA DE HOTELES DESDE FIRESTORE
  // --------------------------------------------------------------------------
  Future<void> _cargarHoteles() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('hoteles_santa_rosa')
          .where('activo', isEqualTo: true)
          .get();

      final lista = <HotelData>[];
      for (final doc in snap.docs) {
        try {
          lista.add(HotelData.fromMap(doc.id, doc.data()));
        } catch (_) {
          // Ignora documentos malformados, no rompe la pantalla
        }
      }

      if (!mounted) return;
      setState(() {
        _hoteles
          ..clear()
          ..addAll(lista);
        _cargando = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _cargando = false;
        _error = 'No se pudieron cargar los hoteles. Revisa tu conexión.';
      });
    }
  }

  // --------------------------------------------------------------------------
  // UBICACIÓN DEL USUARIO (opcional, no bloquea la pantalla)
  // --------------------------------------------------------------------------
  Future<void> _intentarUbicacion() async {
    try {
      final activo = await Geolocator.isLocationServiceEnabled();
      if (!activo) return;

      var permiso = await Geolocator.checkPermission();
      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
      }
      if (permiso == LocationPermission.denied ||
          permiso == LocationPermission.deniedForever) {
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (!mounted) return;
      setState(() {
        _miUbicacion = LatLng(pos.latitude, pos.longitude);
      });
    } catch (_) {
      // Silencioso: si falla, simplemente no se muestra el punto azul
    }
  }

  void _centrarEnMi() {
    if (_miUbicacion != null) {
      _mapController.move(_miUbicacion!, 16);
    } else {
      _mapController.move(_santaRosa, 14.5);
      _intentarUbicacion();
    }
  }

  void _centrarEnSantaRosa() {
    _mapController.move(_santaRosa, 14.5);
  }

  // --------------------------------------------------------------------------
  // BOTTOM SHEET DEL HOTEL
  // --------------------------------------------------------------------------
  void _abrirHotel(HotelData h) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _HotelSheet(hotel: h),
    );
  }

  // --------------------------------------------------------------------------
  // BUILD
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _negro,
      body: Stack(
        children: [
          // ----- MAPA -----
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: _santaRosa,
              initialZoom: 14.5,
              minZoom: 11,
              maxZoom: 18,
              interactionOptions: InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              // Tiles dark premium (CartoDB Dark Matter, gratis)
              TileLayer(
                urlTemplate:
                    'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}@2x.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.ventonpro.app',
                maxNativeZoom: 19,
                retinaMode: true,
                tileProvider: NetworkTileProvider(),
              ),

              // Mi ubicación (punto azul pulsante)
              if (_miUbicacion != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _miUbicacion!,
                      width: 22,
                      height: 22,
                      child: const _PuntoUbicacion(),
                    ),
                  ],
                ),

              // Marcadores hoteles
              MarkerLayer(
                markers: _hoteles.map(_construirMarker).toList(),
              ),
            ],
          ),

          // ----- TOP BAR -----
          SafeArea(
            child: Padding(
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
                        children: [
                          const Icon(Icons.location_on,
                              color: _dorado, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
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

          // ----- BOTONES FLOTANTES (derecha) -----
          Positioned(
            right: 14,
            bottom: 30,
            child: Column(
              children: [
                _BotonRedondo(
                  icono: Icons.center_focus_strong,
                  onTap: _centrarEnSantaRosa,
                  tooltip: 'Centrar mapa',
                ),
                const SizedBox(height: 10),
                _BotonRedondo(
                  icono: Icons.my_location,
                  onTap: _centrarEnMi,
                  tooltip: 'Mi ubicación',
                ),
              ],
            ),
          ),

          // ----- ESTADO DE CARGA -----
          if (_cargando)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(color: _dorado),
              ),
            ),

          // ----- ERROR -----
          if (_error != null && !_cargando)
            Positioned(
              left: 16,
              right: 16,
              bottom: 110,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _grafito,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.redAccent, width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: Colors.redAccent),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _error!,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 13),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _cargando = true;
                          _error = null;
                        });
                        _cargarHoteles();
                      },
                      child: const Text('Reintentar',
                          style: TextStyle(color: _dorado)),
                    ),
                  ],
                ),
              ),
            ),

          // ----- ATRIBUCIÓN LEGAL (obligatoria por OpenStreetMap) -----
          Positioned(
            bottom: 4,
            left: 8,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '© OpenStreetMap · CartoDB',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 9,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // MARCADOR PERSONALIZADO
  // --------------------------------------------------------------------------
  Marker _construirMarker(HotelData h) {
    return Marker(
      point: LatLng(h.lat, h.lng),
      width: 64,
      height: 78,
      alignment: Alignment.topCenter,
      child: GestureDetector(
        onTap: () => _abrirHotel(h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _grafito,
                    border: Border.all(
                      color: h.recomendado ? _dorado : _gris,
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: h.recomendado
                            ? _dorado.withOpacity(0.45)
                            : Colors.black.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: h.foto.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: h.foto,
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
            CustomPaint(
              size: const Size(14, 9),
              painter: _PuntaPainter(
                color: h.recomendado ? _dorado : _gris,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// MODELO DE DATOS
// ============================================================================
class HotelData {
  final String id;
  final String nombre;
  final String descripcion;
  final String foto;
  final String whatsapp; // formato: 573001234567 (sin + ni espacios)
  final double lat;
  final double lng;
  final bool recomendado;
  final String? precio; // opcional, ej: "Desde $180.000"

  HotelData({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.foto,
    required this.whatsapp,
    required this.lat,
    required this.lng,
    required this.recomendado,
    this.precio,
  });

  factory HotelData.fromMap(String id, Map<String, dynamic> m) {
    return HotelData(
      id: id,
      nombre: (m['nombre'] ?? 'Sin nombre').toString(),
      descripcion: (m['descripcion'] ?? '').toString(),
      foto: (m['foto'] ?? '').toString(),
      whatsapp: (m['whatsapp'] ?? '').toString().replaceAll(RegExp(r'[^0-9]'), ''),
      lat: (m['lat'] as num).toDouble(),
      lng: (m['lng'] as num).toDouble(),
      recomendado: m['recomendado'] == true,
      precio: m['precio']?.toString(),
    );
  }
}

// ============================================================================
// BOTTOM SHEET DEL HOTEL
// ============================================================================
class _HotelSheet extends StatelessWidget {
  final HotelData hotel;
  const _HotelSheet({required this.hotel});

  static const Color _grafito = Color(0xFF1A1A1A);
  static const Color _dorado = Color(0xFFD4AF37);

  Future<void> _whatsapp(BuildContext ctx) async {
    if (hotel.whatsapp.isEmpty) {
      _avisar(ctx, 'Este hotel aún no tiene WhatsApp configurado');
      return;
    }
    final msg = Uri.encodeComponent(
      'Hola, vi ${hotel.nombre} en VENTON PRO. Quiero información sobre disponibilidad y precios.',
    );
    final url = Uri.parse('https://wa.me/${hotel.whatsapp}?text=$msg');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      _avisar(ctx, 'No se pudo abrir WhatsApp');
    }
  }

  Future<void> _comoLlegar(BuildContext ctx) async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${hotel.lat},${hotel.lng}&travelmode=driving',
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      _avisar(ctx, 'No se pudo abrir Google Maps');
    }
  }

  void _avisar(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: _grafito,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.45,
      maxChildSize: 0.92,
      expand: false,
      builder: (_, scroll) {
        return Container(
          decoration: const BoxDecoration(
            color: _grafito,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: scroll,
            padding: EdgeInsets.zero,
            children: [
              // Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Foto
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: hotel.foto.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: hotel.foto,
                            fit: BoxFit.cover,
                            placeholder: (_, __) =>
                                Container(color: Colors.black26),
                            errorWidget: (_, __, ___) => Container(
                              color: Colors.black26,
                              child: const Icon(Icons.hotel,
                                  size: 60, color: Colors.white24),
                            ),
                          )
                        : Container(
                            color: Colors.black26,
                            child: const Icon(Icons.hotel,
                                size: 60, color: Colors.white24),
                          ),
                  ),
                ),
              ),

              // Badge recomendado
              if (hotel.recomendado)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _dorado,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.black, size: 14),
                        SizedBox(width: 6),
                        Text(
                          'RECOMENDADO VENTON',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Nombre
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
                child: Text(
                  hotel.nombre,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ),

              // Precio
              if (hotel.precio != null && hotel.precio!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    hotel.precio!,
                    style: const TextStyle(
                      color: _dorado,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              // Descripción
              if (hotel.descripcion.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Text(
                    hotel.descripcion,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),

              // BOTONES
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: () => _whatsapp(context),
                        icon: const Icon(Icons.chat, color: Colors.white),
                        label: const Text(
                          'RESERVAR POR WHATSAPP',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: () => _comoLlegar(context),
                        icon: const Icon(Icons.directions, color: _dorado),
                        label: const Text(
                          'CÓMO LLEGAR',
                          style: TextStyle(
                            color: _dorado,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: _dorado, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================================
// WIDGETS AUXILIARES
// ============================================================================
class _BotonRedondo extends StatelessWidget {
  final IconData icono;
  final VoidCallback onTap;
  final String? tooltip;

  const _BotonRedondo({
    required this.icono,
    required this.onTap,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final btn = Material(
      color: const Color(0xFF1A1A1A),
      shape: const CircleBorder(
        side: BorderSide(color: Color(0xFFD4AF37), width: 1),
      ),
      elevation: 6,
      shadowColor: Colors.black,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icono, color: const Color(0xFFD4AF37), size: 20),
        ),
      ),
    );
    return tooltip != null ? Tooltip(message: tooltip!, child: btn) : btn;
  }
}

class _PuntoUbicacion extends StatefulWidget {
  const _PuntoUbicacion();

  @override
  State<_PuntoUbicacion> createState() => _PuntoUbicacionState();
}

class _PuntoUbicacionState extends State<_PuntoUbicacion>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final t = _ctrl.value;
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 22 + (t * 14),
              height: 22 + (t * 14),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF4A9EFF).withOpacity((1 - t) * 0.5),
              ),
            ),
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF4A9EFF),
                border: Border.all(color: Colors.white, width: 2.5),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PuntaPainter extends CustomPainter {
  final Color color;
  _PuntaPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_PuntaPainter old) => old.color != color;
}
