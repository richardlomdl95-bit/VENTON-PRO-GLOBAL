// =============================================================================
// VENTON PRO v3.0 - main.dart
// Marketplace digital de Santa Rosa de Cabal para el mundo
// Turismo + Publicidad global + Café de altura + Vendedores mundiales
// =============================================================================
// Compatible con Google Play Store policies (2026)
// Filosofía: "Un toque y listo. Lo más fácil del mundo."
// =============================================================================

import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// =============================================================================
// CONFIGURACIÓN GLOBAL
// =============================================================================

class VentonConfig {
  static const String appName = 'VENTON PRO';
  static const String version = '3.0.0';

  // Contacto principal del negocio (Ricardo)
  static const String adminWhatsApp = '573225609121';
  static const String adminEmail = 'ventonpro@gmail.com';

  // Colores de marca
  static const Color brandPrimary = Color(0xFF0D47A1);
  static const Color brandAccent = Color(0xFFFFC107);
  static const Color brandGold = Color(0xFFD4AF37);
  static const Color brandSuccess = Color(0xFF25D366);

  // Configuración de uploads (proteger Storage)
  static const int maxImageSizeKB = 500;
  static const int maxVideoSizeMB = 15;
  static const int maxVideoDurationSeconds = 60;
  static const int dailyUploadLimit = 5;

  // Sistema de comisiones de vendedores
  static const double comisionBronce = 0.25;
  static const double comisionPlata = 0.30;
  static const double comisionOro = 0.35;
  static const double comisionCafe = 0.20;

  // Planes de publicidad (COP)
  static const Map<String, int> planesPublicidad = {
    'basico': 30000,
    'premium': 80000,
    'top': 150000,
  };

  // Lugares precargados de Santa Rosa de Cabal
  static const List<Map<String, dynamic>> lugaresIniciales = [
    {
      'nombre': 'Termales Santa Rosa de Cabal',
      'categoria': 'turismo',
      'descripcion': 'Aguas termales naturales con cascada espectacular',
      'precio': '\$41.000–\$77.000',
      'lat': 4.8722,
      'lng': -75.5775,
      'imagen': 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=800',
    },
    {
      'nombre': 'Termales San Vicente',
      'categoria': 'turismo',
      'descripcion': 'Reserva termal en la montaña, aguas más limpias',
      'precio': '\$60.000–\$95.000',
      'lat': 4.8500,
      'lng': -75.5500,
      'imagen': 'https://images.unsplash.com/photo-1602002418816-5c0aeef426aa?w=800',
    },
    {
      'nombre': 'Chorros de Don Lolo',
      'categoria': 'turismo',
      'descripcion': 'Cascadas naturales y aguas termales en río',
      'precio': 'Desde \$15.000',
      'lat': 4.8400,
      'lng': -75.5400,
      'imagen': 'https://images.unsplash.com/photo-1432405972618-c60b0225b8f9?w=800',
    },
    {
      'nombre': 'Parque Las Araucarias',
      'categoria': 'turismo',
      'descripcion': 'Plaza principal de Santa Rosa, iglesia y vida local',
      'precio': 'Gratis',
      'lat': 4.8693,
      'lng': -75.6233,
      'imagen': 'https://images.unsplash.com/photo-1518998053901-5348d3961a04?w=800',
    },
    {
      'nombre': 'Tour del Café — Eje Cafetero',
      'categoria': 'turismo',
      'descripcion': 'Recorrido por finca cafetera con cata incluida',
      'precio': 'Desde \$80.000',
      'lat': 4.8600,
      'lng': -75.6100,
      'imagen': 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=800',
    },
  ];

  // Catálogo de Café VENTON (3 niveles, altura real)
  static const List<Map<String, dynamic>> catalogoCafe = [
    {
      'id': 'venton_altura',
      'nombre': 'CAFÉ VENTON ALTURA',
      'altura': '1.500–1.800 msnm',
      'descripcion': 'Café excelso del Eje Cafetero. Dulce y balanceado.',
      'precioLibraCOP': 28000,
      'precioKiloCOP': 52000,
      'precioLibraUSD': 9,
      'precioKiloUSD': 17,
      'imagen': 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=800',
    },
    {
      'id': 'venton_especial',
      'nombre': 'CAFÉ VENTON ESPECIAL',
      'altura': '1.800–2.000 msnm',
      'descripcion': 'Café especial. Notas cítricas y florales, cuerpo medio.',
      'precioLibraCOP': 45000,
      'precioKiloCOP': 85000,
      'precioLibraUSD': 14,
      'precioKiloUSD': 27,
      'imagen': 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800',
    },
    {
      'id': 'venton_microlote',
      'nombre': 'CAFÉ VENTON MICRO-LOTE',
      'altura': '1.900–2.000 msnm',
      'descripcion': 'Edición limitada de finca específica. Taza compleja.',
      'precioLibraCOP': 70000,
      'precioKiloCOP': 130000,
      'precioLibraUSD': 22,
      'precioKiloUSD': 42,
      'imagen': 'https://images.unsplash.com/photo-1442550528053-c431ecb55509?w=800',
    },
  ];
}

// =============================================================================
// PUNTO DE ENTRADA
// =============================================================================

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  try {
    await Firebase.initializeApp();
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }

  // Manejo global de errores
  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint('Flutter Error: ${details.toString()}');
  };

  runApp(const VentonProApp());
}

// =============================================================================
// APP PRINCIPAL
// =============================================================================

class VentonProApp extends StatelessWidget {
  const VentonProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: VentonConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: VentonConfig.brandPrimary,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: VentonConfig.brandPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      // Soporte multiidioma automático
      locale: ui.PlatformDispatcher.instance.locale,
      supportedLocales: const [
        Locale('es'),
        Locale('en'),
        Locale('pt'),
        Locale('fr'),
      ],
      home: const SplashScreen(),
    );
  }
}

// =============================================================================
// WRAPPER SEGURO PARA PÁGINAS
// =============================================================================

class SafePageWrapper extends StatefulWidget {
  final Widget child;
  const SafePageWrapper({super.key, required this.child});

  @override
  State<SafePageWrapper> createState() => _SafePageWrapperState();
}

