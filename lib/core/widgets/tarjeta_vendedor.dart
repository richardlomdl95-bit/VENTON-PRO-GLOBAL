import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../venton_config.dart';

/// Tarjeta visual de un vendedor.
class TarjetaVendedor extends StatelessWidget {
  final Vendedor vendedor;
  final VoidCallback? onTap;

  const TarjetaVendedor({
    super.key,
    required this.vendedor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  imageUrl: vendedor.imagenUrl,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    width: 64,
                    height: 64,
                    color: theme.colorScheme.surfaceContainerHighest,
                  ),
                  errorWidget: (_, __, ___) => Container(
                    width: 64,
                    height: 64,
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.person),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vendedor.nombre,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${vendedor.especialidad} · ${vendedor.ciudad}',
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          vendedor.calificacion.toStringAsFixed(1),
                          style: theme.textTheme.labelMedium,
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.trending_up,
                          color: theme.colorScheme.primary,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${vendedor.ventasMes} ventas',
                          style: theme.textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
