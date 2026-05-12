import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
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
      'imagen': 'https://images.unsplash.com/photo-1571902943202-507ec2618e8f',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20me%20interesa%20Termales%20Santa%20Rosa',
    },
    {
      'nombre': 'Hotel Tacurrumbi',
      'descripcion': 'Hospedaje tradicional en el centro de Santa Rosa',
      'imagen': 'https://images.unsplash.com/photo-1566073771259-6a8506099945',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20quiero%20reservar%20en%20Hotel%20Tacurrumbi',
    },
    {
      'nombre': 'Restaurante La Leyenda del Chorizo',
      'descripcion': 'Chorizo santarrosano auténtico',
      'imagen': 'https://images.unsplash.com/photo-1544025162-d76694265947',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20quiero%20reservar%20en%20La%20Leyenda',
    },
    {
      'nombre': 'Tour del Café Premium',
      'descripcion': 'Recorrido por fincas cafeteras con cata',
      'imagen': 'https://images.unsplash.com/photo-1442550528053-c431ecb55509',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20me%20interesa%20Tour%20del%20Cafe',
    },
  ];

  // Datos de restaurantes
  final List<Map<String, String>> _restaurantes = [
    {
      'nombre': 'La Leyenda del Chorizo',
      'precio': '\$25.000',
      'imagen': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20quiero%20reservar%20en%20La%20Leyenda%20del%20Chorizo',
    },
    {
      'nombre': 'Restaurante El Recreo',
      'precio': '\$30.000',
      'imagen': 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20quiero%20reservar%20en%20El%20Recreo',
    },
    {
      'nombre': 'Asadero La Brasa',
      'precio': '\$22.000',
      'imagen': 'https://images.unsplash.com/photo-1546833999-b9f581a1996d',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20quiero%20reservar%20en%20Asadero%20La%20Brasa',
    },
    {
      'nombre': 'Café del Parque',
      'precio': '\$18.000',
      'imagen': 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20quiero%20reservar%20en%20Café%20del%20Parque',
    },
    {
      'nombre': 'Heladería Tradicional',
      'precio': '\$12.000',
      'imagen': 'https://images.unsplash.com/photo-1488900128323-21503983a07a',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20quiero%20reservar%20en%20Heladería%20Tradicional',
    },
  ];

  // Datos de hoteles
  final List<Map<String, String>> _hoteles = [
    {
      'nombre': 'Hotel Tacurrumbi',
      'precio': '\$120.000',
      'imagen': 'https://images.unsplash.com/photo-1566073771259-6a8506099945',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20quiero%20reservar%20en%20Hotel%20Tacurrumbi',
    },
    {
      'nombre': 'Hotel Las Heliconias',
      'precio': '\$150.000',
      'imagen': 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20quiero%20reservar%20en%20Hotel%20Las%20Heliconias',
    },
    {
      'nombre': 'Eco-Hotel Termales del Otoño',
      'precio': '\$180.000',
      'imagen': 'https://images.unsplash.com/photo-1571896349842-33c89424de2d',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20quiero%20reservar%20en%20Eco-Hotel%20Termales%20del%20Otoño',
    },
    {
      'nombre': 'Hostal Casa Verde',
      'precio': '\$80.000',
      'imagen': 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20quiero%20reservar%20en%20Hostal%20Casa%20Verde',
    },
    {
      'nombre': 'Hotel Termales Santa Rosa',
      'precio': '\$200.000',
      'imagen': 'https://images.unsplash.com/photo-1571902943202-507ec2618e8f',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20quiero%20reservar%20en%20Hotel%20Termales%20Santa%20Rosa',
    },
  ];

  // Datos de experiencias
  final List<Map<String, String>> _experiencias = [
    {
      'nombre': 'Termales Santa Rosa',
      'duracion': '1 día completo',
      'imagen': 'https://images.unsplash.com/photo-1571902943202-507ec2618e8f',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20me%20interesa%20Termales%20Santa%20Rosa',
    },
    {
      'nombre': 'Cascadas de San Ramón',
      'duracion': '4 horas',
      'imagen': 'https://images.unsplash.com/photo-1434394354979-a235cd36269d',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20me%20interesa%20Cascadas%20de%20San%20Ramón',
    },
    {
      'nombre': 'Tour del Café Premium',
      'duracion': '6 horas',
      'imagen': 'https://images.unsplash.com/photo-1442550528053-c431ecb55509',
      'whatsapp': 'https://wa.me/573225609121?text=Hola%20me%20interesa%20Tour%20del%20Cafe',
    },
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
            
            // BLOQUE 1 - HERO SANTA ROSA
            _buildHeroSantaRosa(),
            
            // BLOQUE 2 - DESTACADOS HOY
            _buildDestacadosHoy(),
            
            // BLOQUE 3 - DONDE COMER
            _buildDondeComer(),
            
            // BLOQUE 4 - DONDE DORMIR
            _buildDondeDormir(),
            
            // BLOQUE 5 - QUE HACER EN SANTA ROSA
            _buildQueHacer(),
            
            // BLOQUE 6 - VIDEOS DE LA COMUNIDAD
            _buildVideosComunidad(),
            
            // BLOQUE 7 - MAPA INTERACTIVO
            _buildMapaInteractivo(),
            
            // BLOQUE 8 - RULETA VENTON
            _buildRuletaVenton(),
            
            // BLOQUE 9 - LLAMADO A LA ACCION COMERCIAL
            _buildLlamadoAccionComercial(),
            
            // BLOQUE 10 - FOOTER
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // BLOQUE 1 - HERO SANTA ROSA
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
          // Texto
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SANTA ROSA DE CABAL',
                  style: TextStyle(
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
              pageSnapping: true,
              controller: _pageController,
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

  // BLOQUE 6 - VIDEOS DE LA COMUNIDAD
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
            children: List.generate(6, (index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: _grafito,
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
                      Icons.play_circle_outline,
                      color: Colors.white,
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Próximamente',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            }),
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

  // BLOQUE 10 - FOOTER
  Widget _buildFooter() {
    return Column(
      children: [
        const SizedBox(height: 40),
        Text(
          'VENTON PRO GLOBAL · Santa Rosa de Cabal · Hecho con cariño en Risaralda',
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