class _SafePageWrapperState extends State<SafePageWrapper> {
  bool _hasError = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Error en la página', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text(_errorMessage, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => setState(() => _hasError = false),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    try {
      return widget.child;
    } catch (e) {
      return ErrorWidget.builder(
        FlutterErrorDetails(
          exception: e,
          stack: StackTrace.current,
          library: 'VENTON PRO',
        ),
      );
    }
  }
}

// =============================================================================
// PÁGINA DE ERROR
// =============================================================================

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VentonConfig.brandPrimary,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 80, color: Colors.white),
              const SizedBox(height: 24),
              const Text(
                'VENTON PRO',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Error al iniciar la aplicación',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const HomeShell()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: VentonConfig.brandAccent,
                  foregroundColor: VentonConfig.brandPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text(
                  'Reintentar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// PANTALLA DE BIENVENIDA
// =============================================================================

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  Future<void> _iniciar() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeShell()),
      );
    } catch (e) {
      debugPrint('Splash navigation error: $e');
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ErrorPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VentonConfig.brandPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: VentonConfig.brandAccent,
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(Icons.travel_explore,
                  size: 60, color: VentonConfig.brandPrimary),
            ),
            const SizedBox(height: 24),
            const Text('VENTON PRO',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2)),
            const SizedBox(height: 8),
            const Text('Santa Rosa de Cabal · Mundo',
                style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 32),
            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                  color: VentonConfig.brandAccent, strokeWidth: 3),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// SHELL PRINCIPAL CON NAVEGACIÓN
// =============================================================================

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  final List<Widget> _pages = [
    const SafePageWrapper(child: InicioPage()),
    const SafePageWrapper(child: TurismoPage()),
    const SafePageWrapper(child: PublicidadPage()),
    const SafePageWrapper(child: CafePage()),
    const SafePageWrapper(child: MasPage()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Inicio'),
          NavigationDestination(
              icon: Icon(Icons.terrain_outlined),
              selectedIcon: Icon(Icons.terrain),
              label: 'Turismo'),
          NavigationDestination(
              icon: Icon(Icons.campaign_outlined),
              selectedIcon: Icon(Icons.campaign),
              label: 'Publicidad'),
          NavigationDestination(
              icon: Icon(Icons.coffee_outlined),
              selectedIcon: Icon(Icons.coffee),
              label: 'Café'),
          NavigationDestination(
              icon: Icon(Icons.menu_outlined),
              selectedIcon: Icon(Icons.menu),
              label: 'Más'),
        ],
      ),
    );
  }
}

// =============================================================================
// HELPERS GLOBALES
// =============================================================================

class VentonHelpers {
  // Abrir WhatsApp con mensaje pre-llenado
  static Future<void> openWhatsApp(String mensaje,
      {String? numero}) async {
    final num = numero ?? VentonConfig.adminWhatsApp;
    final uri = Uri.parse(
        'https://wa.me/$num?text=${Uri.encodeComponent(mensaje)}');
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        debugPrint('No se pudo abrir WhatsApp');
      }
    } catch (e) {
      debugPrint('WhatsApp error: $e');
    }
  }

  // Abrir Google Maps externo (gratis, sin API)
  static Future<void> abrirMapaExterno(double lat, double lng,
      {String? nombre}) async {
    final query = nombre != null
        ? '$lat,$lng($nombre)'
        : '$lat,$lng';
    final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$query');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Maps error: $e');
    }
  }

  // Registrar evento en Firestore (tracking)
  static Future<void> logEvent(
      String collection, Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance.collection(collection).add({
        ...data,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Firestore error: $e');
    }
  }

  // Obtener ubicación del usuario (mundial)
  static Future<Position?> obtenerUbicacion() async {
    try {
      bool servicioActivo = await Geolocator.isLocationServiceEnabled();
      if (!servicioActivo) return null;

      LocationPermission permiso = await Geolocator.checkPermission();
      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
        if (permiso == LocationPermission.denied) return null;
      }
      if (permiso == LocationPermission.deniedForever) return null;

      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
    } catch (e) {
      debugPrint('Ubicación error: $e');
      return null;
    }
  }

  // Verificar límite diario de uploads (proteger Storage)
  static Future<bool> puedeSubir() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hoy = DateTime.now().toIso8601String().substring(0, 10);
      final ultimaFecha = prefs.getString('upload_fecha') ?? '';
      int conteoHoy = prefs.getInt('upload_conteo') ?? 0;

      if (ultimaFecha != hoy) {
        await prefs.setString('upload_fecha', hoy);
        await prefs.setInt('upload_conteo', 0);
        conteoHoy = 0;
      }

      return conteoHoy < VentonConfig.dailyUploadLimit;
    } catch (e) {
      return true;
    }
  }

  // Incrementar contador de uploads
  static Future<void> registrarUpload() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final actual = prefs.getInt('upload_conteo') ?? 0;
      await prefs.setInt('upload_conteo', actual + 1);
    } catch (e) {
      debugPrint('Contador upload error: $e');
    }
  }

  // Mostrar snackbar
  static void mostrarMensaje(BuildContext context, String mensaje,
      {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: error ? Colors.red[700] : VentonConfig.brandSuccess,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// =============================================================================
// PÁGINA: INICIO
// =============================================================================

class InicioPage extends StatelessWidget {
  const InicioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VENTON PRO',
            style: TextStyle(
                fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        actions: [
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context, delegate: BusquedaGlobalDelegate());
              }),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // HERO de Santa Rosa
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 10,
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=1200',
                    fit: BoxFit.cover,
                    placeholder: (c, u) => Container(color: Colors.grey[300]),
                    errorWidget: (c, u, e) => Container(
                        color: VentonConfig.brandPrimary,
                        child: const Center(
                            child: Icon(Icons.terrain,
                                size: 80, color: Colors.white))),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
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
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Santa Rosa de Cabal',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(blurRadius: 8, color: Colors.black)
                              ])),
                      const SizedBox(height: 4),
                      Text('Patrimonio Cafetero · Termales · Cordillera',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.95),
                              fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Accesos rápidos
          const Text('Explora',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              _AccesoRapido(
                  icon: Icons.terrain,
                  titulo: 'Turismo',
                  color: const Color(0xFF2E7D32),
                  onTap: () =>
                      _irPagina(context, 1)),
              _AccesoRapido(
                  icon: Icons.campaign,
                  titulo: 'Publicidad',
                  color: const Color(0xFFE65100),
                  onTap: () => _irPagina(context, 2)),
              _AccesoRapido(
                  icon: Icons.coffee,
                  titulo: 'Café',
                  color: const Color(0xFF5D4037),
                  onTap: () => _irPagina(context, 3)),
              _AccesoRapido(
                  icon: Icons.handshake,
                  titulo: 'Vendedores',
                  color: const Color(0xFF6A1B9A),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const VendedoresPage()))),
            ],
          ),
          const SizedBox(height: 24),

          // Banner de invitación a vendedores
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [VentonConfig.brandPrimary, Color(0xFF1976D2)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Gana plata con VENTON PRO',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                const Text(
                    'Vendedores en Colombia y el mundo. Comisiones hasta 35%. Pago directo a tu cuenta.',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 14),
                FilledButton.icon(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const VendedorRegistroPage())),
                  icon: const Icon(Icons.handshake),
                  label: const Text('Quiero ser vendedor'),
                  style: FilledButton.styleFrom(
                      backgroundColor: VentonConfig.brandAccent,
                      foregroundColor: VentonConfig.brandPrimary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ESPACIO RESERVADO PARA ADMOB (apagado por ahora)
          // Cuando actives AdMob, descomenta y agrega google_mobile_ads
          // Container(height: 60, color: Colors.grey[200]),

          // Feed reciente
          const Text('Lo más reciente',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const FeedReciente(),
          const SizedBox(height: 24),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SubirContenidoPage())),
        backgroundColor: VentonConfig.brandAccent,
        foregroundColor: VentonConfig.brandPrimary,
        icon: const Icon(Icons.add_a_photo),
        label: const Text('Subir',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _irPagina(BuildContext context, int index) {
    final shell = context.findAncestorStateOfType<_HomeShellState>();
    shell?.setState(() => shell._index = index);
  }
}

