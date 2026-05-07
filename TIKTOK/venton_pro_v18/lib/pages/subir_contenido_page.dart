import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../core/models/publicacion_model.dart';
import '../core/publicaciones_service.dart';
import '../core/theme.dart';
import '../core/venton_helpers.dart';
import '../core/widgets/selector_medios.dart';

class SubirContenidoPage extends StatefulWidget {
  const SubirContenidoPage({super.key});

  @override
  State<SubirContenidoPage> createState() => _SubirContenidoPageState();
}

class _SubirContenidoPageState extends State<SubirContenidoPage> {
  final _formKey = GlobalKey<FormState>();
  final _titulo = TextEditingController();
  final _descripcion = TextEditingController();
  final _autorNombre = TextEditingController();

  CategoriaPublicacion _categoria = CategoriaPublicacion.producto;
  MedioSeleccionado? _medio;
  bool _aceptoTerminos = false;
  bool _enviando = false;

  @override
  void dispose() {
    _titulo.dispose();
    _descripcion.dispose();
    _autorNombre.dispose();
    super.dispose();
  }

  Future<void> _seleccionarMedio() async {
    final medio = await SelectorMedios.mostrar(context);
    if (medio != null && mounted) {
      setState(() => _medio = medio);
    }
  }

  /// Copia el archivo a una carpeta permanente de la app
  /// (los archivos temporales pueden ser borrados por el sistema).
  Future<String> _persistirArchivo(File origen, TipoMedio tipo) async {
    final dir = await getApplicationDocumentsDirectory();
    final carpeta = Directory('${dir.path}/publicaciones');
    if (!await carpeta.exists()) {
      await carpeta.create(recursive: true);
    }
    final ext = tipo == TipoMedio.video ? 'mp4' : 'jpg';
    final destino =
        '${carpeta.path}/pub_${DateTime.now().millisecondsSinceEpoch}.$ext';
    await origen.copy(destino);
    return destino;
  }

