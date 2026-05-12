import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/franja_venton.dart';

class NegociosPage extends StatelessWidget {
  const NegociosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD4A017),
        title: const Text(
          'Negocios',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const FranjaVenton(
              mensajes: [
                '🔥 ANUNCIA TU NEGOCIO AQUÍ',
                '⭐ PLAN TOP \$100.000/MES',
                '📲 WhatsApp 322 560 9121',
                '✨ PRIMER MES GRATIS',
              ],
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.storefront,
                        size: 80,
                        color: Color(0xFFD4AF37),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Sé el primer negocio en aparecer aquí',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F1B3D),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Plan Visible \$20.000/mes · Destacado \$50.000/mes · Top \$100.000/mes',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () async {
                            final url = Uri.parse(
                              'https://wa.me/573225609121?text=Hola%20quiero%20anunciar%20mi%20negocio%20en%20VENTON%20PRO',
                            );
                            if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('No se pudo abrir WhatsApp')),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF25D366),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            '💬 Anunciar mi negocio',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
