import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/venton_config.dart';
import '../core/venton_helpers.dart';

class RuletaPage extends StatefulWidget {
  const RuletaPage({super.key});

  @override
  State<RuletaPage> createState() => _RuletaPageState();
}

class _RuletaPageState extends State<RuletaPage>
    with SingleTickerProviderStateMixin {
  static const _premios = [
    'Descuento 10%',
    'Producto sorpresa',
    'Tour Café gratis',
    'Descuento 5%',
    'Sigue intentando',
    'Descuento 15%',
    'Gift card',
    'Sigue intentando',
  ];

  late final AnimationController _controller;
  late Animation<double> _animacion;
  int _jugadasTotales = 0;
  bool _girando = false;
  String? _resultado;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _animacion = Tween<double>(begin: 0, end: 0).animate(_controller);
    _cargarJugadas();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _cargarJugadas() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _jugadasTotales = prefs.getInt(VentonConfig.ruletaKey) ?? 0;
    });
  }

  Future<void> _guardarJugadas(int total) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(VentonConfig.ruletaKey, total);
  }

  Future<void> _girar() async {
    if (_girando) return;
    setState(() {
      _girando = true;
      _resultado = null;
    });

    final random = Random();
    final indicePremio = random.nextInt(_premios.length);
    final vueltasExtras = 5 + random.nextInt(3);
    final anguloFinal =
        (vueltasExtras * 2 * pi) + (indicePremio * (2 * pi / _premios.length));

    _animacion = Tween<double>(begin: 0, end: anguloFinal).animate(
      CurvedAnimation(parent: _controller, curve: Curves.decelerate),
    );

    _controller.reset();
    await _controller.forward();

    final nuevoTotal = _jugadasTotales + 1;
    await _guardarJugadas(nuevoTotal);

    if (!mounted) return;
    setState(() {
      _girando = false;
      _jugadasTotales = nuevoTotal;
      _resultado = _premios[indicePremio];
    });

    if (nuevoTotal >= VentonConfig.ruletaJugadasParaPremio) {
      _mostrarPremioMayor();
    }
  }

  void _mostrarPremioMayor() {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        icon: const Icon(Icons.emoji_events, color: Colors.amber, size: 48),
        title: const Text('¡Llegaste al premio mayor!'),
        content: Text(
          'Completaste ${VentonConfig.ruletaJugadasParaPremio} jugadas. '
          'Reclamá tu premio especial por WhatsApp.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Después'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              VentonHelpers.abrirWhatsApp(
                mensaje:
                    '¡Hola VENTON PRO! Completé ${VentonConfig.ruletaJugadasParaPremio} jugadas en la Ruleta. Quiero reclamar mi premio mayor.',
              );
            },
            child: const Text('Reclamar ahora'),
          ),
        ],
      ),
    );
  }

  Future<void> _resetear() async {
    final confirma = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Reiniciar contador?'),
        content: const Text('Esta acción borra tu progreso de jugadas.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reiniciar'),
          ),
        ],
      ),
    );
    if (confirma == true) {
      await _guardarJugadas(0);
      if (!mounted) return;
      setState(() {
        _jugadasTotales = 0;
        _resultado = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progreso = (_jugadasTotales / VentonConfig.ruletaJugadasParaPremio)
        .clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ruleta VENTON'),
        actions: [
          IconButton(
            tooltip: 'Reiniciar',
            icon: const Icon(Icons.refresh),
            onPressed: _resetear,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Jugadas: $_jugadasTotales / ${VentonConfig.ruletaJugadasParaPremio}',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progreso,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Llegá a ${VentonConfig.ruletaJugadasParaPremio} para el premio mayor',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: AnimatedBuilder(
                  animation: _animacion,
                  builder: (_, __) => Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Transform.rotate(
                          angle: _animacion.value,
                          child: CustomPaint(
                            size: const Size(280, 280),
                            painter: _RuletaPainter(
                              premios: _premios,
                              colorBase: theme.colorScheme.primary,
                              colorAlt: theme.colorScheme.secondary,
                            ),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        size: 48,
                        color: theme.colorScheme.error,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_resultado != null) ...[
              Card(
                color: theme.colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Resultado: $_resultado',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _girando ? null : _girar,
                icon: const Icon(Icons.casino),
                label: Text(_girando ? 'Girando...' : 'GIRAR'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RuletaPainter extends CustomPainter {
  final List<String> premios;
  final Color colorBase;
  final Color colorAlt;

  _RuletaPainter({
    required this.premios,
    required this.colorBase,
    required this.colorAlt,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radio = size.width / 2;
    final centro = Offset(radio, radio);
    final anguloPorSeccion = 2 * pi / premios.length;

    for (int i = 0; i < premios.length; i++) {
      final paint = Paint()
        ..color = i.isEven ? colorBase : colorAlt
        ..style = PaintingStyle.fill;

      final inicio = i * anguloPorSeccion - pi / 2;
      canvas.drawArc(
        Rect.fromCircle(center: centro, radius: radio),
        inicio,
        anguloPorSeccion,
        true,
        paint,
      );

      // Etiqueta
      final anguloTexto = inicio + anguloPorSeccion / 2;
      final textPainter = TextPainter(
        text: TextSpan(
          text: premios[i],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout(maxWidth: radio * 0.8);

      canvas.save();
      canvas.translate(centro.dx, centro.dy);
      canvas.rotate(anguloTexto);
      canvas.translate(radio * 0.45, -textPainter.height / 2);
      textPainter.paint(canvas, Offset.zero);
      canvas.restore();
    }

    // Borde
    final borde = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(centro, radio, borde);
  }

  @override
  bool shouldRepaint(covariant _RuletaPainter oldDelegate) => false;
}
