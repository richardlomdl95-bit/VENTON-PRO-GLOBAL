import 'package:flutter/material.dart';
import '../theme.dart';
import '../venton_helpers.dart';

class StoryItem {
  final String titulo;
  final IconData icono;
  final VoidCallback onTap;

  const StoryItem({
    required this.titulo,
    required this.icono,
    required this.onTap,
  });
}

class StoriesWidget extends StatelessWidget {
  final List<StoryItem> stories;

  const StoriesWidget({
    super.key,
    required this.stories,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Stories',
              style: TextStyle(
                color: AppTheme.bronce,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: stories.length,
              itemBuilder: (context, index) {
                final story = stories[index];
                return Container(
                  width: 70,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFD4AF37), // Dorado
                              width: 2,
                            ),
                            color: AppTheme.bronceClaro,
                          ),
                          child: Center(
                            child: Icon(
                              story.icono,
                              color: const Color(0xFFD4AF37), // Dorado
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        height: 16,
                        child: Text(
                          story.titulo,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.bronceOscuro,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