class _AccesoRapido extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final Color color;
  final VoidCallback onTap;
  const _AccesoRapido(
      {required this.icon,
      required this.titulo,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.white, size: 30),
              Text(titulo,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// FEED RECIENTE (publicaciones de usuarios y negocios)
// =============================================================================

class FeedReciente extends StatelessWidget {
  const FeedReciente({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('feed_publicaciones')
          .orderBy('timestamp', descending: true)
          .limit(10)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _publicacionesIniciales();
        }
        final docs = snapshot.data!.docs;
        return Column(
          children: docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return _PublicacionCard(
              titulo: data['titulo'] ?? 'Sin título',
              descripcion: data['descripcion'] ?? '',
              imagen: data['imagen'] ?? '',
              categoria: data['categoria'] ?? 'general',
              patrocinado: data['patrocinado'] ?? false,
            );
          }).toList(),
        );
      },
    );
  }

  Widget _publicacionesIniciales() {
    return Column(
      children: VentonConfig.lugaresIniciales.map((lugar) {
        return _PublicacionCard(
          titulo: lugar['nombre'],
          descripcion: lugar['descripcion'],
          imagen: lugar['imagen'],
          categoria: lugar['categoria'],
          patrocinado: false,
        );
      }).toList(),
    );
  }
}

