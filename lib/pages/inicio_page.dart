import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
      'imagen': 'https://images.unsplash.com/photo-1583416750470-965b2707b355?w=800&q=80',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20me%20interesa%20Termales%20Santa%20Rosa',
      'lat': '4.8500',
      'lng': '-75.6000',
    },
    {
      'nombre': 'Hotel Tacurrumbi',
      'descripcion': 'Hospedaje tradicional en el centro de Santa Rosa',
      'imagen': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&q=80',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20quiero%20reservar%20en%20Hotel%20Tacurrumbi',
      'lat': '4.8721',
      'lng': '-75.6234',
    },
    {
      'nombre': 'Restaurante La Leyenda del Chorizo',
      'descripcion': 'Chorizo santarrosano auténtico',
      'imagen': 'https://images.unsplash.com/photo-1544025162-d76694265947?w=800&q=80',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20quiero%20reservar%20en%20La%20Leyenda',
      'lat': '4.8694',
      'lng': '-75.6213',
    },
    {
      'nombre': 'Tour del Café Premium',
      'descripcion': 'Recorrido por fincas cafeteras con cata',
      'imagen': 'https://images.unsplash.com/photo-1442550528053-c431ecb55509?w=800&q=80',
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
      'imagen': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&q=80',
      'tipo': 'negocio',
    },
    {
      'nombre': 'La Leyenda',
      'imagen': 'https://images.unsplash.com/photo-1544025162-d76694265947?w=800&q=80',
      'tipo': 'negocio',
    },
    {
      'nombre': 'Termales',
      'imagen': 'https://images.unsplash.com/photo-1583416750470-965b2707b355?w=800&q=80',
      'tipo': 'negocio',
    },
    {
      'nombre': 'Tour Café',
      'imagen': 'https://images.unsplash.com/photo-1442550528053-c431ecb55509?w=800&q=80',
      'tipo': 'negocio',
    },
    {
      'nombre': 'Café Parque',
      'imagen': 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800&q=80',
      'tipo': 'negocio',
    },
    {
      'nombre': 'Eco-Hotel',
      'imagen': 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800&q=80',
      'tipo': 'negocio',
    },
    {
      'nombre': 'Cascadas',
      'imagen': 'https://images.unsplash.com/photo-1432405972618-c60b0225b8f9?w=800&q=80',
      'tipo': 'negocio',
    },
    {
      'nombre': 'Asadero',
      'imagen': 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800&q=80',
      'tipo': 'negocio',
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

  void _compartirNegocio(Map<String, String> destacado) {
    final mensaje = '''🌴 ${destacado['nombre']} - Santa Rosa de Cabal, Colombia
${destacado['descripcion']}
Mira más en VENTON PRO 👇
https://ventonpro.com
Descarga la app: vitrina digital de Santa Rosa de Cabal''';
    
    Share.share(mensaje);
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
            
            // Historias estilo Instagram arriba
            _buildHistoriasInstagram(),
            
            // HERO SANTA ROSA con selector de país
            _buildHeroSantaRosa(),
            
            // DESTACADOS HOY
            _buildDestacadosHoy(),
            
            // Tarjeta dorada "TU NEGOCIO AQUÍ"
            _buildLlamadoAccionComercial(),
            
            // Footer internacional
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // Historias estilo Instagram arriba
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
                        child: CachedNetworkImage(
                          imageUrl: historia['imagen']!,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(color: _dorado)),
                          ),
                          errorWidget: (context, url, error) => Container(
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

  // HERO SANTA ROSA con selector de país
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
            child: CachedNetworkImage(
              imageUrl: 'https://images.unsplash.com/photo-1518684079-3c830d4305b8?w=800&q=80',
              width: double.infinity,
              height: 280,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: _azulMarino,
                child: const Center(child: CircularProgressIndicator(color: _dorado)),
              ),
              errorWidget: (context, url, error) => Container(
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

  // DESTACADOS HOY
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
            child: CachedNetworkImage(
              imageUrl: destacado['imagen']!,
              width: double.infinity,
              height: 320,
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
              onTap: () => _compartirNegocio(destacado),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tarjeta dorada "TU NEGOCIO AQUÍ"
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

  // Footer internacional
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
