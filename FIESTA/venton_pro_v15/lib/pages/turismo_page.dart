import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../core/venton_config.dart';
import '../core/venton_helpers.dart';
import '../core/widgets/boton_whatsapp.dart';

class TurismoPage extends StatelessWidget {
  const TurismoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final experiencias = MockData.turismoSantaRosa;

    return Scaffold(
      appBar: AppBar(title: const Text('Turismo Santa Rosa')),
      floatingActionButton: const BotonWhatsapp(
        mensaje:
            'Hola VENTON PRO, quiero información de los planes turísticos de Santa Rosa.',
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: experiencias.length,
        itemBuilder: (context, i) {
          final e = experiencias[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
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
                        child: const Icon(Icons.image_not_supported, size: 48),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.titulo, style: theme.textTheme.titleLarge),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                e.ubicacion,
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(e.descripcion, style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              VentonHelpers.formatearPrecio(e.precio),
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            FilledButton.icon(
                              onPressed: () => VentonHelpers.abrirWhatsApp(
                                mensaje:
                                    'Hola VENTON PRO, me interesa la experiencia: ${e.titulo}.',
                              ),
                              icon: const Icon(Icons.chat),
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
          );
        },
      ),
    );
  }
}
