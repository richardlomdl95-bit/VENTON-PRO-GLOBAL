import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/venton_config.dart';
import '../../core/venton_helpers.dart';
import '../producto_detalle_page.dart';

/// Grilla premium de productos.
/// Muestra descuento, badge destacado, y navega al detalle.
class GrillaProductos extends StatelessWidget {
  final List<Producto> productos;
  final void Function(Producto)? onPedir;

  const GrillaProductos({
    super.key,
    required this.productos,
    this.onPedir,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.62,
      ),
      itemCount: productos.length,
      itemBuilder: (context, i) {
        final p = productos[i];
        return _ProductoCard(
          producto: p,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductoDetallePage(producto: p),
            ),
          ),
          onPedir: () {
            if (onPedir != null) {
              onPedir!(p);
            } else {
              VentonHelpers.abrirWhatsApp(
                mensaje:
                    'Hola VENTON PRO, quiero comprar: ${p.nombre} (${VentonHelpers.formatearPrecio(p.precio)}).',
              );
            }
          },
        );
      },
    );
  }
}

class _ProductoCard extends StatelessWidget {
  final Producto producto;
  final VoidCallback onTap;
  final VoidCallback onPedir;

  const _ProductoCard({
    required this.producto,
    required this.onTap,
    required this.onPedir,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.white,
      elevation: 2,
      shadowColor: AppTheme.azulMarino.withOpacity(0.18),
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: CachedNetworkImage(
                    imageUrl: producto.imagenUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.image_outlined),
                    ),
                  ),
                ),
                if (producto.tieneDescuento)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppTheme.gradienteBronce,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '-${producto.descuentoPorcentaje}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          producto.nombre,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.azulMarino,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              VentonHelpers.formatearPrecio(producto.precio),
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: AppTheme.bronceOscuro,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        if (producto.precioAntes != null)
                          Text(
                            VentonHelpers.formatearPrecio(producto.precioAntes!),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: double.infinity,
                      height: 34,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.whatsappGreen,
                          padding: EdgeInsets.zero,
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onPressed: onPedir,
                        icon: const Icon(Icons.chat_bubble, size: 14),
                        label: const Text('Pedir'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