class _PublicacionCard extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final String imagen;
  final String categoria;
  final bool patrocinado;

  const _PublicacionCard({
    required this.titulo,
    required this.descripcion,
    required this.imagen,
    required this.categoria,
    required this.patrocinado,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 10,
                child: imagen.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: imagen,
                        fit: BoxFit.cover,
                        placeholder: (c, u) =>
                            Container(color: Colors.grey[200]),
                        errorWidget: (c, u, e) =>
                            Container(color: Colors.grey[300]),
                      )
                    : Container(color: Colors.grey[300]),
              ),
              if (patrocinado)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: VentonConfig.brandGold,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, size: 12, color: Colors.white),
                        SizedBox(width: 4),
                        Text('PATROCINADO',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(descripcion,
                    style: TextStyle(color: Colors.grey[700], fontSize: 14)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          VentonHelpers.logEvent('clicks_whatsapp',
                              {'titulo': titulo, 'categoria': categoria});
                          VentonHelpers.openWhatsApp(
                              'Hola, quiero información sobre $titulo');
                        },
                        icon: const Icon(Icons.chat, size: 18),
                        label: const Text('WhatsApp'),
                        style: FilledButton.styleFrom(
                            backgroundColor: VentonConfig.brandSuccess),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      onPressed: () => _reportar(context),
                      icon: const Icon(Icons.flag_outlined, size: 20),
                      tooltip: 'Reportar',
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

  void _reportar(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reportar contenido'),
        content: const Text(
            '¿Quieres reportar este contenido por ser inapropiado o falso?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          FilledButton(
            onPressed: () {
              VentonHelpers.logEvent('reportes', {
                'titulo': titulo,
                'categoria': categoria,
                'motivo': 'usuario',
              });
              Navigator.pop(ctx);
              VentonHelpers.mostrarMensaje(
                  context, 'Reporte enviado. Gracias por ayudar.');
            },
            child: const Text('Reportar'),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// PÁGINA: TURISMO (PRIORIDAD #1)
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

// =============================================================================
// PÁGINA: PUBLICIDAD (PRIORIDAD #1)
// =============================================================================

class PublicidadPage extends StatelessWidget {
  const PublicidadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publicidad VENTON'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE65100), Color(0xFFFFA726)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Anúnciate con VENTON PRO',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text(
                    'Tu negocio visible en Santa Rosa, Colombia y el mundo. Activación en segundos.',
                    style: TextStyle(color: Colors.white, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Planes de publicidad',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _PlanPublicidad(
            nombre: 'BÁSICO',
            precio: 30000,
            color: const Color(0xFF1976D2),
            beneficios: const [
              'Perfil del negocio en VENTON PRO',
              'Hasta 3 fotos',
              'Botón WhatsApp directo',
              'Aparición en categoría',
              'Duración: 30 días',
            ],
          ),
          _PlanPublicidad(
            nombre: 'PREMIUM',
            precio: 80000,
            color: const Color(0xFFE65100),
            destacado: true,
            beneficios: const [
              'Todo lo del plan Básico',
              'Hasta 10 fotos + 1 video',
              'Badge "PATROCINADO" dorado',
              'Top en búsquedas y categoría',
              'Notificaciones push a turistas',
              'Duración: 30 días',
            ],
          ),
          _PlanPublicidad(
            nombre: 'TOP',
            precio: 150000,
            color: VentonConfig.brandGold,
            beneficios: const [
              'Todo lo del plan Premium',
              'Fotos y videos ilimitados',
              'Aparece en pantalla principal',
              'Banner en Inicio',
              'Reporte mensual de visitas',
              'Duración: 30 días',
            ],
          ),
          const SizedBox(height: 16),
          Card(
            color: Colors.amber[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.celebration, color: Colors.orange),
                      SizedBox(width: 8),
                      Text('Promoción especial',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                      'Los primeros 50 negocios de Santa Rosa de Cabal: '
                      'PUBLICIDAD GRATIS por 3 meses. Comprueba antes de pagar.'),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () {
                      VentonHelpers.logEvent(
                          'gratis_50', {'origen': 'publicidad'});
                      VentonHelpers.openWhatsApp(
                          'Hola, quiero entrar a los 50 negocios gratis de VENTON PRO');
                    },
                    icon: const Icon(Icons.card_giftcard),
                    label: const Text('Quiero ser uno de los 50 gratis'),
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

class _PlanPublicidad extends StatelessWidget {
  final String nombre;
  final int precio;
  final Color color;
  final List<String> beneficios;
  final bool destacado;

  const _PlanPublicidad({
    required this.nombre,
    required this.precio,
    required this.color,
    required this.beneficios,
    this.destacado = false,
  });

  @override
  Widget build(BuildContext context) {
    final precioStr = '\$${(precio / 1000).toStringAsFixed(0)}.000';
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: destacado
            ? BorderSide(color: color, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(nombre,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
                if (destacado) ...[
                  const SizedBox(width: 8),
                  const Text('Más popular',
                      style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(precioStr,
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold)),
                const Text(' COP / mes',
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 12),
            ...beneficios.map((b) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle, size: 18, color: color),
                      const SizedBox(width: 8),
                      Expanded(child: Text(b)),
                    ],
                  ),
                )),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  VentonHelpers.logEvent('publicidad_interes',
                      {'plan': nombre, 'precio': precio});
                  VentonHelpers.openWhatsApp(
                      'Hola, quiero el plan $nombre de publicidad VENTON PRO ($precioStr/mes)');
                },
                style: FilledButton.styleFrom(backgroundColor: color),
                child: const Text('Contratar este plan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// PÁGINA: CAFÉ VENTON
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

// =============================================================================
// PÁGINA: MÁS (vendedores, ruleta, ajustes, política)
// =============================================================================

class MasPage extends StatelessWidget {
  const MasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Más opciones'),
      ),
      body: ListView(
        children: [
          _ItemMenu(
              icon: Icons.handshake,
              titulo: 'Sé vendedor VENTON',
              subtitulo: 'Gana comisiones desde cualquier país',
              color: const Color(0xFF6A1B9A),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const VendedoresPage()))),
          _ItemMenu(
              icon: Icons.science,
              titulo: 'Productos químicos',
              subtitulo: 'Premium para flotas y plantas',
              color: const Color(0xFF00838F),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const QuimicosPage()))),
          _ItemMenu(
              icon: Icons.casino,
              titulo: 'Ruleta VENTON',
              subtitulo: 'Promoción gratis. Premios para clientes.',
              color: VentonConfig.brandAccent,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const RuletaPage()))),
          const Divider(),
          _ItemMenu(
              icon: Icons.add_a_photo,
              titulo: 'Subir contenido',
              subtitulo: 'Comparte fotos y videos de Santa Rosa',
              color: VentonConfig.brandPrimary,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SubirContenidoPage()))),
          _ItemMenu(
              icon: Icons.flag,
              titulo: 'Reportar contenido',
              subtitulo: 'Ayúdanos a mantener la app limpia',
              color: Colors.red[700]!,
              onTap: () => _reportarGeneral(context)),
          const Divider(),
          _ItemMenu(
              icon: Icons.privacy_tip,
              titulo: 'Política de privacidad',
              subtitulo: 'Cómo cuidamos tus datos',
              color: Colors.blueGrey,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const PoliticaPage()))),
          _ItemMenu(
              icon: Icons.gavel,
              titulo: 'Términos de uso',
              subtitulo: 'Reglas de la comunidad',
              color: Colors.blueGrey,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const TerminosPage()))),
          _ItemMenu(
              icon: Icons.info_outline,
              titulo: 'Acerca de VENTON PRO',
              subtitulo: 'Versión ${VentonConfig.version}',
              color: Colors.blueGrey,
              onTap: () => _acercaDe(context)),
        ],
      ),
    );
  }

  void _reportarGeneral(BuildContext context) {
    VentonHelpers.openWhatsApp(
        'Hola, quiero reportar contenido inapropiado en VENTON PRO');
  }

  void _acercaDe(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: VentonConfig.appName,
      applicationVersion: VentonConfig.version,
      applicationLegalese:
          '© 2026 VENTON PRO\nMarketplace digital de Santa Rosa de Cabal',
    );
  }
}

class _ItemMenu extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String subtitulo;
  final Color color;
  final VoidCallback onTap;

  const _ItemMenu({
    required this.icon,
    required this.titulo,
    required this.subtitulo,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color)),
      title: Text(titulo,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitulo),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

// =============================================================================
// PÁGINA: VENDEDORES (mundial)
// =============================================================================

