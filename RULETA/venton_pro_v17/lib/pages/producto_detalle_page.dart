import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../core/favoritos_service.dart';
import '../core/theme.dart';
import '../core/venton_config.dart';
import '../core/venton_helpers.dart';

class ProductoDetallePage extends StatefulWidget {
  final Producto producto;

  const ProductoDetallePage({super.key, required this.producto});

  @override
  State<ProductoDetallePage> createState() => _ProductoDetallePageState();
}

class _ProductoDetallePageState extends State<ProductoDetallePage> {
  bool _esFavorito = false;

  @override
  void initState() {
    super.initState();
    _cargarFavorito();
  }

  Future<void> _cargarFavorito() async {
    final f = await FavoritosService.instance.esFavorito(widget.producto.id);
    if (!mounted) return;
    setState(() => _esFavorito = f);
  }

  Future<void> _alternarFavorito() async {
    await FavoritosService.instance.alternar(widget.producto.id);
    if (!mounted) return;
    setState(() => _esFavorito = !_esFavorito);
    VentonHelpers.mostrarSnack(
      context,
      _esFavorito
          ? 'Agregado a favoritos'
          : 'Quitado de favoritos',
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.producto;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: AppTheme.azulMarino,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                tooltip: _esFavorito ? 'Quitar de favoritos' : 'Agregar a favoritos',
                icon: Icon(
                  _esFavorito ? Icons.favorite : Icons.favorite_border,
                  color: _esFavorito ? AppTheme.bronceClaro : Colors.white,
                ),
                onPressed: _alternarFavorito,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: p.imagenUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      color: AppTheme.azulMarino,
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: AppTheme.azulMarino,
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.transparent,
                            Colors.black.withOpacity(0.4),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (p.tieneDescuento)
                    Positioned(
                      top: 90,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppTheme.gradienteBronce,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.bronce.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          '-${p.descuentoPorcentaje}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.bronce.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        p.categoria,
                        style: const TextStyle(
                          color: AppTheme.bronceOscuro,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      p.nombre,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppTheme.azulMarino,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      p.descripcion,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.bronceOscuro,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          VentonHelpers.formatearPrecio(p.precio),
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: AppTheme.azulMarino,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        if (p.precioAntes != null) ...[
                          const SizedBox(width: 12),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              VentonHelpers.formatearPrecio(p.precioAntes!),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                decoration: TextDecoration.lineThrough,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 28),
                    _seccion(context, 'Descripción'),
                    const SizedBox(height: 8),
                    Text(
                      p.descripcionLarga,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.6,
                          ),
                    ),
                    const SizedBox(height: 24),
                    _infoRow(Icons.verified_outlined, 'Producto VENTON PRO premium'),
                    _infoRow(Icons.local_shipping_outlined, 'Envío a todo el país'),
                    _infoRow(Icons.support_agent_outlined, 'Atención por WhatsApp'),
                    _infoRow(Icons.security_outlined, 'Garantía de calidad'),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _alternarFavorito,
                  icon: Icon(
                    _esFavorito ? Icons.favorite : Icons.favorite_border,
                    color: AppTheme.bronceOscuro,
                  ),
                  label: Text(_esFavorito ? 'Guardado' : 'Guardar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.whatsappGreen,
                  ),
                  onPressed: () => VentonHelpers.abrirWhatsApp(
                    mensaje:
                        'Hola VENTON PRO, quiero comprar: ${p.nombre} (${VentonHelpers.formatearPrecio(p.precio)}).',
                  ),
                  icon: const Icon(Icons.shopping_cart_rounded),
                  label: const Text('Pedir por WhatsApp'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _seccion(BuildContext context, String titulo) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 22,
          decoration: BoxDecoration(
            gradient: AppTheme.gradienteBronce,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          titulo,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppTheme.azulMarino,
              ),
        ),
      ],
    );
  }

  Widget _infoRow(IconData icono, String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.bronce.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icono, color: AppTheme.bronceOscuro, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppTheme.azulMarino,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
