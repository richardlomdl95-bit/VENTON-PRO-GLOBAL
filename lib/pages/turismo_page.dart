import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../core/theme.dart';
import '../core/venton_config.dart';
import '../core/venton_helpers.dart';
import '../widgets/franja_venton.dart';
import 'experiencia_detalle_page.dart';
import 'turismo_mapa_page.dart';

class TurismoPage extends StatefulWidget {
  const TurismoPage({super.key});

  @override
  State<TurismoPage> createState() => _TurismoPageState();
}

class _TurismoPageState extends State<TurismoPage> with TickerProviderStateMixin {
  late List<AnimationController> _kenBurnsControllers;
  late List<Animation<double>> _kenBurnsAnimations;

  // Colores VENTON
  static const Color _dorado = Color(0xFFD4A017);
  static const Color _azulMarino = Color(0xFF0A2540);
  static const Color _fondoNegro = Color(0xFF0D0D0D);
  static const Color _blanco = Colors.white;
  static const Color _verdeWhatsApp = Color(0xFF25D366);
  static const Color _grafito = Color(0xFF1A1A1A);

  // Datos de restaurantes
  final List<Map<String, String>> _restaurantes = [
    {
      'nombre': 'La Leyenda del Chorizo',
      'precio': '\$25.000',
      'imagen': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800&q=80',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20quiero%20reservar%20en%20La%20Leyenda%20del%20Chorizo',
      'lat': '4.8694',
      'lng': '-75.6213',
    },
    {
      'nombre': 'Restaurante El Recreo',
      'precio': '\$30.000',
      'imagen': 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800&q=80',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20quiero%20reservar%20en%20El%20Recreo',
      'lat': '4.8702',
      'lng': '-75.6224',
    },
    {
      'nombre': 'Asadero La Brasa',
      'precio': '\$22.000',
      'imagen': 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=800&q=80',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20quiero%20reservar%20en%20Asadero%20La%20Brasa',
      'lat': '4.8688',
      'lng': '-75.6201',
    },
    {
      'nombre': 'Café del Parque',
      'precio': '\$18.000',
      'imagen': 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800&q=80',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20quiero%20reservar%20en%20Café%20del%20Parque',
      'lat': '4.8696',
      'lng': '-75.6218',
    },
    {
      'nombre': 'Heladería Tradicional',
      'precio': '\$12.000',
      'imagen': 'https://images.unsplash.com/photo-1488900128323-21503983a07a?w=800&q=80',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20quiero%20reservar%20en%20Heladería%20Tradicional',
      'lat': '4.8691',
      'lng': '-75.6209',
    },
  ];

  // Datos de hoteles
  final List<Map<String, String>> _hoteles = [
    {
      'nombre': 'Hotel Tacurrumbi',
      'precio': '\$120.000',
      'imagen': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&q=80',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20quiero%20reservar%20en%20Hotel%20Tacurrumbi',
      'lat': '4.8721',
      'lng': '-75.6234',
    },
    {
      'nombre': 'Hotel Las Heliconias',
      'precio': '\$150.000',
      'imagen': 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=800&q=80',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20quiero%20reservar%20en%20Hotel%20Las%20Heliconias',
      'lat': '4.8745',
      'lng': '-75.6256',
    },
    {
      'nombre': 'Eco-Hotel Termales del Otoño',
      'precio': '\$180.000',
      'imagen': 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800&q=80',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20quiero%20reservar%20en%20Eco-Hotel%20Termales%20del%20Otoño',
      'lat': '4.8612',
      'lng': '-75.6189',
    },
    {
      'nombre': 'Hostal Casa Verde',
      'precio': '\$80.000',
      'imagen': 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800&q=80',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20quiero%20reservar%20en%20Hostal%20Casa%20Verde',
      'lat': '4.8689',
      'lng': '-75.6298',
    },
    {
      'nombre': 'Hotel Termales Santa Rosa',
      'precio': '\$200.000',
      'imagen': 'https://images.unsplash.com/photo-1583416750470-965b2707b355?w=800&q=80',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20quiero%20reservar%20en%20Hotel%20Termales%20Santa%20Rosa',
      'lat': '4.8693',
      'lng': '-75.6310',
    },
  ];

  // Datos de experiencias
  final List<Map<String, String>> _experiencias = [
    {
      'nombre': 'Termales Santa Rosa',
      'duracion': '1 día completo',
      'imagen': 'https://images.unsplash.com/photo-1583416750470-965b2707b355?w=800&q=80',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20me%20interesa%20Termales%20Santa%20Rosa',
      'lat': '4.8500',
      'lng': '-75.6000',
    },
    {
      'nombre': 'Cascadas de San Ramón',
      'duracion': '4 horas',
      'imagen': 'https://images.unsplash.com/photo-1432405972618-c60b0225b8f9?w=800&q=80',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20me%20interesa%20Cascadas%20de%20San%20Ramón',
      'lat': '4.8400',
      'lng': '-75.5900',
    },
    {
      'nombre': 'Tour del Café Premium',
      'duracion': '6 horas',
      'imagen': 'https://images.unsplash.com/photo-1442550528053-c431ecb55509?w=800&q=80',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20me%20interesa%20Tour%20del%20Cafe',
      'lat': '4.8650',
      'lng': '-75.6280',
    },
  ];

