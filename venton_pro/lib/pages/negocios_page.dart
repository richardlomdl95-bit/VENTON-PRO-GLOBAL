import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../core/venton_config.dart';
import '../core/venton_helpers.dart';
import '../core/widgets/boton_whatsapp.dart';

class NegociosPage extends StatelessWidget {
  const NegociosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final negocios = MockData.negocios;

    return Scaffold(
      appBar: AppBar(title: const Text('Oportunidades de Negocio')),
      floatingActionButton: const BotonWhatsapp(
        mensaje:
            'Hola VENTON PRO, quiero información sobre las oportunidades de negocio.',
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: negocios.length,
        itemBuilder: (context, i) {
          final n = negocios[i];
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
                      imageUrl: n.imagenUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: const Icon(Icons.business, size: 48),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Chip(
                              label: Text(n.categoria),
                              backgroundColor:
                                  theme.colorScheme.primaryContainer,
                              labelStyle: TextStyle(
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(n.ciudad, style: theme.textTheme.bodySmall),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(n.nombre, style: theme.textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(n.descripcion, style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () => VentonHelpers.abrirWhatsApp(
                              mensaje:
                                  'Hola VENTON PRO, me interesa: ${n.nombre}.',
                            ),
                            icon: const Icon(Icons.chat),
                            label: const Text('Quiero más información'),
                          ),
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
