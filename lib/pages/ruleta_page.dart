import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/ruleta_service.dart';
import '../core/theme.dart';
import '../core/venton_config.dart';
import '../core/venton_helpers.dart';

class RuletaPage extends StatefulWidget {
  /// Si es true, se muestra como pop-up modal (al abrir la app)
  final bool modoPopUp;

  const RuletaPage({super.key, this.modoPopUp = false});

  @override
  State<RuletaPage> createState() => _RuletaPageState();
}

class _RuletaPageState extends State<RuletaPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _spinController;
  bool _girando = false;
  bool _puedeJugar = true;
  int _segundosRestantes = 0;
  int _jugadasGlobales = 0;
  ResultadoRuleta? _resultado;
  Timer? _cooldownTimer;
  double _anguloFinal = 0;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _cargarEstado();
  }

  Future<void> _cargarEstado() async {
    final puede = await RuletaService.instance.puedeJugar();
    final segundos = await RuletaService.instance.segundosHastaProximaJugada();
    final globales = await RuletaService.instance.jugadasGlobales();
    if (!mounted) return;
    setState(() {
      _puedeJugar = puede;
      _segundosRestantes = segundos;
      _jugadasGlobales = globales;
    });
    if (!puede) _arrancarCountdown();
  }

  void _arrancarCountdown() {
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        _segundosRestantes--;
        if (_segundosRestantes <= 0) {
          _puedeJugar = true;
          t.cancel();
        }
      });
    });
  }

  Future<void> _girar() async {
    if (_girando || !_puedeJugar) return;
    setState(() {
      _girando = true;
      _resultado = null;
    });
    HapticFeedback.mediumImpact();

    final resultado = await RuletaService.instance.jugar();
    final premios = MockData.premiosRuleta;
    final indicePremio = premios.indexOf(resultado.premio);
    final anguloPorSeccion = (2 * pi) / premios.length;
    final anguloPremio = indicePremio * anguloPorSeccion;
    // Giramos varias vueltas + ángulo del premio
    _anguloFinal = (5 * 2 * pi) + (2 * pi - anguloPremio);

    _spinController.reset();
    await _spinController.animateTo(1, curve: Curves.easeOutCubic);

    if (!mounted) return;
    HapticFeedback.heavyImpact();

    setState(() {
      _girando = false;
      _resultado = resultado;
      _puedeJugar = false;
      _jugadasGlobales = resultado.jugadasGlobales;
      _segundosRestantes = VentonConfig.horasEntreJugadas * 60 * 60;
    });
    _arrancarCountdown();

    // Mostrar diálogo de premio
    if (!mounted) return;
    _mostrarDialogoPremio(resultado);
  }

  void _mostrarDialogoPremio(ResultadoRuleta resultado) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: _buildPremioDialog(resultado),
      ),
    );

    // Auto-cerrar el modal después de 5 segundos
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  Widget _buildPremioDialog(ResultadoRuleta resultado) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.azulMarino.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(
                resultado.premio.tipo == TipoPremio.descuento
                    ? Icons.sentiment_neutral_rounded
                    : resultado.premio.icono,
                color: Colors.white,
                size: 50,
              ),
              const SizedBox(height: 16),
              Text(
                resultado.premio.tipo == TipoPremio.descuento
                    ? '¡Casi!'
                    : '¡Felicidades!',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.azulMarino,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Reclamá tu premio por WhatsApp con este código',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.bronceOscuro,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.whatsappGreen,
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    VentonHelpers.abrirWhatsApp(
                      mensaje:
                          'Hola VENTON PRO, gané en la ruleta. Mi premio: ${r.premio.nombre}. Código: ${r.codigoUnico}',
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_rounded, size: 18),
                  label: const Text('Reclamar por WhatsApp'),
                ),
              ),
              const SizedBox(height: 6),
            ],
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _spinController.dispose();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  String _formatearTiempo(int segundos) {
    final horas = segundos ~/ 3600;
    final minutos = (segundos % 3600) ~/ 60;
    final segs = segundos % 60;
    return '${horas.toString().padLeft(2, '0')}:${minutos.toString().padLeft(2, '0')}:${segs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final progresoGlobal =
        (_jugadasGlobales % VentonConfig.ruletaJugadasParaPremio) /
            VentonConfig.ruletaJugadasParaPremio;
    final faltan = VentonConfig.ruletaJugadasParaPremio -
        (_jugadasGlobales % VentonConfig.ruletaJugadasParaPremio);

    final body = SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.modoPopUp) ...[
              Row(
                children: [
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
            // Card de progreso global
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.azulMarino.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.emoji_events_rounded,
                        color: AppTheme.bronce,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'GRAN PREMIO',
                        style: TextStyle(
                          color: AppTheme.bronceOscuro,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Faltan $faltan jugadas',
                        style: const TextStyle(
                          color: AppTheme.azulMarino,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progresoGlobal,
                      minHeight: 12,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation(AppTheme.bronce),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Combo Limpieza VENTON al jugador #${VentonConfig.ruletaJugadasParaPremio}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // RULETA
            Center(
              child: SizedBox(
                width: 280,
                height: 280,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _spinController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _anguloFinal * _spinController.value,
                          child: child,
                        );
                      },
                      child: CustomPaint(
                        size: const Size(280, 280),
                        painter: _RuletaPainter(
                          premios: MockData.premiosRuleta,
                        ),
                      ),
                    ),
                    // Flecha indicadora
                    Positioned(
                      top: 0,
                      child: Container(
                        width: 0,
                        height: 0,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CustomPaint(
                          size: const Size(30, 30),
                          painter: _FlechaIndicadora(),
                        ),
                      ),
                    ),
                    // Centro decorativo
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: AppTheme.gradienteBronce,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.bronce.withOpacity(0.5),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.casino_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Botón girar / countdown
            if (_puedeJugar) ...[
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.azulMarino,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _girando ? null : _girar,
                  icon: _girando
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.casino_rounded),
                  label: Text(
                    _girando ? 'Girando...' : '¡GIRAR!',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'PRÓXIMA JUGADA EN',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.bronceOscuro,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: _formatearTiempo(_segundosRestantes)));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Código copiado'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Text(
                        _formatearTiempo(_segundosRestantes),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.azulMarino,
                          letterSpacing: 2,
                          fontFamily: 'monospace',
                        ),
                        fontFamily: 'monospace',
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              '1 jugada cada 24 horas. Premio mayor: Combo Limpieza VENTON al jugador #500.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );

    if (widget.modoPopUp) {
      return Dialog(
        insetPadding: const EdgeInsets.all(20),
        backgroundColor: const Color(0xFFFFF9F2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SizedBox(
          width: double.infinity,
          child: body,
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F2),
      appBar: AppBar(title: const Text('Ruleta VENTON')),
      body: body,
    );
  }
}

class _RuletaPainter extends CustomPainter {
  final List<PremioRuleta> premios;

  _RuletaPainter({required this.premios});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final anguloSeccion = (2 * pi) / premios.length;

    // Borde exterior bronce
    final bordePaint = Paint()
      ..color = AppTheme.bronce
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    canvas.drawCircle(center, radius - 3, bordePaint);

    // Secciones
    for (var i = 0; i < premios.length; i++) {
      final p = premios[i];
      final start = i * anguloSeccion - pi / 2;
      final paint = Paint()
        ..color = i.isEven ? AppTheme.azulMarino : AppTheme.bronce
        ..style = PaintingStyle.fill;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 6),
        start,
        anguloSeccion,
        true,
        paint,
      );

      // Texto
      canvas.save();
      final mid = start + anguloSeccion / 2;
      canvas.translate(
        center.dx + cos(mid) * radius * 0.6,
        center.dy + sin(mid) * radius * 0.6,
      );
      canvas.rotate(mid + pi / 2);
      final tp = TextPainter(
        text: TextSpan(
          text: p.nombre,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      tp.layout(maxWidth: 70);
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _FlechaIndicadora extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD32F2F)
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
