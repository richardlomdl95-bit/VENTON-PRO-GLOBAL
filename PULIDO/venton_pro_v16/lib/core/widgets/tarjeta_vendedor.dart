import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../venton_config.dart';
import '../venton_helpers.dart';

class TarjetaVendedor extends StatelessWidget {
  final Vendedor vendedor;

  const TarjetaVendedor({super.key, required this.vendedor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.white,
      elevation: 2,
      shadowColor: AppTheme.azulMarino.withOpacity(0.15),
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
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
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppTheme.azulMarino,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${vendedor.especialidad} · ${vendedor.ciudad}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.bronceOscuro,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 3),
                          Text(
                            vendedor.calificacion.toStringAsFixed(1),
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.trending_up,
                            color: AppTheme.bronce,
                            size: 16,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${vendedor.ventasMes} ventas',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              vendedor.biografia,
              style: theme.textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.whatsappGreen,
                ),
                onPressed: () => VentonHelpers.abrirWhatsApp(
                  numeroPersonalizado: vendedor.whatsappPropio,
                  mensaje:
                      'Hola ${vendedor.nombre}, te contacto desde la app VENTON PRO.',
                ),
                icon: const Icon(Icons.chat_bubble, size: 18),
                label: Text('Contactar a ${vendedor.nombre.split(' ').first}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
