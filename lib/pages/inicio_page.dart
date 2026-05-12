import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:async';
import '../widgets/franja_venton.dart';
import 'turismo_page.dart';
import 'turismo_mapa_page.dart';
import 'comunidad_page.dart';
import 'mas_page.dart';
import 'subir_contenido_page.dart';
import 'quimicos_page.dart';
import 'ruleta_page.dart';
import 'politica_page.dart';
import 'terminos_page.dart';
import 'anunciar_page.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _kenBurnsController1;
  late AnimationController _kenBurnsController2;
  late AnimationController _kenBurnsController3;
  late AnimationController _fabController;
  int _currentPageIndex = 0;
  Timer? _autoScrollTimer;
  String _paisSeleccionado = '🇨🇴 Colombia';
  String _ciudadSeleccionada = 'Santa Rosa de Cabal';

  // Colores VENTON
  static const Color _dorado = Color(0xFFD4A017);
  static const Color _azulMarino = Color(0xFF0A2540);
  static const Color _fondoNegro = Color(0xFF0D0D0D);
  static const Color _blanco = Colors.white;
  static const Color _crema = Color(0xFFFFF8E7);
  static const Color _verdeWhatsApp = Color(0xFF25D366);
  static const Color _grafito = Color(0xFF1A1A1A);

  // Datos hardcodeados de destacados
  final List<Map<String, String>> _destacados = [
    {
      'nombre': 'Termales Santa Rosa de Cabal',
      'descripcion': 'Aguas termales naturales con cascada de 75 metros',
      'imagen': 'https://images.unsplash.com/photo-1583416750470-965b2707b355',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20me%20interesa%20Termales%20Santa%20Rosa',
      'lat': '4.8500',
      'lng': '-75.6000',
    },
    {
      'nombre': 'Hotel Tacurrumbi',
      'descripcion': 'Hospedaje tradicional en el centro de Santa Rosa',
      'imagen': 'https://images.unsplash.com/photo-1566073771259-6a8506099945',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20quiero%20reservar%20en%20Hotel%20Tacurrumbi',
      'lat': '4.8721',
      'lng': '-75.6234',
    },
    {
      'nombre': 'Restaurante La Leyenda del Chorizo',
      'descripcion': 'Chorizo santarrosano auténtico',
      'imagen': 'https://images.unsplash.com/photo-1544025162-d76694265947',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20quiero%20reservar%20en%20La%20Leyenda',
      'lat': '4.8694',
      'lng': '-75.6213',
    },
    {
      'nombre': 'Tour del Café Premium',
      'descripcion': 'Recorrido por fincas cafeteras con cata',
      'imagen': 'https://images.unsplash.com/photo-1442550528053-c431ecb55509',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20me%20interesa%20Tour%20del%20Cafe',
      'lat': '4.8650',
      'lng': '-75.6280',
    },
  ];

  // Datos de restaurantes
  final List<Map<String, String>> _restaurantes = [
    {
      'nombre': 'La Leyenda del Chorizo',
      'precio': '\$25.000',
      'imagen': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20quiero%20reservar%20en%20La%20Leyenda%20del%20Chorizo',
      'lat': '4.8694',
      'lng': '-75.6213',
    },
    {
      'nombre': 'Restaurante El Recreo',
      'precio': '\$30.000',
      'imagen': 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20quiero%20reservar%20en%20El%20Recreo',
      'lat': '4.8702',
      'lng': '-75.6224',
    },
    {
      'nombre': 'Asadero La Brasa',
      'precio': '\$22.000',
      'imagen': 'https://images.unsplash.com/photo-1546833999-b9f581a1996d',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20quiero%20reservar%20en%20Asadero%20La%20Brasa',
      'lat': '4.8688',
      'lng': '-75.6201',
    },
    {
      'nombre': 'Café del Parque',
      'precio': '\$18.000',
      'imagen': 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20quiero%20reservar%20en%20Café%20del%20Parque',
      'lat': '4.8696',
      'lng': '-75.6218',
    },
    {
      'nombre': 'Heladería Tradicional',
      'precio': '\$12.000',
      'imagen': 'https://images.unsplash.com/photo-1488900128323-21503983a07a',
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
      'imagen': 'https://images.unsplash.com/photo-1566073771259-6a8506099945',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20quiero%20reservar%20en%20Hotel%20Tacurrumbi',
      'lat': '4.8721',
      'lng': '-75.6234',
    },
    {
      'nombre': 'Hotel Las Heliconias',
      'precio': '\$150.000',
      'imagen': 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20quiero%20reservar%20en%20Hotel%20Las%20Heliconias',
      'lat': '4.8745',
      'lng': '-75.6256',
    },
    {
      'nombre': 'Eco-Hotel Termales del Otoño',
      'precio': '\$180.000',
      'imagen': 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20quiero%20reservar%20en%20Eco-Hotel%20Termales%20del%20Otoño',
      'lat': '4.8612',
      'lng': '-75.6189',
    },
    {
      'nombre': 'Hostal Casa Verde',
      'precio': '\$80.000',
      'imagen': 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20quiero%20reservar%20en%20Hostal%20Casa%20Verde',
      'lat': '4.8689',
      'lng': '-75.6298',
    },
    {
      'nombre': 'Hotel Termales Santa Rosa',
      'precio': '\$200.000',
      'imagen': 'https://images.unsplash.com/photo-1583416750470-965b2707b355',
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
      'imagen': 'https://images.unsplash.com/photo-1583416750470-965b2707b355',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20me%20interesa%20Termales%20Santa%20Rosa',
      'lat': '4.8500',
      'lng': '-75.6000',
    },
    {
      'nombre': 'Cascadas de San Ramón',
      'duracion': '4 horas',
      'imagen': 'https://images.unsplash.com/photo-1432405972618-c60b0225b8f9',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20me%20interesa%20Cascadas%20de%20San%20Ramón',
      'lat': '4.8400',
      'lng': '-75.5900',
    },
    {
      'nombre': 'Tour del Café Premium',
      'duracion': '6 horas',
      'imagen': 'https://images.unsplash.com/photo-1442550528053-c431ecb55509',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20me%20interesa%20Tour%20del%20Cafe',
      'lat': '4.8650',
      'lng': '-75.6280',
    },
  ];

  // Datos de historias
  final List<Map<String, String>> _historias = [
    {
      'nombre': 'Tu historia',
      'imagen': '',
      'tipo': 'add',
    },
    {
      'nombre': 'Hotel Tacurrumbi',
      'imagen': 'https://images.unsplash.com/photo-1566073771259-6a8506099945',
      'tipo': 'negocio',
    },
    {
      'nombre': 'La Leyenda',
      'imagen': 'https://images.unsplash.com/photo-1544025162-d76694265947',
      'tipo': 'negocio',
    },
    {
      'nombre': 'Termales',
      'imagen': 'https://images.unsplash.com/photo-1583416750470-965b2707b355',
      'tipo': 'negocio',
    },
    {
      'nombre': 'Tour Café',
      'imagen': 'https://images.unsplash.com/photo-1442550528053-c431ecb55509',
      'tipo': 'negocio',
    },
    {
      'nombre': 'Café Parque',
      'imagen': 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085',
      'tipo': 'negocio',
    },
    {
      'nombre': 'Eco-Hotel',
      'imagen': 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4',
      'tipo': 'negocio',
    },
    {
      'nombre': 'Cascadas',
      'imagen': 'https://images.unsplash.com/photo-1432405972618-c60b0225b8f9',
      'tipo': 'negocio',
    },
    {
      'nombre': 'Asadero',
      'imagen': 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1',
      'tipo': 'negocio',
    },
  ];

  // Datos de videos comunidad
  final List<Map<String, String>> _videosComunidad = [
    {
      'nombre': 'Carlos · La Leyenda',
      'imagen': 'https://images.unsplash.com/photo-1544025162-d76694265947',
    },
    {
      'nombre': 'María · Tacurrumbi',
      'imagen': 'https://images.unsplash.com/photo-1566073771259-6a8506099945',
    },
    {
      'nombre': 'Hernán · Termales',
      'imagen': 'https://images.unsplash.com/photo-1583416750470-965b2707b355',
    },
    {
      'nombre': 'Marta · Tour Café',
      'imagen': 'https://images.unsplash.com/photo-1442550528053-c431ecb55509',
    },
    {
      'nombre': 'Pedro · Café Parque',
      'imagen': 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085',
    },
  ];

  // Lista de países y ciudades
  final List<Map<String, String>> _paisesCiudades = [
    {'pais': '🇨🇴 Colombia', 'ciudad': 'Santa Rosa de Cabal', 'activo': 'true'},
    {'pais': '🇨🇴 Colombia', 'ciudad': 'Pereira', 'activo': 'false'},
    {'pais': '🇨🇴 Colombia', 'ciudad': 'Manizales', 'activo': 'false'},
    {'pais': '🇻🇪 Venezuela', 'ciudad': 'Caracas', 'activo': 'false'},
    {'pais': '🇻🇪 Venezuela', 'ciudad': 'Valencia', 'activo': 'false'},
    {'pais': '🇪🇸 España', 'ciudad': 'Madrid', 'activo': 'false'},
    {'pais': '🇪🇸 España', 'ciudad': 'Barcelona', 'activo': 'false'},
    {'pais': '🇺🇸 Estados Unidos', 'ciudad': 'Miami', 'activo': 'false'},
    {'pais': '🇺🇸 Estados Unidos', 'ciudad': 'New York', 'activo': 'false'},
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _kenBurnsController1 = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);
    _kenBurnsController2 = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);
    _kenBurnsController3 = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);
    
    _fabController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        if (_currentPageIndex < _destacados.length - 1) {
          _currentPageIndex++;
        } else {
          _currentPageIndex = 0;
        }
        _pageController.animateToPage(
          _currentPageIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _kenBurnsController1.dispose();
    _kenBurnsController2.dispose();
    _kenBurnsController3.dispose();
    _fabController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  void _mostrarSelectorPais() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Línea decorativa
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: _dorado,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Selecciona tu ciudad',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _paisesCiudades.length,
              itemBuilder: (context, index) {
                final item = _paisesCiudades[index];
                final isActive = item['activo'] == 'true';
                return ListTile(
                  leading: Text(
                    item['pais']!,
                    style: const TextStyle(fontSize: 20),
                  ),
                  title: Text(
                    item['ciudad']!,
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.grey,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: isActive 
                    ? const Icon(Icons.check_circle, color: _dorado)
                    : const Icon(Icons.lock, color: Colors.grey),
                  onTap: () {
                    Navigator.pop(context);
                    if (isActive) {
                      setState(() {
                        _paisSeleccionado = item['pais']!;
                        _ciudadSeleccionada = item['ciudad']!;
                      });
                    } else {
                      // Abrir WhatsApp para ciudades no activas
                      _abrirWhatsAppCiudad(item['ciudad']!);
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _abrirWhatsAppCiudad(String ciudad) async {
    final url = Uri.parse('https://wa.me/573225609121?text=Hola%20Ricardo%20quiero%20que%20VENTON%20PRO%20llegue%20a%20${Uri.encodeComponent(ciudad)}.%20Soy%20comerciante%20interesado.');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir WhatsApp')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fondoNegro,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Franja animada superior
            const FranjaVenton(
              mensajes: [
                '🔥 ANUNCIA TU NEGOCIO AQUI',
                '⭐ PLAN TOP 100.000 PESOS AL MES',
                '📲 WhatsApp 322 560 9121',
                '✨ PRIMER MES GRATIS PLAN SEMILLA',
                '🌴 SANTA ROSA DE CABAL',
              ],
            ),
            
            // CAMBIO 3 - Historias estilo Instagram arriba
            _buildHistoriasInstagram(),
            
            // BLOQUE 1 - HERO SANTA ROSA con selector de país
            _buildHeroSantaRosa(),
            
            // CAMBIO 2 - Sección Cómo Llegar
            _buildComoLlegar(),
            
            // BLOQUE 2 - DESTACADOS HOY
            _buildDestacadosHoy(),
            
            // BLOQUE 3 - DONDE COMER
            _buildDondeComer(),
            
            // BLOQUE 4 - DONDE DORMIR
            _buildDondeDormir(),
            
            // BLOQUE 5 - QUE HACER EN SANTA ROSA
            _buildQueHacer(),
            
            // CAMBIO 8 - Sección Videos de la Comunidad activa
            _buildVideosComunidad(),
            
            // BLOQUE 7 - MAPA INTERACTIVO
            _buildMapaInteractivo(),
            
            // BLOQUE 8 - RULETA VENTON
            _buildRuletaVenton(),
            
            // BLOQUE 9 - LLAMADO A LA ACCION COMERCIAL
            _buildLlamadoAccionComercial(),
            
            // CAMBIO 10 - Footer internacional
            _buildFooter(),
          ],
        ),
      ),
      // CAMBIO 7 - Botón flotante global
      floatingActionButton: AnimatedBuilder(
        animation: _fabController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + (_fabController.value * 0.1),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AnunciarPage()),
                );
              },
              backgroundColor: _dorado,
              mini: false,
              child: const Icon(Icons.campaign, color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  // CAMBIO 3 - Historias estilo Instagram arriba
  Widget _buildHistoriasInstagram() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _historias.length,
        itemBuilder: (context, index) {
          final historia = _historias[index];
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: Column(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _dorado, width: 3),
                    color: historia['tipo'] == 'add' ? _dorado : Colors.transparent,
                  ),
                  child: historia['tipo'] == 'add'
                    ? const Icon(Icons.add, color: Colors.black, size: 30)
                    : ClipOval(
                        child: Image.network(
                          historia['imagen']!,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(child: CircularProgressIndicator(color: _dorado));
                          },
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: _grafito,
                            child: const Icon(Icons.image, color: Colors.grey),
                          ),
                        ),
                      ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 80,
                  child: Text(
                    historia['nombre']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // BLOQUE 1 - HERO SANTA ROSA con selector de país
  Widget _buildHeroSantaRosa() {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Stack(
        children: [
          // Imagen de fondo
          ClipRRect(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
            child: Image.network(
              'https://images.unsplash.com/photo-1518684079-3c830dcef090',
              width: double.infinity,
              height: 280,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator(color: _dorado));
              },
              errorBuilder: (context, error, stackTrace) => Container(
                color: _azulMarino,
                child: const Center(child: Icon(Icons.landscape, color: _dorado, size: 50)),
              ),
            ),
          ),
          // Gradiente oscuro
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          // Selector de país arriba a la derecha
          Positioned(
            top: 16,
            right: 16,
            child: GestureDetector(
              onTap: _mostrarSelectorPais,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _dorado, width: 1),
                ),
                child: Text(
                  '$_paisSeleccionado - $_ciudadSeleccionada',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // Texto
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _ciudadSeleccionada.toUpperCase(),
                  style: const TextStyle(
                    color: _blanco,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Descubre, come y hospédate',
                  style: TextStyle(
                    color: _dorado,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // CAMBIO 2 - Sección Cómo Llegar
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
                    child: Image.network(
                      'https://images.unsplash.com/photo-1436491865332-7a61a109cc05',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: _grafito,
                          ),
                          child: const Center(child: CircularProgressIndicator(color: _dorado)),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
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

  // BLOQUE 2 - DESTACADOS HOY
  Widget _buildDestacadosHoy() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '🔥 DESTACADOS HOY',
                  style: TextStyle(
                    color: _dorado,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Plan Top',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 320,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              itemCount: _destacados.length,
              itemBuilder: (context, index) {
                final destacado = _destacados[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildDestacadoCard(destacado),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // Indicadores de puntos
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _destacados.length,
              (index) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == _currentPageIndex ? _dorado : Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDestacadoCard(Map<String, String> destacado) {
    return Container(
      width: double.infinity,
      height: 320,
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
          // Imagen de fondo
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              destacado['imagen']!,
              width: double.infinity,
              height: 320,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: _grafito,
                  ),
                  child: const Center(child: CircularProgressIndicator(color: _dorado)),
                );
              },
              errorBuilder: (context, error, stackTrace) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: _grafito,
                ),
                child: const Center(child: Icon(Icons.image, color: Colors.grey)),
              ),
            ),
          ),
          // Gradiente oscuro abajo
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
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
          // Badge DESTACADO
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _dorado,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'DESTACADO',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Botón compartir
          Positioned(
            top: 16,
            right: 16,
            child: GestureDetector(
              onTap: () => _compartirNegocio(destacado, 'negocio'),
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
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  destacado['nombre']!,
                  style: const TextStyle(
                    color: _blanco,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  destacado['descripcion']!,
                  style: const TextStyle(
                    color: _blanco,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final url = Uri.parse(destacado['whatsapp']!);
                      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('No se pudo abrir WhatsApp')),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.chat, color: Colors.white, size: 18),
                    label: const Text(
                      'Hablar por WhatsApp',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _verdeWhatsApp,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // CAMBIO 5 - Botón Ver en mapa
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _abrirMapa(destacado['lat']!, destacado['lng']!),
                    icon: const Icon(Icons.location_on, color: _dorado, size: 16),
                    label: const Text(
                      '📍 Ver en mapa',
                      style: TextStyle(
                        color: _dorado,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _dorado),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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
  }

  // BLOQUE 3 - DONDE COMER
  Widget _buildDondeComer() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '🍽️ DONDE COMER',
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                restaurante['imagen']!,
                width: 160,
                height: 120,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _grafito,
                    ),
                    child: const Center(child: CircularProgressIndicator(color: _dorado)),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: _grafito,
                  ),
                  child: const Center(child: Icon(Icons.restaurant, color: Colors.grey)),
                ),
              ),
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
        ],
      ),
    );
  }

  // BLOQUE 4 - DONDE DORMIR
  Widget _buildDondeDormir() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '🛏️ DONDE DORMIR',
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                hotel['imagen']!,
                width: 160,
                height: 120,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _grafito,
                    ),
                    child: const Center(child: CircularProgressIndicator(color: _dorado)),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: _grafito,
                  ),
                  child: const Center(child: Icon(Icons.hotel, color: Colors.grey)),
                ),
              ),
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
        ],
      ),
    );
  }

  // BLOQUE 5 - QUE HACER EN SANTA ROSA
  Widget _buildQueHacer() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '🏔️ QUE HACER EN SANTA ROSA',
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
              _buildExperienciaCard(_experiencias[0], _kenBurnsController1),
              const SizedBox(height: 16),
              _buildExperienciaCard(_experiencias[1], _kenBurnsController2),
              const SizedBox(height: 16),
              _buildExperienciaCard(_experiencias[2], _kenBurnsController3),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildExperienciaCard(Map<String, String> experiencia, AnimationController controller) {
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
              animation: controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (controller.value * 0.15),
                  child: child,
                );
              },
              child: Image.network(
                experiencia['imagen']!,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: _grafito,
                    ),
                    child: const Center(child: CircularProgressIndicator(color: _dorado)),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
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

  // CAMBIO 8 - Sección Videos de la Comunidad activa
  Widget _buildVideosComunidad() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '📹 VIDEOS DE LA COMUNIDAD',
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
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 9 / 16,
            children: [
              // Primer cuadro - PUBLICA TU VIDEO
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AnunciarPage()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: _dorado,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.videocam,
                        color: Colors.white,
                        size: 40,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '📹 PUBLICA TU VIDEO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Plan Top \$100.000/mes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Videos de comunidad
              ...List.generate(_videosComunidad.length, (index) {
                final video = _videosComunidad[index];
                return GestureDetector(
                  onTap: () async {
                    final url = Uri.parse('https://wa.me/573225609121?text=Hola%20me%20interesó%20tu%20video%20en%20VENTON%20PRO%20de%20${Uri.encodeComponent(video['nombre']!)}');
                    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No se pudo abrir WhatsApp')),
                        );
                      }
                    }
                  },
                  child: Container(
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
                          child: Image.network(
                            video['imagen']!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: _grafito,
                                ),
                                child: const Center(child: CircularProgressIndicator(color: _dorado)),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: _grafito,
                              ),
                              child: const Center(child: Icon(Icons.image, color: Colors.grey)),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
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
                        Center(
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          left: 8,
                          right: 8,
                          child: Text(
                            video['nombre']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Botón Ver todos los videos
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Próximamente')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _dorado,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Ver todos los videos →',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // BLOQUE 7 - MAPA INTERACTIVO
  Widget _buildMapaInteractivo() {
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

  // BLOQUE 8 - RULETA VENTON
  Widget _buildRuletaVenton() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '🎲 GIRA Y GANA',
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
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RuletaPage()),
              );
            },
            child: Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFD700), // dorado
                    Color(0xFFF97316), // naranja
                    Color(0xFFDC143C), // rojo
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    const Icon(
                      Icons.casino,
                      color: Colors.white,
                      size: 80,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'RULETA VENTON',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Gira y gana descuentos',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // BLOQUE 9 - LLAMADO A LA ACCION COMERCIAL
  Widget _buildLlamadoAccionComercial() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _dorado,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            '📣',
            style: TextStyle(fontSize: 40),
          ),
          const SizedBox(height: 16),
          const Text(
            'TU NEGOCIO AQUI',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Aparece en la primera pantalla y vende más',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                final url = Uri.parse('https://wa.me/573225609121?text=Hola%20Ricardo%20quiero%20anunciar%20mi%20negocio%20en%20VENTON%20PRO');
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
                'Hablar con Ricardo',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _verdeWhatsApp,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // CAMBIO 10 - Footer internacional
  Widget _buildFooter() {
    return Column(
      children: [
        const SizedBox(height: 40),
        Text(
          'VENTON PRO GLOBAL\n🇨🇴 Colombia · 🇻🇪 Venezuela · 🇪🇸 España · 🇺🇸 Estados Unidos\nHecho con cariño desde Santa Rosa de Cabal, Risaralda',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
