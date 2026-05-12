import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/venton_config.dart';
import '../core/venton_helpers.dart';
import '../widgets/franja_venton.dart';
import 'experiencia_detalle_page.dart';
import 'turismo_mapa_page.dart';

class TurismoPage extends StatefulWidget {
  const TurismoPage({super.key});

  @override
  State<TurismoPage> createState() => _TurismoPageState();
}

class _TurismoPageState extends State<TurismoPage> with TickerProviderStateMixin {
  late List<AnimationController> _kenBurnsControllers;
  late List<Animation<double>> _kenBurnsAnimations;

  @override
  void initState() {
    super.initState();
    final experiencias = MockData.turismoSantaRosa;
    _kenBurnsControllers = List.generate(
      experiencias.length,
      (index) => AnimationController(
        duration: const Duration(seconds: 8),
        vsync: this,
      )..repeat(reverse: true),
    );
    _kenBurnsAnimations = _kenBurnsControllers
        .map((controller) => Tween<double>(begin: 1.0, end: 1.15).animate(controller))
        .toList();
  }

  @override
  void dispose() {
    for (final controller in _kenBurnsControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final experiencias = MockData.turismoSantaRosa;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        title: const Text(
          'Turismo',
          style: TextStyle(
            color: Color(0xFFD4AF37),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
        actions: [
          IconButton(
            icon: const Icon(Icons.map, color: Color(0xFFD4AF37)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TurismoMapaPage(),
                ),
              );
            },
            tooltip: 'Ver mapa de hoteles',
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          const FranjaVenton(
            mensajes: [
              '🌴 SANTA ROSA DE CABAL',
              '📲 Reserva por WhatsApp',
              '⭐ EXPERIENCIAS VERIFICADAS',
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              itemCount: experiencias.length,
              itemBuilder: (context, i) {
                final e = experiencias[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Material(
                    color: Colors.white,
                    elevation: 2,
                    shadowColor: Color(0xFF0A2540).withOpacity(0.18),
                    borderRadius: BorderRadius.circular(18),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExperienciaDetallePage(experiencia: e),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              AspectRatio(
                                aspectRatio: 16 / 9,
                                child: AnimatedBuilder(
                                  animation: _kenBurnsAnimations[i],
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: _kenBurnsAnimations[i].value,
                                      child: child,
                                    );
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: e.imagenUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (_, __) => Container(
                                      color: theme.colorScheme.surfaceContainerHighest,
                                    ),
                                    errorWidget: (_, __, ___) => Container(
                                      color: theme.colorScheme.surfaceContainerHighest,
                                      child: const Icon(Icons.image, color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    e.titulo,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.titulo,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0A2540),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  e.descripcion,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: Color(0xFFD4A017),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        e.ubicacion,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 16,
                                      color: Color(0xFFD4A017),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      e.duracion,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '\$${e.precio.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFD4AF37),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