class VendedoresPage extends StatelessWidget {
  const VendedoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vendedores VENTON')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6A1B9A), Color(0xFFAB47BC)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Gana plata en cualquier país',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text(
                    'Vende publicidad y café VENTON PRO. Recibe tu plata directo a tu cuenta.',
                    style: TextStyle(color: Colors.white, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Niveles de comisión',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _NivelVendedor(
              nombre: 'BRONCE',
              comision: 25,
              requisito: 'Al registrarte',
              color: const Color(0xFFCD7F32)),
          _NivelVendedor(
              nombre: 'PLATA',
              comision: 30,
              requisito: 'Al traer 5 clientes',
              color: const Color(0xFFC0C0C0)),
          _NivelVendedor(
              nombre: 'ORO',
              comision: 35,
              requisito: 'Al traer 20 clientes',
              color: const Color(0xFFFFD700)),
          const SizedBox(height: 20),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Lo que necesitas para registrarte',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  _Requisito(texto: 'Nombre completo'),
                  _Requisito(texto: 'Dirección'),
                  _Requisito(texto: 'Teléfono / WhatsApp'),
                  _Requisito(
                      texto:
                          'Cuenta bancaria o digital (Nequi, Daviplata, PayPal, Wise)'),
                  _Requisito(texto: 'País'),
                  SizedBox(height: 8),
                  Text('Eso es todo. Sin papeleos complicados.',
                      style: TextStyle(
                          fontStyle: FontStyle.italic, color: Colors.grey)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const VendedorRegistroPage())),
              icon: const Icon(Icons.app_registration),
              label: const Text('Registrarme como vendedor',
                  style: TextStyle(fontSize: 16)),
              style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF6A1B9A),
                  padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
          ),
        ],
      ),
    );
  }
}

class _NivelVendedor extends StatelessWidget {
  final String nombre;
  final int comision;
  final String requisito;
  final Color color;

  const _NivelVendedor({
    required this.nombre,
    required this.comision,
    required this.requisito,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text('$comision%',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
          ),
        ),
        title: Text(nombre,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(requisito),
      ),
    );
  }
}

class _Requisito extends StatelessWidget {
  final String texto;
  const _Requisito({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle,
              size: 18, color: VentonConfig.brandSuccess),
          const SizedBox(width: 8),
          Expanded(child: Text(texto)),
        ],
      ),
    );
  }
}

// =============================================================================
// PÁGINA: REGISTRO DE VENDEDOR
// =============================================================================

class VendedorRegistroPage extends StatefulWidget {
  const VendedorRegistroPage({super.key});

  @override
  State<VendedorRegistroPage> createState() => _VendedorRegistroPageState();
}

