import 'package:flutter/material.dart';
import '../theme.dart';

class AccesoRapidoItem {
  final IconData icono;
  final String etiqueta;
  final VoidCallback onTap;
  final Color? color;

  const AccesoRapidoItem({
    required this.icono,
    required this.etiqueta,
    required this.onTap,
    this.color,
  });
}

/// Grid de accesos rápidos con altura adaptativa (sin overflow).
class AccesoRapido extends StatelessWidget {
  final List<AccesoRapidoItem> items;

  const AccesoRapido({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Cálculo dinámico: 4 columnas, altura justa para evitar overflow
        const columnas = 4;
        const spacing = 10.0;
        final availableWidth = constraints.maxWidth - (spacing * (columnas - 1));
        final itemWidth = availableWidth / columnas;
        final filas = (items.length / columnas).ceil();
        // Altura por item generosa: ícono(56) + gap(10) + texto(36) = ~110
        const itemHeight = 110.0;
        final totalHeight = (itemHeight * filas) + (spacing * (filas - 1));

        return SizedBox(
          height: totalHeight,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnas,
              mainAxisSpacing: spacing,
              crossAxisSpacing: spacing,
              mainAxisExtent: itemHeight,
            ),
            itemCount: items.length,
            itemBuilder: (context, i) {
              final item = items[i];
              return _AccesoRapidoTile(item: item, width: itemWidth);
            },
          ),
        );
      },
    );
  }
}

class _AccesoRapidoTile extends StatelessWidget {
  final AccesoRapidoItem item;
  final double width;

  const _AccesoRapidoTile({required this.item, required this.width});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = item.color ?? AppTheme.azulMarino;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withOpacity(0.15),
                    color.withOpacity(0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: color.withOpacity(0.18),
                  width: 1,
                ),
              ),
              child: Icon(item.icono, color: color, size: 26),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 32,
              child: Text(
                item.etiqueta,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
