import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme.dart';
import '../models/publicacion_model.dart';

/// Resultado de la selección de medio.
class MedioSeleccionado {
  final File archivo;
  final TipoMedio tipo;

  const MedioSeleccionado({required this.archivo, required this.tipo});
}

/// Hoja inferior con opciones para subir contenido.
/// Cumple con políticas Google Play: el usuario elige explícitamente
/// la fuente del contenido (cámara/galería) y consiente al subir.
class SelectorMedios {
  SelectorMedios._();

  static final ImagePicker _picker = ImagePicker();

  /// Muestra el bottom sheet con las 4 opciones.
  /// Devuelve el medio seleccionado o null si el usuario cancela.
  static Future<MedioSeleccionado?> mostrar(BuildContext context) async {
    return showModalBottomSheet<MedioSeleccionado?>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => const _SelectorMediosSheet(),
    );
  }

  /// Tomar foto con la cámara.
  static Future<MedioSeleccionado?> tomarFoto() async {
    final foto = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );
    if (foto == null) return null;
    return MedioSeleccionado(
      archivo: File(foto.path),
      tipo: TipoMedio.foto,
    );
  }

  /// Grabar video con la cámara (máximo 60 segundos para uso eficiente).
  static Future<MedioSeleccionado?> grabarVideo() async {
    final video = await _picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(seconds: 60),
    );
    if (video == null) return null;
    return MedioSeleccionado(
      archivo: File(video.path),
      tipo: TipoMedio.video,
    );
  }

  /// Elegir foto de galería.
  static Future<MedioSeleccionado?> elegirFotoGaleria() async {
    final foto = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );
    if (foto == null) return null;
    return MedioSeleccionado(
      archivo: File(foto.path),
      tipo: TipoMedio.foto,
    );
  }

  /// Elegir video de galería.
  static Future<MedioSeleccionado?> elegirVideoGaleria() async {
    final video = await _picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(seconds: 120),
    );
    if (video == null) return null;
    return MedioSeleccionado(
      archivo: File(video.path),
      tipo: TipoMedio.video,
    );
  }
}

class _SelectorMediosSheet extends StatelessWidget {
  const _SelectorMediosSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppTheme.bronce.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Agregar contenido',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppTheme.azulMarino,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Elegí cómo querés subir tu publicación',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _OpcionTile(
                      icono: Icons.camera_alt_rounded,
                      titulo: 'Tomar foto',
                      subtitulo: 'Cámara',
                      onTap: () async {
                        final r = await SelectorMedios.tomarFoto();
                        if (context.mounted) Navigator.pop(context, r);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _OpcionTile(
                      icono: Icons.videocam_rounded,
                      titulo: 'Grabar video',
                      subtitulo: 'Hasta 60s',
                      onTap: () async {
                        final r = await SelectorMedios.grabarVideo();
                        if (context.mounted) Navigator.pop(context, r);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _OpcionTile(
                      icono: Icons.photo_library_rounded,
                      titulo: 'Foto galería',
                      subtitulo: 'Elegir',
                      onTap: () async {
                        final r = await SelectorMedios.elegirFotoGaleria();
                        if (context.mounted) Navigator.pop(context, r);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _OpcionTile(
                      icono: Icons.video_library_rounded,
                      titulo: 'Video galería',
                      subtitulo: 'Elegir',
                      onTap: () async {
                        final r = await SelectorMedios.elegirVideoGaleria();
                        if (context.mounted) Navigator.pop(context, r);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OpcionTile extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;

  const _OpcionTile({
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.azulMarino.withOpacity(0.04),
                AppTheme.bronce.withOpacity(0.06),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.bronce.withOpacity(0.18),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: AppTheme.gradienteBronce,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icono, color: Colors.white, size: 24),
              ),
              const SizedBox(height: 10),
              Text(
                titulo,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: AppTheme.azulMarino,
                ),
              ),
              Text(
                subtitulo,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.bronceOscuro,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