class _VendedorRegistroPageState extends State<VendedorRegistroPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _direccionCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _cuentaCtrl = TextEditingController();
  String _pais = 'Colombia';
  bool _aceptoTerminos = false;
  bool _enviando = false;

  final List<String> _paises = const [
    'Colombia',
    'Estados Unidos',
    'España',
    'México',
    'Argentina',
    'Venezuela',
    'Ecuador',
    'Perú',
    'Chile',
    'Brasil',
    'Otro'
  ];

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _direccionCtrl.dispose();
    _telefonoCtrl.dispose();
    _cuentaCtrl.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_aceptoTerminos) {
      VentonHelpers.mostrarMensaje(
          context, 'Debes aceptar los términos', error: true);
      return;
    }

    setState(() => _enviando = true);

    try {
      final codigoUnico = _generarCodigoUnico();
      await VentonHelpers.logEvent('vendedores_registro', {
        'nombre': _nombreCtrl.text.trim(),
        'direccion': _direccionCtrl.text.trim(),
        'telefono': _telefonoCtrl.text.trim(),
        'cuenta': _cuentaCtrl.text.trim(),
        'pais': _pais,
        'codigo_unico': codigoUnico,
        'nivel': 'BRONCE',
        'comision': 0.25,
        'estado': 'pendiente_revision',
      });

      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: const Text('🎉 Registro recibido'),
          content: Text(
              'Tu código único de vendedor es:\n\n$codigoUnico\n\n'
              'Te contactaremos por WhatsApp para activarte. ¡Bienvenido al equipo VENTON!'),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
                VentonHelpers.openWhatsApp(
                    'Hola, soy ${_nombreCtrl.text}, código $codigoUnico. Acabo de registrarme como vendedor VENTON PRO.');
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) {
        VentonHelpers.mostrarMensaje(context,
            'Error al registrar. Intenta de nuevo.', error: true);
      }
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  String _generarCodigoUnico() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final r = math.Random();
    return 'V-${List.generate(6, (_) => chars[r.nextInt(chars.length)]).join()}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de vendedor')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Solo 5 datos. Sin papeleos.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nombreCtrl,
              decoration: const InputDecoration(
                  labelText: 'Nombre completo',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder()),
              validator: (v) =>
                  (v == null || v.trim().length < 3) ? 'Nombre requerido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _direccionCtrl,
              decoration: const InputDecoration(
                  labelText: 'Dirección',
                  prefixIcon: Icon(Icons.home),
                  border: OutlineInputBorder()),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Dirección requerida' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _telefonoCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                  labelText: 'Teléfono / WhatsApp',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder()),
              validator: (v) =>
                  (v == null || v.trim().length < 7) ? 'Teléfono inválido' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _pais,
              decoration: const InputDecoration(
                  labelText: 'País',
                  prefixIcon: Icon(Icons.public),
                  border: OutlineInputBorder()),
              items: _paises
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (v) => setState(() => _pais = v ?? 'Colombia'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _cuentaCtrl,
              decoration: const InputDecoration(
                  labelText: 'Cuenta para recibir pagos',
                  hintText: 'Ej: Nequi 3001234567 / PayPal correo@ejemplo.com',
                  prefixIcon: Icon(Icons.account_balance),
                  border: OutlineInputBorder()),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Cuenta requerida' : null,
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              value: _aceptoTerminos,
              onChanged: (v) => setState(() => _aceptoTerminos = v ?? false),
              title: const Text('Acepto los términos de uso y la política de privacidad',
                  style: TextStyle(fontSize: 13)),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _enviando ? null : _enviar,
              icon: _enviando
                  ? const SizedBox(
                      width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.check),
              label: Text(_enviando ? 'Enviando...' : 'Enviar registro'),
              style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// PÁGINA: SUBIR CONTENIDO (fotos y videos instantáneos)
// =============================================================================

class SubirContenidoPage extends StatefulWidget {
  const SubirContenidoPage({super.key});

  @override
  State<SubirContenidoPage> createState() => _SubirContenidoPageState();
}

class _SubirContenidoPageState extends State<SubirContenidoPage> {
  final _tituloCtrl = TextEditingController();
  final _descripcionCtrl = TextEditingController();
  String _categoria = 'turismo';
  XFile? _archivo;
  bool _esVideo = false;
  bool _subiendo = false;

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descripcionCtrl.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFoto() async {
    if (!await VentonHelpers.puedeSubir()) {
      if (!mounted) return;
      VentonHelpers.mostrarMensaje(
          context, 'Llegaste al límite diario de uploads. Vuelve mañana.',
          error: true);
      return;
    }
    try {
      final picker = ImagePicker();
      final foto = await picker.pickImage(
          source: ImageSource.camera,
          maxWidth: 1280,
          maxHeight: 1280,
          imageQuality: 70);
      if (foto != null) {
        setState(() {
          _archivo = foto;
          _esVideo = false;
        });
      }
    } catch (e) {
      if (mounted) {
        VentonHelpers.mostrarMensaje(context, 'Error al tomar foto', error: true);
      }
    }
  }

  Future<void> _seleccionarVideo() async {
    if (!await VentonHelpers.puedeSubir()) {
      if (!mounted) return;
      VentonHelpers.mostrarMensaje(
          context, 'Llegaste al límite diario de uploads. Vuelve mañana.',
          error: true);
      return;
    }
    try {
      final picker = ImagePicker();
      final video = await picker.pickVideo(
          source: ImageSource.camera,
          maxDuration:
              Duration(seconds: VentonConfig.maxVideoDurationSeconds));
      if (video != null) {
        setState(() {
          _archivo = video;
          _esVideo = true;
        });
      }
    } catch (e) {
      if (mounted) {
        VentonHelpers.mostrarMensaje(context, 'Error al grabar video', error: true);
      }
    }
  }

  Future<void> _subir() async {
    if (_tituloCtrl.text.trim().isEmpty) {
      VentonHelpers.mostrarMensaje(context, 'Falta el título', error: true);
      return;
    }
    if (_archivo == null) {
      VentonHelpers.mostrarMensaje(context, 'Selecciona foto o video', error: true);
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _pedirLogin();
      return;
    }

    setState(() => _subiendo = true);

    try {
      final archivo = File(_archivo!.path);
      final ext = _esVideo ? 'mp4' : 'jpg';
      final nombre =
          '${user.uid}_${DateTime.now().millisecondsSinceEpoch}.$ext';
      final ref = FirebaseStorage.instance
          .ref()
          .child(_esVideo ? 'videos' : 'imagenes')
          .child(nombre);

      final tarea = await ref.putFile(archivo);
      final url = await tarea.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('feed_publicaciones').add({
        'titulo': _tituloCtrl.text.trim(),
        'descripcion': _descripcionCtrl.text.trim(),
        'categoria': _categoria,
        'imagen': url,
        'es_video': _esVideo,
        'usuario_id': user.uid,
        'usuario_email': user.email,
        'patrocinado': false,
        'aprobado': true, // moderación posterior por reportes
        'timestamp': FieldValue.serverTimestamp(),
      });

      await VentonHelpers.registrarUpload();

      if (!mounted) return;
      VentonHelpers.mostrarMensaje(
          context, '¡Publicado! Ya se ve en VENTON PRO mundialmente.');
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        VentonHelpers.mostrarMensaje(
            context, 'Error al publicar. Intenta de nuevo.', error: true);
      }
    } finally {
      if (mounted) setState(() => _subiendo = false);
    }
  }

  void _pedirLogin() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Necesitas una cuenta'),
        content: const Text(
            'Para subir contenido necesitas registrarte. Ver es libre, subir requiere cuenta.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const LoginSimplePage()));
              },
              child: const Text('Registrarme')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subir contenido')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Comparte Santa Rosa con el mundo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (_archivo != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 200,
                color: Colors.grey[300],
                child: Center(
                  child: Icon(
                      _esVideo ? Icons.videocam : Icons.image,
                      size: 80,
                      color: VentonConfig.brandPrimary),
                ),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _seleccionarFoto,
                    icon: const Icon(Icons.photo_camera),
                    label: const Text('Foto'),
                    style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 24)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _seleccionarVideo,
                    icon: const Icon(Icons.videocam),
                    label: const Text('Video'),
                    style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 24)),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),
          TextField(
            controller: _tituloCtrl,
            decoration: const InputDecoration(
                labelText: 'Título', border: OutlineInputBorder()),
            maxLength: 60,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descripcionCtrl,
            decoration: const InputDecoration(
                labelText: 'Descripción', border: OutlineInputBorder()),
            maxLength: 200,
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _categoria,
            decoration: const InputDecoration(
                labelText: 'Categoría', border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: 'turismo', child: Text('Turismo')),
              DropdownMenuItem(
                  value: 'restaurante', child: Text('Restaurante')),
              DropdownMenuItem(value: 'hotel', child: Text('Hotel')),
              DropdownMenuItem(value: 'negocio', child: Text('Negocio')),
              DropdownMenuItem(value: 'cafe', child: Text('Café')),
            ],
            onChanged: (v) => setState(() => _categoria = v ?? 'turismo'),
          ),
          const SizedBox(height: 16),
          Card(
            color: Colors.amber[50],
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: Colors.orange),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                        'Sube solo contenido tuyo o con permiso. No subas contenido ofensivo, ilegal o que viole derechos de terceros.',
                        style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _subiendo ? null : _subir,
            icon: _subiendo
                ? const SizedBox(
                    width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.cloud_upload),
            label: Text(_subiendo ? 'Publicando...' : 'PUBLICAR YA',
                style: const TextStyle(fontSize: 16)),
            style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: VentonConfig.brandAccent,
                foregroundColor: VentonConfig.brandPrimary),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// PÁGINA: LOGIN SIMPLE (correo + contraseña)
// =============================================================================

class LoginSimplePage extends StatefulWidget {
  const LoginSimplePage({super.key});

  @override
  State<LoginSimplePage> createState() => _LoginSimplePageState();
}

class _LoginSimplePageState extends State<LoginSimplePage> {
  final _correoCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _esRegistro = true;
  bool _procesando = false;

