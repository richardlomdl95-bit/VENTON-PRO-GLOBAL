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

class AccesoRapido extends StatelessWidget {
  final List<AccesoRapidoItem> items;

  const AccesoRapido({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    const columnas = 4;
    const spacing = 10.0;
    const itemHeight = 100.0;
    final filas = (items.length / columnas).ceil();
    final totalHeight = (itemHeight * filas) + (spacing * (filas - 1));

    return SizedBox(
      height: totalHeight,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnas,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          mainAxisExtent: itemHeight,
        ),
        itemCount: items.length,
        itemBuilder: (context, i) => _Tile(item: items[i]),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final AccesoRapidoItem item;
  const _Tile({required this.item});

  @override
  Widget build(BuildContext context) {
    final color = item.color ?? AppTheme.azulMarino;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withOpacity(0.15),
                    color.withOpacity(0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: color.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(item.icono, color: color, size: 24),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 28,
              child: Text(
                item.etiqueta,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.azulMarino,
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
