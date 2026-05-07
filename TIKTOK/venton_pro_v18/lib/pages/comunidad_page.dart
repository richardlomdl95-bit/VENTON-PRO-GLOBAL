import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../core/models/publicacion_model.dart';
import '../core/publicaciones_service.dart';
import '../core/theme.dart';
import '../core/venton_helpers.dart';
import 'subir_contenido_page.dart';

/// Comunidad VENTON estilo TikTok / Reels.
/// Dos modos: pantalla completa swipe vertical o lista con autoplay.
class ComunidadPage extends StatefulWidget {
  const ComunidadPage({super.key});

  @override
  State<ComunidadPage> createState() => _ComunidadPageState();
}

class _ComunidadPageState extends State<ComunidadPage> {
  List<Publicacion> _publicaciones = [];
  String _miUsuarioId = '';
  bool _cargando = true;
  bool _modoTikTok = false; // false = lista, true = pantalla completa

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final servicio = PublicacionesService.instance;
    final id = await servicio.obtenerUsuarioActualId();
    final lista = await servicio.obtenerVisibles();
    if (!mounted) return;
    setState(() {
      _miUsuarioId = id;
      _publicaciones = lista;
      _cargando = false;
    });
  }

  Future<void> _abrirSubir() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SubirContenidoPage()),
    );
    _cargar();
  }

  @override
  Widget build(BuildContext context) {
    if (_modoTikTok && _publicaciones.isNotEmpty) {
      return _ModoPantallaCompleta(
        publicaciones: _publicaciones,
        miUsuarioId: _miUsuarioId,
        onSalir: () => setState(() => _modoTikTok = false),
        onActualizar: _cargar,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comunidad'),
        actions: [
          if (_publicaciones.isNotEmpty)
            IconButton(
              tooltip: 'Modo pantalla completa',
              icon: const Icon(Icons.smart_display_rounded),
              onPressed: () => setState(() => _modoTikTok = true),
            ),
          IconButton(
            tooltip: 'Publicar',
            icon: const Icon(Icons.add_circle_rounded),
            onPressed: _abrirSubir,
          ),
        ],
      ),
      // SIN FAB de WhatsApp que tape contenido
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _publicaciones.isEmpty
              ? _vacio()
              : RefreshIndicator(
                  onRefresh: _cargar,
                  child: _ListaConAutoPlay(
                    publicaciones: _publicaciones,
                    miUsuarioId: _miUsuarioId,
                    onActualizar: _cargar,
                  ),
                ),
    );
  }

  Widget _vacio() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppTheme.gradienteBronce,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.dynamic_feed_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Todavía no hay publicaciones',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.azulMarino,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sé el primero en compartir un producto, servicio o experiencia con la comunidad VENTON PRO.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _abrirSubir,
              icon: const Icon(Icons.add_a_photo_rounded),
              label: const Text('Crear publicación'),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// MODO LISTA CON AUTOPLAY
// ============================================================
class _ListaConAutoPlay extends StatefulWidget {
  final List<Publicacion> publicaciones;
  final String miUsuarioId;
  final VoidCallback onActualizar;

  const _ListaConAutoPlay({
    required this.publicaciones,
    required this.miUsuarioId,
    required this.onActualizar,
  });

  @override
  State<_ListaConAutoPlay> createState() => _ListaConAutoPlayState();
}

class _ListaConAutoPlayState extends State<_ListaConAutoPlay> {
  int _indiceActivo = 0;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
      itemCount: widget.publicaciones.length,
      itemBuilder: (context, i) => _PublicacionCard(
        key: ValueKey(widget.publicaciones[i].id),
        publicacion: widget.publicaciones[i],
        esMia: widget.publicaciones[i].autorId == widget.miUsuarioId,
        onAccion: widget.onActualizar,
        miUsuarioId: widget.miUsuarioId,
        autoPlay: i == _indiceActivo,
        onVisible: () {
          if (mounted && _indiceActivo != i) {
            setState(() => _indiceActivo = i);
          }
        },
      ),
    );
  }
}

// ============================================================
// MODO PANTALLA COMPLETA (TIKTOK STYLE)
// ============================================================
class _ModoPantallaCompleta extends StatefulWidget {
  final List<Publicacion> publicaciones;
  final String miUsuarioId;
  final VoidCallback onSalir;
  final VoidCallback onActualizar;

  const _ModoPantallaCompleta({
    required this.publicaciones,
    required this.miUsuarioId,
    required this.onSalir,
    required this.onActualizar,
  });

  @override
  State<_ModoPantallaCompleta> createState() => _ModoPantallaCompletaState();
}

class _ModoPantallaCompletaState extends State<_ModoPantallaCompleta> {
  late PageController _pageController;
  int _paginaActual = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Loop infinito: cuando se acaba, vuelve al inicio
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            onPageChanged: (i) => setState(() => _paginaActual = i),
            itemBuilder: (context, index) {
              final pub = widget.publicaciones[index % widget.publicaciones.length];
              return _PantallaCompletaItem(
                key: ValueKey('${pub.id}_$index'),
                publicacion: pub,
                esActiva: index == _paginaActual,
              );
            },
          ),
          // Botón cerrar arriba
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            child: IconButton(
              icon: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 28,
              ),
              onPressed: widget.onSalir,
            ),
          ),
          // Indicador arriba a la derecha
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.swipe_vertical_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${(_paginaActual % widget.publicaciones.length) + 1}/${widget.publicaciones.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
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
}

