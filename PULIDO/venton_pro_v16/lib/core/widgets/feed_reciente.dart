import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme.dart';

class FeedItem {
  final String titulo;
  final String subtitulo;
  final String imagenUrl;
  final VoidCallback? onTap;

  const FeedItem({
    required this.titulo,
    required this.subtitulo,
    required this.imagenUrl,
    this.onTap,
  });
}

class FeedReciente extends StatelessWidget {
  final String titulo;
  final List<FeedItem> items;

  const FeedReciente({
    super.key,
    required this.titulo,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (titulo.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Row(
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
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppTheme.azulMarino,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          )
        else
          const SizedBox(height: 4),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) => _Card(item: items[i]),
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  final FeedItem item;
  const _Card({required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: Material(
        elevation: 3,
        shadowColor: AppTheme.azulMarino.withOpacity(0.2),
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        child: InkWell(
          onTap: item.onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: CachedNetworkImage(
                  imageUrl: item.imagenUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: Colors.grey[200]),
                  errorWidget: (_, __, ___) =>
                      Container(color: Colors.grey[200]),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.titulo,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                          color: AppTheme.azulMarino,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        item.subtitulo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppTheme.bronceOscuro,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
