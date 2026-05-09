import 'package:flutter/material.dart';

class RuletaPage extends StatelessWidget {
  const RuletaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        title: const Text('Ruleta', style: TextStyle(color: Color(0xFFD4AF37))),
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
        elevation: 0,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Ruleta en mantenimiento.\nDisponible próximamente.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
          ),
        ),
      ),
    );
  }
}
