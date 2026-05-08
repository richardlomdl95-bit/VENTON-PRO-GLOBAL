import 'dart:async';
import 'package:flutter/material.dart';
import '../core/ruleta_service.dart';
import '../core/theme.dart';
import '../core/venton_config.dart';
import '../core/venton_helpers.dart';
import '../core/widgets/acceso_rapido.dart';
import '../core/widgets/banner_ad_slot.dart';
import '../core/widgets/banner_rotativo.dart';
import '../core/widgets/feed_reciente.dart';
import '../core/widgets/pais_selector.dart';
import '../core/widgets/seccion_ofertas.dart';
import '../core/widgets/stories_widget.dart';
import '../core/widgets/venton_logo.dart';
import 'buscar_page.dart';
import 'cafe_page.dart';
import 'experiencia_detalle_page.dart';
import 'favoritos_page.dart';
import 'producto_detalle_page.dart';
import 'quimicos_page.dart';
import 'ruleta_page.dart';
import 'subir_contenido_page.dart';
import 'turismo_page.dart';
import 'vendedor_registro_page.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  int _segundosRestantesRuleta = 0;
  bool _puedeJugarRuleta = true;
  Timer? _timerCuenta;
  String? _paisSeleccionado;

  @override
  void initState() {
    super.initState();
    _verificarRuleta();
  }

  Future<void> _verificarRuleta() async {
    final puede = await RuletaService.instance.puedeJugar();
    final segundos = await RuletaService.instance.segundosHastaProximaJugada();
    if (!mounted) return;
    setState(() {
      _puedeJugarRuleta = puede;
      _segundosRestantesRuleta = segundos;
    });

    // Mostrar pop-up automático si puede jugar (UNA sola vez por sesión)
    if (puede) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _mostrarPopupRuleta();
      });
    } else {
      _arrancarTimer();
    }
  }

  void _arrancarTimer() {
    _timerCuenta?.cancel();
    _timerCuenta = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        _segundosRestantesRuleta--;
        if (_segundosRestantesRuleta <= 0) {
          _puedeJugarRuleta = true;
          t.cancel();
        }
      });
    });
  }

  void _mostrarPopupRuleta() {
    showDialog(
      context: context,
      builder: (_) => const RuletaPage(modoPopUp: true),
    ).then((_) => _verificarRuleta());
  }

  @override
  void dispose() {
    _timerCuenta?.cancel();
    super.dispose();
  }

  String _formatTiempo(int seg) {
    final h = seg ~/ 3600;
    final m = (seg % 3600) ~/ 60;
    final s = seg % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildHeader(context),
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Franja superior con mensaje global
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A4D2E), Color(0xFF4F6F52)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        '🌎 VENTON PRO GLOBAL',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Publicidad, negocios, turismo y comunidad en Colombia, Venezuela, España y Estados Unidos.',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Selector de país
                PaisSelector(
                  paisSeleccionado: _paisSeleccionado,
                  onPaisChanged: (pais) {
                    setState(() => _paisSeleccionado = pais);
                  },
                ),
                const SizedBox(height: 8),
                // Stories tipo Instagram
                StoriesWidget(
                  stories: [
                    StoryItem(
                      titulo: 'Publicar',
                      icono: Icons.add_circle_rounded,
                      onTap: () => Navigator.pushNamed(context, '/subir_contenido'),
                    ),
                    StoryItem(
                      titulo: 'VENTON PRO',
                      icono: Icons.workspace_premium_rounded,
                      onTap: () => VentonHelpers.abrirWhatsApp(),
                    ),
                    StoryItem(
                      titulo: 'Turismo',
                      icono: Icons.terrain_rounded,
                      onTap: () => Navigator.pushNamed(context, '/turismo'),
                    ),
                    StoryItem(
                      titulo: 'Químicos',
                      icono: Icons.science_rounded,
                      onTap: () => Navigator.pushNamed(context, '/quimicos'),
                    ),
                    StoryItem(
                      titulo: 'Café',
                      icono: Icons.local_cafe_rounded,
                      onTap: () => Navigator.pushNamed(context, '/cafe'),
                    ),
                    StoryItem(
                      titulo: 'Negocios',
                      icono: Icons.store_rounded,
                      onTap: () => Navigator.pushNamed(context, '/vendedores'),
                    ),
                    StoryItem(
                      titulo: 'Colombia',
                      icono: Icons.flag_rounded,
                      onTap: () => VentonHelpers.abrirWhatsApp(
                        mensaje: 'Hola, quiero información sobre negocios en Colombia.',
                      ),
                    ),
                    StoryItem(
                      titulo: 'Venezuela',
                      icono: Icons.flag_rounded,
                      onTap: () => VentonHelpers.abrirWhatsApp(
                        mensaje: 'Hola, quiero información sobre negocios en Venezuela.',
                      ),
                    ),
                    StoryItem(
                      titulo: 'España',
                      icono: Icons.flag_rounded,
                      onTap: () => VentonHelpers.abrirWhatsApp(
                        mensaje: 'Hola, quiero información sobre negocios en España.',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Banner rotativo con mensajes comerciales y psicología de venta
                BannerRotativo(
                  items: [
                    BannerItem(
                      titulo: '📢 Publica tu negocio en VENTON PRO',
                      subtitulo: 'Haz que te vean en más lugares',
                      icono: Icons.campaign_rounded,
                      gradiente: const LinearGradient(
                        colors: [Color(0xFF25D366), Color(0xFF25A045)],
                      ),
                      onTap: () => VentonHelpers.abrirWhatsApp(
                        mensaje: 'Hola, quiero publicar mi negocio en VENTON PRO.',
                      ),
                    ),
                    BannerItem(
                      titulo: '🌎 Colombia · Venezuela · España · Estados Unidos',
                      subtitulo: 'Tu negocio puede crecer sin límites',
                      icono: Icons.public_rounded,
                      gradiente: const LinearGradient(
                        colors: [Color(0xFF1A4D2E), Color(0xFF4F6F52)],
                      ),
                      onTap: () => VentonHelpers.abrirWhatsApp(
                        mensaje: 'Hola, quiero información sobre negocios globales.',
                      ),
                    ),
                    BannerItem(
                      titulo: '🔥 Mira gratis. Comparte fácil.',
                      subtitulo: 'Cuando quieras crecer, anuncia con nosotros',
                      icono: Icons.local_fire_department_rounded,
                      gradiente: const LinearGradient(
                        colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                      ),
                      onTap: () => Navigator.pushNamed(context, '/comunidad'),
                    ),
                    BannerItem(
                      titulo: '💼 Publicidad desde \$20.000/mes',
                      subtitulo: 'Activa tu anuncio por WhatsApp',
                      icono: Icons.monetization_on_rounded,
                      gradiente: const LinearGradient(
                        colors: [Color(0xFFD4AF37), Color(0xFFFFC107)],
                      ),
                      onTap: () => VentonHelpers.abrirWhatsApp(
                        mensaje: 'Hola, quiero activar publicidad en VENTON PRO.',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                // Card ruleta solo para Colombia
                _buildCardRuleta(),
                const SizedBox(height: 18),
                _seccionTitulo(context, 'Acceso rápido'),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AccesoRapido(items: _accesos(context)),
                ),
                const SizedBox(height: 20),
                if (MockData.productosEnOferta.isNotEmpty) ...[
                  _seccionTitulo(
                    context,
                    'Ofertas del momento',
                    icono: Icons.local_fire_department_rounded,
                  ),
                  const SizedBox(height: 6),
                  SeccionOfertas(productos: MockData.productosEnOferta),
                  const SizedBox(height: 16),
                ],
                _seccionTitulo(context, 'Turismo destacado'),
                FeedReciente(
                  titulo: '',
                  items: MockData.turismoSantaRosa
                      .map(
                        (e) => FeedItem(
                          titulo: e.titulo,
                          subtitulo: VentonHelpers.formatearPrecio(e.precio),
                          imagenUrl: e.imagenUrl,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ExperienciaDetallePage(experiencia: e),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
                _seccionTitulo(context, 'Productos premium'),
                FeedReciente(
                  titulo: '',
                  items: MockData.destacadosInicio
                      .map(
                        (p) => FeedItem(
                          titulo: p.nombre,
                          subtitulo: VentonHelpers.formatearPrecio(p.precio),
                          imagenUrl: p.imagenUrl,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductoDetallePage(producto: p),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16),
                BannerAdSlot(
                  onTap: () => VentonHelpers.abrirWhatsApp(
                    mensaje:
                        'Hola VENTON PRO, quiero anunciar mi negocio en la app.',
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardRuleta() {
    final esColombia = _paisSeleccionado == 'Colombia';
    
    if (!esColombia) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          children: [
            Icon(
              Icons.casino_rounded,
              size: 48,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 12),
            Text(
              '🎰 RULETA VENTON',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'La ruleta por ahora solo está disponible en Colombia.\nPróximamente en tu país.',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        elevation: 3,
        shadowColor: AppTheme.bronce.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {
            if (_puedeJugarRuleta) {
              _mostrarPopupRuleta();
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RuletaPage()),
              );
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: _puedeJugarRuleta
                  ? AppTheme.gradienteBronce
                  : LinearGradient(
                      colors: [
                        AppTheme.azulMarino,
                        AppTheme.azulMarinoClaro,
                      ],
                    ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.casino_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _puedeJugarRuleta
                            ? '¡Ya podés girar!'
                            : 'Próxima jugada',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _puedeJugarRuleta
                            ? 'Tu ruleta diaria te espera'
                            : _formatTiempo(_segundosRestantesRuleta),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          fontFamily: _puedeJugarRuleta ? null : 'monospace',
                          letterSpacing: _puedeJugarRuleta ? 0 : 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _puedeJugarRuleta ? 'GIRAR' : 'Ver',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 110,
      pinned: false,
      floating: true,
      backgroundColor: AppTheme.azulMarino,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          tooltip: 'Buscar',
          icon: const Icon(Icons.search_rounded, color: Colors.white),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BuscarPage()),
          ),
        ),
        IconButton(
          tooltip: 'Favoritos',
          icon: const Icon(Icons.favorite_border_rounded, color: Colors.white),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FavoritosPage()),
          ),
        ),
        const SizedBox(width: 4),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppTheme.azulMarino, AppTheme.azulMarinoClaro],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -30,
                top: -30,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.bronce.withOpacity(0.1),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      const VentonProLogo(size: 44, conTexto: false),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            VentonConfig.appName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            'Productos premium',
                            style: TextStyle(
                              color: AppTheme.bronceClaro,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<AccesoRapidoItem> _accesos(BuildContext context) {
    return [
      AccesoRapidoItem(
        icono: Icons.terrain_rounded,
        etiqueta: 'Turismo',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TurismoPage()),
        ),
      ),
      AccesoRapidoItem(
        icono: Icons.local_cafe_rounded,
        etiqueta: 'Café',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CafePage()),
        ),
      ),
      AccesoRapidoItem(
        icono: Icons.science_rounded,
        etiqueta: 'Químicos',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const QuimicosPage()),
        ),
      ),
      AccesoRapidoItem(
        icono: Icons.casino_rounded,
        etiqueta: 'Ruleta',
        color: AppTheme.bronceOscuro,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RuletaPage()),
        ),
      ),
      AccesoRapidoItem(
        icono: Icons.person_add_rounded,
        etiqueta: 'Vendedor',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const VendedorRegistroPage(),
          ),
        ),
      ),
      AccesoRapidoItem(
        icono: Icons.upload_rounded,
        etiqueta: 'Subir',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const SubirContenidoPage(),
          ),
        ),
      ),
      AccesoRapidoItem(
        icono: Icons.favorite_rounded,
        etiqueta: 'Favoritos',
        color: AppTheme.bronceOscuro,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FavoritosPage()),
        ),
      ),
      AccesoRapidoItem(
        icono: Icons.chat_bubble_rounded,
        etiqueta: 'Contacto',
        color: AppTheme.azulMarino,
        onTap: () => VentonHelpers.abrirWhatsApp(),
      ),
    ];
  }

  Widget _seccionTitulo(
    BuildContext context,
    String texto, {
    IconData? icono,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 22,
            decoration: BoxDecoration(
              gradient: AppTheme.gradienteBronce,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          if (icono != null) ...[
            Icon(icono, color: AppTheme.bronceOscuro, size: 18),
            const SizedBox(width: 6),
          ],
          Text(
            texto,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppTheme.azulMarino,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
