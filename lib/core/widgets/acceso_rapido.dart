import 'package:flutter/material.dart';

/// Acceso rápido individual: ícono + etiqueta + acción.
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

/// Grid de accesos rápidos. Se adapta al ancho disponible.
class AccesoRapido extends StatelessWidget {
  final List<AccesoRapidoItem> items;
  final int columnas;

  const AccesoRapido({
    super.key,
    required this.items,
    this.columnas = 4,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columnas,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.95,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        final color = item.color ?? theme.colorScheme.primary;
        return InkWell(
          onTap: item.onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(item.icono, color: color, size: 28),
                ),
                const SizedBox(height: 8),
                Text(
                  item.etiqueta,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
