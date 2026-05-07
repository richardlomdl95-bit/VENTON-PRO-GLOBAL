import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/venton_config.dart';
import '../core/venton_helpers.dart';
import 'experiencia_detalle_page.dart';

class TurismoPage extends StatelessWidget {
  const TurismoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final experiencias = MockData.turismoSantaRosa;

    return Scaffold(
      appBar: AppBar(title: const Text('Turismo Santa Rosa')),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: experiencias.length,
        itemBuilder: (context, i) {
          final e = experiencias[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Material(
              color: Colors.white,
              elevation: 2,
              shadowColor: AppTheme.azulMarino.withOpacity(0.18),
              borderRadius: BorderRadius.circular(18),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ExperienciaDetallePage(experiencia: e),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: CachedNetworkImage(
                        imageUrl: e.imagenUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: theme.colorScheme.surfaceContainerHighest,
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: const Icon(Icons.image_outlined, size: 48),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.titulo,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppTheme.azulMarino,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 14,
                                color: AppTheme.bronceOscuro,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  e.ubicacion,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.bronceOscuro,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.schedule_rounded,
                                size: 14,
                                color: AppTheme.bronceOscuro,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                e.duracion,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.bronceOscuro,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            e.descripcion,
                            style: theme.textTheme.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                VentonHelpers.formatearPrecio(e.precio),
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: AppTheme.azulMarino,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              FilledButton.icon(
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppTheme.whatsappGreen,
                                ),
                                onPressed: () => VentonHelpers.abrirWhatsApp(
                                  mensaje:
                                      'Hola VENTON PRO, quiero reservar: ${e.titulo}.',
                                ),
                                icon: const Icon(Icons.chat_bubble, size: 16),
                                label: const Text('Reservar'),
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
          );
        },
      ),
    );
  }
}
