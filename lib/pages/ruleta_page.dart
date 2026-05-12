import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'turismo_mapa_page.dart';

class RuletaPage extends StatefulWidget {
  const RuletaPage({super.key});

  @override
  State<RuletaPage> createState() => _RuletaPageState();
}

class _RuletaPageState extends State<RuletaPage>
    with TickerProviderStateMixin {
  static const Color _negro = Color(0xFF0A0A0A);
  static const Color _dorado = Color(0xFFD4AF37);
  static const Color _gris = Color(0xFF666666);

  late final AnimationController _spinController;
  late final Animation<double> _spinAnimation;
  final List<String> _premios = [
    '10% DESCUENTO',
    'ENVÍO GRATIS',
    '5% DESCUENTO',
    'SIGUE INTENTANDO',
    '15% DESCUENTO',
    'SIGUE INTENTANDO',
    '20% DESCUENTO',
    'SIGUE INTENTANDO',
  ];
  int _resultadoIndex = -1;
  bool _girando = false;
  int _contadorGlobal = 0;

  @override
  void initState() {
    super.initState();
    _cargarContadorGlobal();
    _spinController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _spinAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _spinController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  Future<void> _cargarContadorGlobal() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _contadorGlobal = prefs.getInt('ruleta_contador_global') ?? 0;
    });
  }

  Future<void> _incrementarContadorGlobal() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _contadorGlobal++;
      prefs.setInt('ruleta_contador_global', _contadorGlobal);
    });
  }

  Future<void> _girarRuleta() async {
    if (_girando) return;

    setState(() {
      _girando = true;
      _resultadoIndex = -1;
    });

    HapticFeedback.lightImpact();

    await _incrementarContadorGlobal();

    final vueltas = 5;
    int premioAleatorio;
    
    // Lógica 1/100 REAL: Solo el usuario #100 gana, el resto siempre pierde
    if (_contadorGlobal == 100) {
      premioAleatorio = 0; // 10% DESCUENTO - GANADOR REAL
    } else if (_contadorGlobal == 200) {
      premioAleatorio = 1; // ENVÍO GRATIS - GANADOR REAL  
    } else {
      // 99% de usuarios SIEMPRE obtienen "SIGUE INTENTANDO"
      final indicesPerdedores = [3, 5, 7]; // Posiciones de "SIGUE INTENTANDO"
      premioAleatorio = indicesPerdedores[Random().nextInt(indicesPerdedores.length)];
    }

    final gradosPorSeccion = 360 / _premios.length;
    final anguloFinal = (vueltas * 360) + (premioAleatorio * gradosPorSeccion) + (gradosPorSeccion / 2);

    _spinController.reset();
    await _spinController.forward();

    setState(() {
      _resultadoIndex = premioAleatorio;
      _girando = false;
    });

    // Agregar vibración fuerte cuando se gana
    if (premioAleatorio != 3 && premioAleatorio != 5 && premioAleatorio != 7) {
      HapticFeedback.heavyImpact();
    }

    _mostrarResultado(_premios[premioAleatorio]);
  }

  void _mostrarResultado(String premio) {
    final esGanador = !premio.contains('SIGUE INTENTANDO');
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: _negro,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _negro,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: esGanador ? _dorado : Colors.grey,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                esGanador ? Icons.celebration : Icons.refresh,
                color: esGanador ? _dorado : Colors.grey,
                size: 60,
              ),
              const SizedBox(height: 16),
              Text(
                esGanador ? '¡FELICIDADES!' : 'Sigue participando',
                style: TextStyle(
                  color: esGanador ? _dorado : Colors.grey,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                premio,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              if (_contadorGlobal == 100)
                const Text(
                  '¡GANASTE MEDIO LITRO DE CHAMPÚ!',
                  style: TextStyle(
                    color: _dorado,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (_contadorGlobal == 200)
                const Text(
                  '¡GANASTE LITRO DE CHAMPÚ!',
                  style: TextStyle(
                    color: _dorado,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _dorado,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'ACEPTAR',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Permitir navegación hacia atrás con botón físico
        return true;
      },
      child: Scaffold(
        backgroundColor: _negro,
        appBar: AppBar(
          backgroundColor: _negro,
          title: const Text(
            'Ruleta VENTON',
            style: TextStyle(
              color: _dorado,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: _dorado),
            onPressed: () {
              Navigator.pop(context); // Flecha atrás funcional
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Jugada #$_contadorGlobal',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize:16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 280,
                height: 280,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: _dorado, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: _dorado.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _spinAnimation,
                      builder: (_, __) {
                        return Transform.rotate(
                          angle: _spinAnimation.value,
                          child: CustomPaint(
                            size: const Size(260, 260),
                            painter: RuletaPainter(
                              colores: [
                                Color(0xFFFFD700), // dorado
                                Color(0xFFDC143C), // rojo carmesí
                                Color(0xFF10B981), // verde esmeralda
                                Color(0xFF3B82F6), // azul real
                                Color(0xFFF97316), // naranja
                                Color(0xFF8B5CF6), // morado
                                Color(0xFFEC4899), // rosa fucsia
                                Color(0xFFFBBF24), // amarillo neon
                              ],
                              textos: _premios,
                            ),
                          ),
                        );
                      },
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: _negro,
                        shape: BoxShape.circle,
                        border: Border.all(color: _dorado, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: _dorado.withOpacity(0.5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.star,
                        color: _dorado,
                        size: 30,
                      ),
                    ),
                    Positioned(
                      top: -10,
                      child: Container(
                        width: 0,
                        height: 0,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: _girando ? null : _girarRuleta,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _dorado,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 8,
                    shadowColor: _dorado.withOpacity(0.4),
                  ),
                  child: _girando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        )
                      : const Text(
                          'GIRAR',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
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

class RuletaPainter extends CustomPainter {
  final List<Color> colores;
  final List<String> textos;

  RuletaPainter({
    required this.colores,
    required this.textos,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final anglePerSection = 2 * pi / colores.length;

    for (int i = 0; i < colores.length; i++) {
      final startAngle = i * anglePerSection - pi / 2;
      final sweepAngle = anglePerSection;

      // Dibujar sección
      final paint = Paint()
        ..color = colores[i]
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // Dibujar borde
      final borderPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        borderPaint,
      );

      // Dibujar texto
      final textAngle = startAngle + sweepAngle / 2;
      final textRadius = radius * 0.7;
      final textX = center.dx + textRadius * cos(textAngle);
      final textY = center.dy + textRadius * sin(textAngle);

      final textPainter = TextPainter(
        text: TextSpan(
          text: textos[i],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      
      // Rotar texto
      canvas.save();
      canvas.translate(textX, textY);
      canvas.rotate(textAngle + pi / 2);
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
