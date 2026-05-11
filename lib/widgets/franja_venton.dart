import 'package:flutter/material.dart';

class FranjaVenton extends StatefulWidget {
  final List<String> mensajes;
  final Color colorFondo;
  final Color colorTexto;
  final Duration duracion;
  final double altura;

  const FranjaVenton({
    super.key,
    required this.mensajes,
    this.colorFondo = const Color(0xFFD4A017),
    this.colorTexto = Colors.white,
    this.duracion = const Duration(seconds: 25),
    this.altura = 38,
  });

  @override
  State<FranjaVenton> createState() => _FranjaVentonState();
}

class _FranjaVentonState extends State<FranjaVenton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  final GlobalKey _textKey = GlobalKey();
  double _textWidth = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duracion)
      ..repeat();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _textKey.currentContext;
      if (ctx != null && mounted) {
        final box = ctx.findRenderObject() as RenderBox;
        setState(() => _textWidth = box.size.width);
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texto = widget.mensajes.join('   ✦   ');
    final estilo = TextStyle(
      color: widget.colorTexto,
      fontSize: 13,
      fontWeight: FontWeight.w800,
      letterSpacing: 0.6,
    );

    return Container(
      height: widget.altura,
      color: widget.colorFondo,
      alignment: Alignment.centerLeft,
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) {
            final offset = _textWidth == 0 ? 0.0 : -_ctrl.value * _textWidth;
            return Transform.translate(
              offset: Offset(offset, 0),
              child: Row(
                children: List.generate(3, (i) {
                  return Padding(
                    key: i == 0 ? _textKey : null,
                    padding: const EdgeInsets.only(right: 40),
                    child: Text(texto, style: estilo),
                  );
                }),
              ),
            );
          },
        ),
      ),
    );
  }
}