  @override
  void dispose() {
    _correoCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _procesar() async {
    if (_correoCtrl.text.trim().isEmpty || _passCtrl.text.length < 6) {
      VentonHelpers.mostrarMensaje(context,
          'Correo válido y contraseña de 6+ caracteres', error: true);
      return;
    }
    setState(() => _procesando = true);
    try {
      if (_esRegistro) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _correoCtrl.text.trim(), password: _passCtrl.text);
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _correoCtrl.text.trim(), password: _passCtrl.text);
      }
      if (!mounted) return;
      Navigator.pop(context);
      VentonHelpers.mostrarMensaje(context, '¡Bienvenido a VENTON PRO!');
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        VentonHelpers.mostrarMensaje(
            context, 'Error: ${e.message ?? 'desconocido'}',
            error: true);
      }
    } catch (e) {
      if (mounted) {
        VentonHelpers.mostrarMensaje(context, 'Error inesperado', error: true);
      }
    } finally {
      if (mounted) setState(() => _procesando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_esRegistro ? 'Crear cuenta' : 'Entrar')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 20),
          const Icon(Icons.account_circle,
              size: 80, color: VentonConfig.brandPrimary),
          const SizedBox(height: 20),
          TextField(
            controller: _correoCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passCtrl,
            obscureText: true,
            decoration: const InputDecoration(
                labelText: 'Contraseña (6+ caracteres)',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _procesando ? null : _procesar,
            style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14)),
            child: Text(_esRegistro ? 'Crear cuenta' : 'Entrar'),
          ),
          TextButton(
            onPressed: () => setState(() => _esRegistro = !_esRegistro),
            child: Text(_esRegistro
                ? '¿Ya tienes cuenta? Entra'
                : '¿No tienes cuenta? Regístrate'),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// PÁGINA: PRODUCTOS QUÍMICOS (secundario)
// =============================================================================

class QuimicosPage extends StatelessWidget {
  const QuimicosPage({super.key});

  static const productos = [
    {
      'titulo': 'Limpiador industrial',
      'desc': 'Para flotas y plantas',
      'precio': '\$85.000'
    },
    {
      'titulo': 'Desinfectante hospitalario',
      'desc': 'Grado profesional',
      'precio': '\$120.000'
    },
    {
      'titulo': 'Kit de mantenimiento',
      'desc': 'Solución completa',
      'precio': '\$240.000'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Productos químicos premium')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: productos.length,
        itemBuilder: (ctx, i) {
          final p = productos[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p['titulo']!,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(p['desc']!, style: TextStyle(color: Colors.grey[700])),
                  const SizedBox(height: 8),
                  Text(p['precio']!,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: VentonConfig.brandPrimary)),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () {
                      VentonHelpers.logEvent(
                          'quimicos_cotiza', {'producto': p['titulo']});
                      VentonHelpers.openWhatsApp(
                          'Hola, quiero cotizar ${p['titulo']}');
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Cotizar'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// =============================================================================
// PÁGINA: RULETA (fidelización gratis)
// =============================================================================

class RuletaPage extends StatefulWidget {
  const RuletaPage({super.key});

  @override
  State<RuletaPage> createState() => _RuletaPageState();
}

class _RuletaPageState extends State<RuletaPage>
    with SingleTickerProviderStateMixin {
  static const int kRuletaWinnerAt = 500;

  int _jugadas = 0;
  bool _girando = false;
  String _ultimoPremio = '';
  late AnimationController _ctrl;
  late Animation<double> _anim;

  final _premios = const [
    '10% OFF',
    'Envío gratis',
    '5% OFF',
    'Sigue intentando',
    'Café gratis',
    '15% OFF',
    'Sigue intentando',
    '20% OFF',
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 3));
    _anim = Tween<double>(begin: 0, end: 0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.decelerate));
    _cargar();
  }

  Future<void> _cargar() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      setState(() => _jugadas = prefs.getInt('ruleta_jugadas') ?? 0);
    } catch (_) {}
  }

  Future<void> _girar() async {
    if (_girando) return;
    setState(() => _girando = true);

    final r = math.Random();
    final idx = r.nextInt(_premios.length);
    final vueltas = 5 + r.nextDouble();
    final end = vueltas * 2 * math.pi + (idx * 2 * math.pi / _premios.length);

    _anim = Tween<double>(begin: 0, end: end)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.decelerate));
    _ctrl.reset();
    await _ctrl.forward();

    final nuevas = _jugadas + 1;
    final premio = _premios[idx];

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('ruleta_jugadas', nuevas);
    } catch (_) {}

    await VentonHelpers.logEvent('ruleta_jugadas',
        {'jugada_numero': nuevas, 'premio': premio});

    if (!mounted) return;
    setState(() {
      _jugadas = nuevas;
      _ultimoPremio = premio;
      _girando = false;
    });

    if (nuevas >= kRuletaWinnerAt) {
      _ganadorFinal();
    } else {
      _premioDialog(premio);
    }
  }

  void _premioDialog(String premio) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('🎉 Resultado'),
        content: Text(premio,
            style:
                const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cerrar')),
          if (premio != 'Sigue intentando')
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                VentonHelpers.openWhatsApp(
                    'Gané "$premio" en la ruleta VENTON PRO. Quiero reclamarlo.');
              },
              child: const Text('Reclamar'),
            ),
        ],
      ),
    );
  }

  void _ganadorFinal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('🏆 ¡GANADOR FINAL!'),
        content: const Text(
            'Alcanzaste las 500 jugadas. Eres el ganador del gran premio VENTON PRO.'),
        actions: [
          FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                VentonHelpers.openWhatsApp(
                    'Soy el GANADOR del gran premio VENTON PRO (500 jugadas). Quiero reclamar.');
              },
              child: const Text('Reclamar premio')),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progreso = (_jugadas / kRuletaWinnerAt).clamp(0.0, 1.0);
    return Scaffold(
      appBar: AppBar(title: const Text('Ruleta VENTON')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text('Jugadas: $_jugadas / $kRuletaWinnerAt',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: progreso,
                      minHeight: 8,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation(
                          VentonConfig.brandAccent),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: AnimatedBuilder(
                  animation: _anim,
                  builder: (c, child) =>
                      Transform.rotate(angle: _anim.value, child: child),
                  child: Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const SweepGradient(colors: [
                        Color(0xFFE53935),
                        Color(0xFFFB8C00),
                        Color(0xFFFDD835),
                        Color(0xFF43A047),
                        Color(0xFF1E88E5),
                        Color(0xFF8E24AA),
                        Color(0xFFE53935),
                      ]),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8))
                      ],
                    ),
                    child: const Center(
                        child:
                            Icon(Icons.casino, size: 70, color: Colors.white)),
                  ),
                ),
              ),
            ),
            if (_ultimoPremio.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text('Último: $_ultimoPremio',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
              ),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _girando ? null : _girar,
                icon: const Icon(Icons.casino),
                label: Text(_girando ? 'Girando...' : 'GIRAR'),
                style: FilledButton.styleFrom(
                    backgroundColor: VentonConfig.brandAccent,
                    foregroundColor: VentonConfig.brandPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
                'Promoción interna sin costo. No es juego de azar con dinero real.',
                style: TextStyle(fontSize: 11, color: Colors.grey),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// BÚSQUEDA GLOBAL
// =============================================================================

class BusquedaGlobalDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
            icon: const Icon(Icons.clear), onPressed: () => query = '')
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''));

  @override
  Widget buildResults(BuildContext context) => _construir();

  @override
  Widget buildSuggestions(BuildContext context) => _construir();

  Widget _construir() {
    if (query.isEmpty) return const Center(child: Text('Escribe para buscar'));
    final results = VentonConfig.lugaresIniciales
        .where((l) =>
            l['nombre'].toString().toLowerCase().contains(query.toLowerCase()) ||
            l['descripcion']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
        .toList();
    if (results.isEmpty) {
      return const Center(child: Text('Sin resultados'));
    }
    return ListView(
      children: results.map((l) {
        return ListTile(
          leading: const Icon(Icons.terrain),
          title: Text(l['nombre']),
          subtitle: Text(l['descripcion']),
        );
      }).toList(),
    );
  }
}