class _PantallaCompletaItem extends StatelessWidget {
  final Publicacion publicacion;
  final bool esActiva;

  const _PantallaCompletaItem({
    super.key,
    required this.publicacion,
    required this.esActiva,
  });

  @override
  Widget build(BuildContext context) {
    final ruta = publicacion.rutaArchivoLocal;
    return Stack(
      fit: StackFit.expand,
      children: [
        // Medio de fondo
        if (ruta != null && File(ruta).existsSync())
          if (publicacion.tipoMedio == TipoMedio.video)
            _VideoFullScreen(archivo: File(ruta), reproducir: esActiva)
          else
            Image.file(File(ruta), fit: BoxFit.cover)
        else
          Container(color: AppTheme.azulMarino),
        // Gradiente para legibilidad de texto
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
        // Info y botón WhatsApp abajo
        Positioned(
          left: 16,
          right: 16,
          bottom: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: AppTheme.gradienteBronce,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      publicacion.autorNombre,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                publicacion.titulo,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                publicacion.descripcion,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.92),
                  fontSize: 13,
                  height: 1.3,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.whatsappGreen,
                  ),
                  onPressed: () => VentonHelpers.abrirWhatsApp(
                    mensaje:
                        'Hola, vi tu publicación "${publicacion.titulo}" en VENTON PRO.',
                  ),
                  icon: const Icon(Icons.chat_bubble_rounded),
                  label: const Text(
                    'Hablar por WhatsApp',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VideoFullScreen extends StatefulWidget {
  final File archivo;
  final bool reproducir;

  const _VideoFullScreen({required this.archivo, required this.reproducir});

  @override
  State<_VideoFullScreen> createState() => _VideoFullScreenState();
}

class _VideoFullScreenState extends State<_VideoFullScreen> {
  late final VideoPlayerController _controller;
  bool _listo = false;
  bool _muted = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.archivo)
      ..setLooping(true)
      ..setVolume(0)
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() => _listo = true);
        if (widget.reproducir) _controller.play();
      });
  }

  @override
  void didUpdateWidget(covariant _VideoFullScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_listo) {
      if (widget.reproducir && !_controller.value.isPlaying) {
        _controller.play();
      } else if (!widget.reproducir && _controller.value.isPlaying) {
        _controller.pause();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMute() {
    setState(() {
      _muted = !_muted;
      _controller.setVolume(_muted ? 0 : 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_listo) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }
    return GestureDetector(
      onTap: _toggleMute,
      child: Stack(
        fit: StackFit.expand,
        children: [
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          ),
          Positioned(
            top: 80,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _muted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CARD DE LISTA (con autoplay si está visible)
// ============================================================
class _PublicacionCard extends StatelessWidget {
  final Publicacion publicacion;
  final bool esMia;
  final String miUsuarioId;
  final VoidCallback onAccion;
  final bool autoPlay;
  final VoidCallback onVisible;

  const _PublicacionCard({
    super.key,
    required this.publicacion,
    required this.esMia,
    required this.miUsuarioId,
    required this.onAccion,
    required this.autoPlay,
    required this.onVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context),
          if (publicacion.rutaArchivoLocal != null) _medio(),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Chip(
                      label: Text(
                        _etiquetaCategoria(),
                        style: const TextStyle(fontSize: 12),
                      ),
                      visualDensity: VisualDensity.compact,
                      backgroundColor: AppTheme.bronce.withOpacity(0.15),
                    ),
                    const Spacer(),
                    Text(
                      _tiempoTranscurrido(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  publicacion.titulo,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppTheme.azulMarino,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  publicacion.descripcion,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.whatsappGreen,
                        ),
                        onPressed: () => VentonHelpers.abrirWhatsApp(
                          mensaje:
                              'Hola, vi tu publicación "${publicacion.titulo}" en VENTON PRO.',
                        ),
                        icon: const Icon(Icons.chat_bubble_rounded, size: 16),
                        label: const Text('Hablar por WhatsApp'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (esMia)
                      IconButton(
                        tooltip: 'Eliminar mi publicación',
                        icon: const Icon(Icons.delete_outline_rounded),
                        onPressed: () => _eliminarPropia(context),
                      )
                    else
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert_rounded),
                        onSelected: (v) => _ejecutarAccion(context, v),
                        itemBuilder: (_) => const [
                          PopupMenuItem(
                            value: 'reportar',
                            child: Row(
                              children: [
                                Icon(Icons.flag_outlined, size: 18),
                                SizedBox(width: 10),
                                Text('Reportar contenido'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'ocultar',
                            child: Row(
                              children: [
                                Icon(Icons.visibility_off_outlined, size: 18),
                                SizedBox(width: 10),
                                Text('No ver más'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'bloquear',
                            child: Row(
                              children: [
                                Icon(Icons.block_outlined, size: 18),
                                SizedBox(width: 10),
                                Text('Bloquear usuario'),
                              ],
                            ),
                          ),
                        ],
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

  Widget _header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.azulMarino.withOpacity(0.04),
            AppTheme.bronce.withOpacity(0.06),
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppTheme.gradienteBronce,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              publicacion.autorNombre,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppTheme.azulMarino,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (esMia)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppTheme.bronce.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'TU',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.bronceOscuro,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _medio() {
    final ruta = publicacion.rutaArchivoLocal!;
    final archivo = File(ruta);
    if (!archivo.existsSync()) {
      return Container(
        height: 200,
        color: AppTheme.azulMarino.withOpacity(0.1),
        child: const Center(
          child: Icon(Icons.broken_image_rounded, size: 48),
        ),
      );
    }

    if (publicacion.tipoMedio == TipoMedio.video) {
      return _VideoEnLista(
        archivo: archivo,
        reproducir: autoPlay,
        onTap: onVisible,
      );
    }
    return GestureDetector(
      onTap: onVisible,
      child: Image.file(
        archivo,
        width: double.infinity,
        height: 280,
        fit: BoxFit.cover,
      ),
    );
  }

  String _etiquetaCategoria() {
    switch (publicacion.categoria) {
      case CategoriaPublicacion.producto:
        return 'Producto';
      case CategoriaPublicacion.servicio:
        return 'Servicio';
      case CategoriaPublicacion.negocio:
        return 'Negocio';
      case CategoriaPublicacion.turismo:
        return 'Turismo';
    }
  }

  String _tiempoTranscurrido() {
    final dif = DateTime.now().difference(publicacion.fechaCreacion);
    if (dif.inMinutes < 1) return 'ahora';
    if (dif.inHours < 1) return 'hace ${dif.inMinutes} min';
    if (dif.inDays < 1) return 'hace ${dif.inHours} h';
    if (dif.inDays < 30) return 'hace ${dif.inDays} d';
    return 'hace ${(dif.inDays / 30).floor()} m';
  }

  Future<void> _eliminarPropia(BuildContext context) async {
    final c = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Eliminar publicación?'),
        content: const Text('Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (c == true) {
      await PublicacionesService.instance.eliminarPropia(
        publicacion.id,
        miUsuarioId,
      );
      onAccion();
    }
  }

  Future<void> _ejecutarAccion(BuildContext context, String accion) async {
    final servicio = PublicacionesService.instance;
    switch (accion) {
      case 'reportar':
        final motivo = await _pedirMotivoReporte(context);
        if (motivo == null) return;
        await servicio.reportar(publicacion.id, miUsuarioId);
        if (context.mounted) {
          VentonHelpers.mostrarSnack(
            context,
            'Reporte enviado. Gracias por ayudarnos a mantener la comunidad segura.',
          );
        }
        onAccion();
        break;
      case 'ocultar':
        await servicio.ocultarParaUsuario(publicacion.id);
        onAccion();
        break;
      case 'bloquear':
        final c = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('¿Bloquear a ${publicacion.autorNombre}?'),
            content: const Text(
              'No verás más publicaciones de este usuario.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Bloquear'),
              ),
            ],
          ),
        );
        if (c == true) {
          await servicio.bloquearUsuario(publicacion.autorId);
          onAccion();
        }
        break;
    }
  }

  Future<String?> _pedirMotivoReporte(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Reportar contenido'),
        children: [
          for (final motivo in const [
            'Spam o engaño',
            'Contenido sexual',
            'Violencia o acoso',
            'Información falsa',
            'Discurso de odio',
            'Otro motivo',
          ])
            SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, motivo),
              child: Text(motivo),
            ),
        ],
      ),
    );
  }
}

// ============================================================
// VIDEO EN LISTA (autoplay cuando está visible)
// ============================================================
class _VideoEnLista extends StatefulWidget {
  final File archivo;
  final bool reproducir;
  final VoidCallback onTap;

  const _VideoEnLista({
    required this.archivo,
    required this.reproducir,
    required this.onTap,
  });

  @override
  State<_VideoEnLista> createState() => _VideoEnListaState();
}

class _VideoEnListaState extends State<_VideoEnLista> {
  late final VideoPlayerController _controller;
  bool _listo = false;
  bool _muted = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.archivo)
      ..setLooping(true)
      ..setVolume(0)
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() => _listo = true);
        if (widget.reproducir) _controller.play();
      });
  }

  @override
  void didUpdateWidget(covariant _VideoEnLista oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_listo) {
      if (widget.reproducir && !_controller.value.isPlaying) {
        _controller.play();
      } else if (!widget.reproducir && _controller.value.isPlaying) {
        _controller.pause();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMute() {
    setState(() {
      _muted = !_muted;
      _controller.setVolume(_muted ? 0 : 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_listo) {
      return Container(
        height: 280,
        color: AppTheme.azulMarino.withOpacity(0.1),
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    return GestureDetector(
      onTap: () {
        widget.onTap();
        _toggleMute();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
          // Botón de mute
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _muted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