  @override
  void initState() {
    super.initState();
    _kenBurnsControllers = List.generate(
      _experiencias.length,
      (index) => AnimationController(
        duration: const Duration(seconds: 8),
        vsync: this,
      )..repeat(reverse: true),
    );
    _kenBurnsAnimations = _kenBurnsControllers
        .map((controller) => Tween<double>(begin: 1.0, end: 1.15).animate(
              CurvedAnimation(parent: controller, curve: Curves.easeInOut),
            ))
        .toList();
  }

  @override
  void dispose() {
    for (var controller in _kenBurnsControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _abrirMapa(String lat, String lng) async {
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir Google Maps')),
        );
      }
    }
  }

  void _compartirNegocio(Map<String, String> negocio, String tipo) {
    String mensaje;
    if (tipo == 'experiencia') {
      mensaje = '''🏞️ ${negocio['nombre']} - Santa Rosa de Cabal
${negocio['duracion']} - Una experiencia única en Risaralda
Descúbrela en VENTON PRO 👇
https://ventonpro.com''';
    } else {
      mensaje = '''🌴 ${negocio['nombre']} - Santa Rosa de Cabal, Colombia
${negocio['descripcion']}
Mira más en VENTON PRO 👇
https://ventonpro.com
Descarga la app: vitrina digital de Santa Rosa de Cabal''';
    }
    
    Share.share(mensaje);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fondoNegro,
      appBar: AppBar(
        backgroundColor: _fondoNegro,
        title: const Text(
          'Turismo en Santa Rosa',
          style: TextStyle(
            color: _dorado,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: _dorado),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TurismoMapaPage(),
                ),
              );
            },
            icon: const Icon(Icons.map, color: _dorado),
            tooltip: 'Ver mapa de hoteles',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const FranjaVenton(
              mensajes: [
                '🌴 SANTA ROSA DE CABAL',
                '📲 Reserva por WhatsApp',
                '⭐ EXPERIENCIAS VERIFICADAS',
              ],
            ),
            const SizedBox(height: 16),

            // Sección CÓMO LLEGAR (movida desde Inicio)
            _buildComoLlegar(),

            // Sección DÓNDE COMER (movida desde Inicio)
            _buildDondeComer(),

            // Sección DÓNDE DORMIR (movida desde Inicio)
            _buildDondeDormir(),

            // Sección QUÉ HACER (movida desde Inicio)
            _buildQueHacer(),

            // Sección EXPLORA EL PUEBLO (movida desde Inicio)
            _buildExploraPueblo(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Sección CÓMO LLEGAR
  Widget _buildComoLlegar() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '✈️ CÓMO LLEGAR',
                style: TextStyle(
                  color: _dorado,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=800&q=80',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: _grafito,
                        ),
                        child: const Center(child: CircularProgressIndicator(color: _dorado)),
                      ),
                      errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: _grafito,
                        ),
                        child: const Center(child: Icon(Icons.flight, color: Colors.grey)),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Desde cualquier parte del mundo',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Llega a Santa Rosa de Cabal',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '• Aeropuerto Matecaña Pereira (45 min en taxi)\n• Terminal de Transporte Pereira (40 min en bus)\n• Desde Bogotá: 7 horas por carretera\n• Desde Medellín: 5 horas por carretera\n• Desde Cali: 4 horas por carretera',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  final url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=Santa+Rosa+de+Cabal,Risaralda,Colombia');
                                  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('No se pudo abrir Google Maps')),
                                      );
                                    }
                                  }
                                },
                                icon: const Icon(Icons.location_on, color: Colors.black, size: 16),
                                label: const Text(
                                  '📍 Ver ruta en Google Maps',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _dorado,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  final url = Uri.parse('https://wa.me/573225609121?text=Hola%20quiero%20viajar%20a%20Santa%20Rosa%20de%20Cabal%20necesito%20info');
                                  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('No se pudo abrir WhatsApp')),
                                      );
                                    }
                                  }
                                },
                                icon: const Icon(Icons.chat, color: Colors.white, size: 16),
                                label: const Text(
                                  '💬 Pedir info de viaje',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _verdeWhatsApp,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Sección DÓNDE COMER
  Widget _buildDondeComer() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '🍽️ DÓNDE COMER',
              style: TextStyle(
                color: _dorado,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _restaurantes.length,
            itemBuilder: (context, index) {
              final restaurante = _restaurantes[index];
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: 12),
                child: _buildRestauranteCard(restaurante),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildRestauranteCard(Map<String, String> restaurante) {
    return GestureDetector(
      onTap: () async {
        final url = Uri.parse(restaurante['whatsapp']!);
        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No se pudo abrir WhatsApp')),
            );
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 160,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: restaurante['imagen']!,
                    width: 160,
                    height: 120,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: _grafito,
                      ),
                      child: const Center(child: CircularProgressIndicator(color: _dorado)),
                    ),
                    errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: _grafito,
                      ),
                      child: const Center(child: Icon(Icons.restaurant, color: Colors.grey)),
                    ),
                  ),
                ),
                // Botón compartir
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => _compartirNegocio(restaurante, 'negocio'),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.share, color: Colors.white, size: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            restaurante['nombre']!,
            style: const TextStyle(
              color: _blanco,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            restaurante['precio']!,
            style: const TextStyle(
              color: _dorado,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          // Botón Ver en mapa
          SizedBox(
            width: 160,
            child: OutlinedButton.icon(
              onPressed: () => _abrirMapa(restaurante['lat']!, restaurante['lng']!),
              icon: const Icon(Icons.location_on, color: _dorado, size: 12),
              label: const Text(
                '📍 Ver en mapa',
                style: TextStyle(
                  color: _dorado,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: _dorado),
                padding: const EdgeInsets.symmetric(vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Sección DÓNDE DORMIR
  Widget _buildDondeDormir() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '🛏️ DÓNDE DORMIR',
              style: TextStyle(
                color: _dorado,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _hoteles.length,
            itemBuilder: (context, index) {
              final hotel = _hoteles[index];
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: 12),
                child: _buildHotelCard(hotel),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildHotelCard(Map<String, String> hotel) {
    return GestureDetector(
      onTap: () async {
        final url = Uri.parse(hotel['whatsapp']!);
        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No se pudo abrir WhatsApp')),
            );
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 160,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: hotel['imagen']!,
                    width: 160,
                    height: 120,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: _grafito,
                      ),
                      child: const Center(child: CircularProgressIndicator(color: _dorado)),
                    ),
                    errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: _grafito,
                      ),
                      child: const Center(child: Icon(Icons.hotel, color: Colors.grey)),
                    ),
                  ),
                ),
                // Botón compartir
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => _compartirNegocio(hotel, 'negocio'),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.share, color: Colors.white, size: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hotel['nombre']!,
            style: const TextStyle(
              color: _blanco,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            hotel['precio']!,
            style: const TextStyle(
              color: _dorado,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          // Botón Ver en mapa
          SizedBox(
            width: 160,
            child: OutlinedButton.icon(
              onPressed: () => _abrirMapa(hotel['lat']!, hotel['lng']!),
              icon: const Icon(Icons.location_on, color: _dorado, size: 12),
              label: const Text(
                '📍 Ver en mapa',
                style: TextStyle(
                  color: _dorado,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: _dorado),
                padding: const EdgeInsets.symmetric(vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Sección QUÉ HACER
  Widget _buildQueHacer() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '🏞️ QUÉ HACER',
              style: TextStyle(
                color: _dorado,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _buildExperienciaCard(_experiencias[0], _kenBurnsAnimations[0]),
              const SizedBox(height: 16),
              _buildExperienciaCard(_experiencias[1], _kenBurnsAnimations[1]),
              const SizedBox(height: 16),
              _buildExperienciaCard(_experiencias[2], _kenBurnsAnimations[2]),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildExperienciaCard(Map<String, String> experiencia, Animation<double> animation) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Imagen de fondo con efecto Ken Burns
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Transform.scale(
                  scale: animation.value,
                  child: child,
                );
              },
              child: CachedNetworkImage(
                imageUrl: experiencia['imagen']!,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: _grafito,
                  ),
                  child: const Center(child: CircularProgressIndicator(color: _dorado)),
                ),
                errorWidget: (context, url, error) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: _grafito,
                  ),
                  child: const Center(child: Icon(Icons.landscape, color: Colors.grey)),
                ),
              ),
            ),
          ),
          // Gradiente oscuro abajo
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),
          // Botón compartir
          Positioned(
            top: 16,
            right: 16,
            child: GestureDetector(
              onTap: () => _compartirNegocio(experiencia, 'experiencia'),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.share, color: Colors.white, size: 18),
              ),
            ),
          ),
          // Contenido
          Positioned(
            bottom: 16,
            left: 16,
            right: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  experiencia['nombre']!,
                  style: const TextStyle(
                    color: _blanco,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  experiencia['duracion']!,
                  style: const TextStyle(
                    color: _dorado,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          // Botón flotante WhatsApp
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: _verdeWhatsApp,
              onPressed: () async {
                final url = Uri.parse(experiencia['whatsapp']!);
                if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No se pudo abrir WhatsApp')),
                    );
                  }
                }
              },
              child: const Icon(Icons.chat, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  // Sección EXPLORA EL PUEBLO
  Widget _buildExploraPueblo() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '🗺️ EXPLORA EL PUEBLO',
              style: TextStyle(
                color: _dorado,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    color: _azulMarino,
                    child: const Center(
                      child: Icon(
                        Icons.map,
                        color: _dorado,
                        size: 60,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TurismoMapaPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _dorado,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Ver mapa completo',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