// =============================================================================
// POLÍTICAS Y TÉRMINOS (REQUERIDOS POR GOOGLE PLAY)
// =============================================================================

class PoliticaPage extends StatelessWidget {
  const PoliticaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Política de privacidad')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Text('''
POLÍTICA DE PRIVACIDAD — VENTON PRO

Última actualización: Abril 2026

1. INFORMACIÓN QUE RECOPILAMOS
- Datos de cuenta: correo electrónico y contraseña.
- Datos de vendedor (si aplicas): nombre, dirección, teléfono, cuenta bancaria, país.
- Contenido subido: fotos, videos, descripciones.
- Datos técnicos: ubicación aproximada (con tu permiso), tipo de dispositivo.
- Eventos de uso: clicks, vistas, interacciones (para mejorar la app).

2. CÓMO USAMOS TUS DATOS
- Para mostrarte contenido relevante de Santa Rosa.
- Para procesar pagos a vendedores.
- Para conectarte con negocios vía WhatsApp.
- Para mejorar la app con análisis agregados.

3. CON QUIÉN COMPARTIMOS
- Firebase (Google) para almacenar datos.
- Pasarelas de pago (Wompi, Stripe) cuando uses tarjeta.
- NO vendemos tus datos personales a terceros.

4. TUS DERECHOS
- Puedes solicitar borrar tu cuenta y datos en cualquier momento.
- Puedes contactarnos por WhatsApp para revisar tu información.

5. SEGURIDAD
- Usamos cifrado en tránsito (HTTPS).
- Las contraseñas se almacenan con hash de Firebase.
- Reglas estrictas de Firestore y Storage.

6. MENORES DE EDAD
- VENTON PRO está dirigido a mayores de 13 años.
- Si descubrimos que un menor de 13 ha creado cuenta, la eliminaremos.

7. CONTENIDO SUBIDO POR USUARIOS
- Es responsabilidad del usuario subir solo contenido propio o con permiso.
- Reservamos el derecho de eliminar contenido reportado o inapropiado.
- Hay un botón de reporte en cada publicación.

8. CONTACTO
WhatsApp: +57 322 560 9121
Correo: ventonpro@gmail.com

9. CAMBIOS
Te notificaremos en la app si actualizamos esta política.
        '''),
      ),
    );
  }
}

class TerminosPage extends StatelessWidget {
  const TerminosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Términos de uso')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Text('''
TÉRMINOS DE USO — VENTON PRO

Última actualización: Abril 2026

1. ACEPTACIÓN
Al usar VENTON PRO aceptas estos términos.

2. USO PERMITIDO
- Ver contenido turístico, comercial y de café.
- Subir contenido propio o con permiso.
- Reservar experiencias y comprar productos.
- Registrarte como vendedor.

3. CONTENIDO PROHIBIDO
NO se permite subir o promover:
- Contenido sexual o pornográfico.
- Contenido violento, de odio o discriminación.
- Contenido ilegal o que promueva actividades ilegales.
- Contenido falso, engañoso o fraudulento.
- Contenido protegido por derechos de autor sin permiso.
- Spam o publicidad no solicitada externa.
- Información personal de terceros sin consentimiento.
- Contenido que dañe a menores de edad.

4. MODERACIÓN
- Usamos sistema de reporte por usuarios.
- Eliminamos contenido reportado tras revisión.
- Cuentas que violen reglas serán suspendidas.

5. RULETA
- La ruleta es promocional sin costo.
- NO es juego de azar con dinero real.
- Premios sujetos a disponibilidad.

6. PUBLICIDAD
- Anunciantes son responsables del contenido de sus anuncios.
- VENTON PRO no garantiza resultados específicos de publicidad.
- Pagos no reembolsables después de activación del plan.

7. VENDEDORES
- Comisiones se pagan según ventas confirmadas.
- Pagos se procesan según ciclo del país del vendedor.
- VENTON PRO puede ajustar comisiones con previo aviso.

8. LIMITACIÓN DE RESPONSABILIDAD
- VENTON PRO es plataforma de conexión.
- No somos responsables de transacciones entre usuarios y negocios.
- No garantizamos disponibilidad ininterrumpida.

9. PROPIEDAD INTELECTUAL
- VENTON PRO y su marca son propiedad de la empresa.
- Contenido subido por usuarios sigue siendo de los usuarios, pero nos otorgan licencia para mostrarlo en la app.

10. CAMBIOS
Estos términos pueden actualizarse. Te avisaremos en la app.

11. CONTACTO
WhatsApp: +57 322 560 9121
        '''),
      ),
    );
  }
}

// =============================================================================
// FIN DE main.dart - VENTON PRO v3.0
// =============================================================================
