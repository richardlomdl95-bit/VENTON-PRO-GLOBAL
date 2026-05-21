import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Carrusel de fotos que rota solo cada 3 segundos.
/// Recibe una lista de URLs de imágenes (las fotos viven en internet, no se
/// suben a la app). Si la lista viene vacía, no muestra nada y no falla.
class WidgetCarrusel extends StatefulWidget {
  final List<String> imagenes;
  final double altura;
  const WidgetCarrusel({super.key, required this.imagenes, this.altura = 200});

  @override
  State<WidgetCarrusel> createState() => _WidgetCarruselState();
}

class _WidgetCarruselState extends State<WidgetCarrusel> {
  final PageController _control = PageController();
  Timer? _timer;
  int _actual = 0;

  @override
  void initState() {
    super.initState();
    if (widget.imagenes.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 3), (_) {
        _actual = (_actual + 1) % widget.imagenes.length;
        if (_control.hasClients) {
          _control.animateToPage(
            _actual,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _control.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imagenes.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        SizedBox(
          height: widget.altura,
          child: PageView.builder(
            controller: _control,
            itemCount: widget.imagenes.length,
            onPageChanged: (i) => setState(() => _actual = i),
            itemBuilder: (_, i) => ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: widget.imagenes[i],
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (_, __) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (_, __, ___) =>
                    const Icon(Icons.image_not_supported, size: 40),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.imagenes.length, (i) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _actual == i ? 18 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _actual == i ? Colors.blue : Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}