  Future<void> _publicar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_aceptoTerminos) {
      VentonHelpers.mostrarSnack(
        context,
        'Aceptá los términos de contenido para continuar',
      );
      return;
    }

    setState(() => _enviando = true);
    try {
      String? rutaPersistida;
      var tipoMedio = TipoMedio.soloTexto;
      if (_medio != null) {
        rutaPersistida = await _persistirArchivo(_medio!.archivo, _medio!.tipo);
        tipoMedio = _medio!.tipo;
      }

      final servicio = PublicacionesService.instance;
      final usuarioId = await servicio.obtenerUsuarioActualId();

      final publicacion = Publicacion(
        id: 'pub_${DateTime.now().millisecondsSinceEpoch}',
        autorId: usuarioId,
        autorNombre: _autorNombre.text.trim().isEmpty
            ? 'Usuario VENTON'
            : _autorNombre.text.trim(),
        categoria: _categoria,
        tipoMedio: tipoMedio,
        titulo: _titulo.text.trim(),
        descripcion: _descripcion.text.trim(),
        rutaArchivoLocal: rutaPersistida,
        fechaCreacion: DateTime.now(),
      );

      await servicio.guardar(publicacion);

      if (!mounted) return;
      _mostrarConfirmacion();
    } catch (e) {
      if (!mounted) return;
      VentonHelpers.mostrarSnack(
        context,
        'No se pudo publicar. Intentá de nuevo.',
      );
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  void _mostrarConfirmacion() {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        icon: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: AppTheme.gradienteBronce,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 32),
        ),
        title: const Text('¡Publicación creada!'),
        content: const Text(
          'Tu contenido ya está disponible en la sección "Comunidad". '
          'Si alguien lo reporta repetidamente, será revisado por el equipo VENTON PRO.',
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context); // dialog
              Navigator.pop(context); // page
            },
            child: const Text('Listo'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subir contenido')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _avisoModeracion(),
            const SizedBox(height: 16),
            _selectorVisual(),
            const SizedBox(height: 16),
            _autorField(),
            const SizedBox(height: 12),
            _categoriaField(),
            const SizedBox(height: 12),
            _tituloField(),
            const SizedBox(height: 12),
            _descripcionField(),
            const SizedBox(height: 16),
            _terminosCheckbox(),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _enviando ? null : _publicar,
              icon: _enviando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.send_rounded),
              label: Text(_enviando ? 'Publicando...' : 'Publicar ahora'),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _avisoModeracion() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.bronce.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.bronce.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, color: AppTheme.bronceOscuro),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Tu contenido se publica al instante. La comunidad puede reportarlo si infringe las normas.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.azulMarino,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectorVisual() {
    if (_medio == null) {
      return InkWell(
        onTap: _seleccionarMedio,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.azulMarino.withOpacity(0.05),
                AppTheme.bronce.withOpacity(0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppTheme.bronce.withOpacity(0.4),
              width: 1.5,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppTheme.gradienteBronce,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_a_photo_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Tocá para agregar foto o video',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.azulMarino,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Cámara · Galería · Hasta 60s video',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: AspectRatio(
            aspectRatio: 16 / 10,
            child: _medio!.tipo == TipoMedio.video
                ? Container(
                    color: AppTheme.azulMarino,
                    child: const Center(
                      child: Icon(
                        Icons.play_circle_filled_rounded,
                        color: Colors.white,
                        size: 80,
                      ),
                    ),
                  )
                : Image.file(_medio!.archivo, fit: BoxFit.cover),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Material(
            color: Colors.black54,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => setState(() => _medio = null),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _medio!.tipo == TipoMedio.video
                      ? Icons.videocam_rounded
                      : Icons.photo_camera_rounded,
                  color: Colors.white,
                  size: 14,
                ),
                const SizedBox(width: 5),
                Text(
                  _medio!.tipo == TipoMedio.video ? 'Video' : 'Foto',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _autorField() {
    return TextFormField(
      controller: _autorNombre,
      decoration: const InputDecoration(
        labelText: 'Tu nombre',
        prefixIcon: Icon(Icons.person_rounded),
      ),
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? 'Requerido' : null,
    );
  }

  Widget _categoriaField() {
    return DropdownButtonFormField<CategoriaPublicacion>(
      value: _categoria,
      decoration: const InputDecoration(
        labelText: 'Categoría',
        prefixIcon: Icon(Icons.category_rounded),
      ),
      items: const [
        DropdownMenuItem(
          value: CategoriaPublicacion.producto,
          child: Text('Producto'),
        ),
        DropdownMenuItem(
          value: CategoriaPublicacion.servicio,
          child: Text('Servicio'),
        ),
        DropdownMenuItem(
          value: CategoriaPublicacion.negocio,
          child: Text('Negocio'),
        ),
        DropdownMenuItem(
          value: CategoriaPublicacion.turismo,
          child: Text('Turismo'),
        ),
      ],
      onChanged: (v) {
        if (v != null) setState(() => _categoria = v);
      },
    );
  }

  Widget _tituloField() {
    return TextFormField(
      controller: _titulo,
      decoration: const InputDecoration(
        labelText: 'Título',
        prefixIcon: Icon(Icons.title_rounded),
      ),
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? 'Requerido' : null,
    );
  }

  Widget _descripcionField() {
    return TextFormField(
      controller: _descripcion,
      maxLines: 4,
      decoration: const InputDecoration(
        labelText: 'Descripción',
        alignLabelWithHint: true,
        prefixIcon: Icon(Icons.description_rounded),
      ),
      validator: (v) =>
          (v == null || v.trim().length < 10) ? 'Mínimo 10 caracteres' : null,
    );
  }

  Widget _terminosCheckbox() {
    return InkWell(
      onTap: () => setState(() => _aceptoTerminos = !_aceptoTerminos),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: _aceptoTerminos,
              onChanged: (v) =>
                  setState(() => _aceptoTerminos = v ?? false),
              activeColor: AppTheme.bronce,
            ),
            Expanded(
              child: Text(
                'Confirmo que el contenido es propio y NO incluye material sexual, '
                'violento, ilegal, ofensivo o que infrinja derechos de terceros. '
                'VENTON PRO puede ocultar publicaciones reportadas por la comunidad.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
