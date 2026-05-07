import 'package:flutter/material.dart';
import '../theme.dart';

/// Logo oficial de VENTON PRO.
/// Escudo vectorial dibujado con CustomPainter.
/// Se ve nítido a cualquier tamaño y carga al instante.
class VentonProLogo extends StatelessWidget {
  final double size;
  final bool conTexto;

  const VentonProLogo({
    super.key,
    this.size = 120,
    this.conTexto = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ShieldPainter(conTexto: conTexto),
      ),
    );
  }
}

/// Logo + nombre debajo del escudo.
class VentonProLogoCompleto extends StatelessWidget {
  final double escudoSize;

  const VentonProLogoCompleto({
    super.key,
    this.escudoSize = 140,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        VentonProLogo(size: escudoSize, conTexto: true),
        const SizedBox(height: 12),
        ShaderMask(
          shaderCallback: (bounds) => AppTheme.gradienteBronce.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          child: Text(
            'PRODUCTOS PREMIUM',
            style: TextStyle(
              fontSize: escudoSize * 0.085,
              fontWeight: FontWeight.w800,
              letterSpacing: escudoSize * 0.025,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _ShieldPainter extends CustomPainter {
  final bool conTexto;

  _ShieldPainter({required this.conTexto});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final shieldPath = _crearEscudoPath(w, h);
    final innerShieldPath = _crearEscudoPath(w, h, padding: w * 0.055);

    // Sombra del escudo
    canvas.drawShadow(
      shieldPath,
      Colors.black.withOpacity(0.35),
      6,
      true,
    );

    // Borde bronce con degradado
    final bordePaint = Paint()
      ..shader = AppTheme.gradienteBronce.createShader(
        Rect.fromLTWH(0, 0, w, h),
      )
      ..style = PaintingStyle.fill;
    canvas.drawPath(shieldPath, bordePaint);

    // Línea fina interior bronce
    final lineaPaint = Paint()
      ..color = AppTheme.bronceClaro
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.008;
    final mediaPath = _crearEscudoPath(w, h, padding: w * 0.025);
    canvas.drawPath(mediaPath, lineaPaint);

    // Fondo azul marino interior con degradado
    final fondoPaint = Paint()
      ..shader = AppTheme.gradienteEscudo.createShader(
        Rect.fromLTWH(0, 0, w, h),
      )
      ..style = PaintingStyle.fill;
    canvas.drawPath(innerShieldPath, fondoPaint);

    final centerX = w / 2;

    // Texto "VENTON PRO"
    if (conTexto) {
      _dibujarTexto(canvas, w, h, centerX);
    }

    // Símbolo central: orbe + gota
    _dibujarSimboloCentral(canvas, w, h, centerX);

    // Tres gotas decorativas debajo
    _dibujarGotasInferiores(canvas, w, h, centerX);
  }

  void _dibujarTexto(Canvas canvas, double w, double h, double centerX) {
    final textPainter = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'VENTON\n',
            style: TextStyle(
              color: AppTheme.bronceClaro,
              fontSize: w * 0.135,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
              height: 1.1,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
          TextSpan(
            text: 'PRO',
            style: TextStyle(
              color: AppTheme.bronceClaro,
              fontSize: w * 0.135,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              height: 1.1,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ],
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        (w - textPainter.width) / 2,
        h * 0.16,
      ),
    );
  }

  void _dibujarSimboloCentral(
      Canvas canvas, double w, double h, double centerX) {
    final centerY = h * 0.58;
    final orbWidth = w * 0.36;
    final orbHeight = w * 0.16;

    // Anillos orbitales (efecto planetario)
    final orbPaint = Paint()
      ..color = AppTheme.bronceClaro
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.011;

    canvas.save();
    canvas.translate(centerX, centerY);
    canvas.rotate(-0.35);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: orbWidth,
        height: orbHeight,
      ),
      orbPaint,
    );
    canvas.restore();

    canvas.save();
    canvas.translate(centerX, centerY);
    canvas.rotate(0.35);
    final orbPaint2 = Paint()
      ..color = AppTheme.bronce
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.009;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: orbWidth * 0.85,
        height: orbHeight * 0.7,
      ),
      orbPaint2,
    );
    canvas.restore();

    // Gota central grande (ícono químico/premium)
    final dropPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppTheme.bronceClaro, AppTheme.bronce],
      ).createShader(
        Rect.fromCircle(
          center: Offset(centerX, centerY),
          radius: w * 0.1,
        ),
      )
      ..style = PaintingStyle.fill;

    final gotaPath = _crearGotaPath(centerX, centerY - h * 0.02, w * 0.09);
    canvas.drawPath(gotaPath, dropPaint);

    // Highlight de la gota
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(centerX - w * 0.025, centerY - h * 0.045),
      w * 0.018,
      highlightPaint,
    );
  }

  void _dibujarGotasInferiores(
      Canvas canvas, double w, double h, double centerX) {
    final dropY = h * 0.82;
    final dropSpacing = w * 0.085;

    final gotaPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppTheme.bronceClaro, AppTheme.bronceOscuro],
      ).createShader(
        Rect.fromLTWH(0, dropY - w * 0.03, w, w * 0.06),
      )
      ..style = PaintingStyle.fill;

    for (int i = -1; i <= 1; i++) {
      final dropX = centerX + (i * dropSpacing);
      final dropSize = i == 0 ? w * 0.028 : w * 0.022;
      final smallDropPath = _crearGotaPath(dropX, dropY, dropSize);
      canvas.drawPath(smallDropPath, gotaPaint);
    }
  }

  Path _crearEscudoPath(double w, double h, {double padding = 0}) {
    final path = Path();
    final p = padding;
    final innerW = w - 2 * p;
    final innerH = h - 2 * p;

    // Esquinas superiores redondeadas + punta inferior
    final r = innerW * 0.08;

    path.moveTo(p + r, p);
    path.lineTo(p + innerW - r, p);
    path.quadraticBezierTo(p + innerW, p, p + innerW, p + r);
    path.lineTo(p + innerW, p + innerH * 0.55);
    path.quadraticBezierTo(
      p + innerW, p + innerH * 0.78,
      p + innerW * 0.5, p + innerH,
    );
    path.quadraticBezierTo(
      p, p + innerH * 0.78,
      p, p + innerH * 0.55,
    );
    path.lineTo(p, p + r);
    path.quadraticBezierTo(p, p, p + r, p);
    path.close();

    return path;
  }

  Path _crearGotaPath(double cx, double cy, double size) {
    final path = Path();
    path.moveTo(cx, cy - size);
    path.cubicTo(
      cx + size * 0.85, cy - size * 0.5,
      cx + size * 0.95, cy + size * 0.3,
      cx, cy + size,
    );
    path.cubicTo(
      cx - size * 0.95, cy + size * 0.3,
      cx - size * 0.85, cy - size * 0.5,
      cx, cy - size,
    );
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(_ShieldPainter oldDelegate) => false;
}
