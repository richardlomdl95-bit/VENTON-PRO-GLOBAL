import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../core/models/publicacion_model.dart';
import '../core/publicaciones_service.dart';
import '../core/theme.dart';
import '../core/venton_helpers.dart';
import '../core/widgets/boton_whatsapp.dart';
import 'subir_contenido_page.dart';

class ComunidadPage extends StatefulWidget {
  const ComunidadPage({super.key});

  @override
  State<ComunidadPage> createState() => _ComunidadPageState();
}

class _ComunidadPageState extends State<ComunidadPage> {
  List<Publicacion> _publicaciones = [];
  String _miUsuarioId = '';
  bool _cargando = true;

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comunidad'),
        actions: [
          IconButton(
            tooltip: 'Publicar',
            icon: const Icon(Icons.add_circle_rounded),
            onPressed: _abrirSubir,
          ),
        ],
      ),
      floatingActionButton: const BotonWhatsapp(),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _publicaciones.isEmpty
              ? _vacio()
              : RefreshIndicator(
                  onRefresh: _cargar,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _publicaciones.length,
                    itemBuilder: (context, i) => _PublicacionCard(
                      publicacion: _publicaciones[i],
                      esMia: _publicaciones[i].autorId == _miUsuarioId,
                      onAccion: _cargar,
                      miUsuarioId: _miUsuarioId,
                    ),
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

class _PublicacionCard extends StatelessWidget {
  final Publicacion publicacion;
  final bool esMia;
  final String miUsuarioId;
  final VoidCallback onAccion;

  const _PublicacionCard({
    required this.publicacion,
    required this.esMia,
    required this.miUsuarioId,
    required this.onAccion,
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
                    Chip(label: Text(_etiquetaCategoria())),
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
                        fontWeight: FontWeight.w700,
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
                      child: OutlinedButton.icon(
                        onPressed: () => VentonHelpers.abrirWhatsApp(
                          mensaje:
                              'Hola, vi tu publicación "${publicacion.titulo}" en VENTON PRO.',
                        ),
                        icon: const Icon(Icons.chat_bubble_outline, size: 18),
                        label: const Text('Contactar'),
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
      return _VideoPreview(archivo: archivo);
    }
    return Image.file(
      archivo,
      width: double.infinity,
      height: 280,
      fit: BoxFit.cover,
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

class _VideoPreview extends StatefulWidget {
  final File archivo;

  const _VideoPreview({required this.archivo});

  @override
  State<_VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<_VideoPreview> {
  late final VideoPlayerController _controller;
  bool _listo = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.archivo)
      ..setLooping(true)
      ..initialize().then((_) {
        if (mounted) setState(() => _listo = true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
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
      onTap: _toggle,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
          if (!_controller.value.isPlaying)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
        ],
      ),
    );
  }
}
