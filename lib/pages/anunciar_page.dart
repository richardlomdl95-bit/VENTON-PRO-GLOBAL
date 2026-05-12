import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AnunciarPage extends StatelessWidget {
  const AnunciarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        title: const Text(
          'Anuncia tu Negocio',
          style: TextStyle(
            color: Color(0xFFD4A017),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFD4A017)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bloque superior dorado
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFD4A017),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    '📣',
                    style: TextStyle(fontSize: 48),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Llega a miles de turistas',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tu negocio en la vitrina digital de Santa Rosa',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // TARJETA 1 - PLAN VISIBLE
            _PlanCard(
              titulo: 'PLAN VISIBLE',
              precio: r'\$20.000 COP/mes',
              colorBorde: const Color(0xFFD4A017),
              colorFondo: Colors.white,
              caracteristicas: [
                'Aparece en listados',
                'Foto de tu negocio',
                'Botón WhatsApp directo',
                'Ubicación en mapa',
              ],
              colorBoton: const Color(0xFF25D366),
              textoBoton: 'Empezar ahora',
            ),

            const SizedBox(height: 16),

            // TARJETA 2 - PLAN DESTACADO
            _PlanCard(
              titulo: 'PLAN DESTACADO',
              precio: r'\$50.000 COP/mes',
              colorBorde: const Color(0xFFD4A017),
              colorFondo: Colors.white,
              anchoBorde: 3,
              badge: 'POPULAR',
              colorBadge: Colors.red,
              caracteristicas: [
                'Todo del Visible',
                'Aparece en Historias arriba',
                'Foto más grande',
                'Prioridad en búsqueda',
              ],
              colorBoton: const Color(0xFF25D366),
              textoBoton: 'Empezar ahora',
            ),

            const SizedBox(height: 16),

            // TARJETA 3 - PLAN TOP
            _PlanCard(
              titulo: 'PLAN TOP',
              precio: r'\$100.000 COP/mes',
              colorBorde: const Color(0xFFD4A017),
              colorFondo: const Color(0xFFD4A017),
              colorTexto: Colors.black,
              badge: 'PREMIUM',
              colorBadge: const Color(0xFFD4A017),
              caracteristicas: [
                'Todo del Destacado',
                'Aparece en Destacados Hoy',
                'Video promocional',
                'Estadísticas mensuales',
                'Soporte prioritario',
              ],
              colorBoton: Colors.black,
              textoBoton: 'Empezar ahora',
              colorTextoBoton: const Color(0xFFD4A017),
            ),

            const SizedBox(height: 24),

            // Bloque inferior verde - PLAN SEMILLA
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF25D366),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    '🌱 PLAN SEMILLA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Primer mes GRATIS para los primeros 20 negocios de Santa Rosa',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Botón final WhatsApp
            Container(
              margin: const EdgeInsets.all(16),
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final url = Uri.parse('https://wa.me/573225609121?text=Hola%20Ricardo%20quiero%20anunciar%20mi%20negocio%20en%20VENTON%20PRO%20Plan%20Semilla');
                  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No se pudo abrir WhatsApp')),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.chat, color: Colors.white),
                label: const Text(
                  '💬 Hablar con Ricardo ahora',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Texto internacional
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              child: const Text(
                'También aceptamos negocios de Venezuela 🇻🇪, España 🇪🇸 y Estados Unidos 🇺🇸. Precios en bolívares, euros y dólares disponibles.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String titulo;
  final String precio;
  final Color colorBorde;
  final Color colorFondo;
  final Color colorTexto;
  final double anchoBorde;
  final String? badge;
  final Color? colorBadge;
  final List<String> caracteristicas;
  final Color colorBoton;
  final String textoBoton;
  final Color? colorTextoBoton;

  const _PlanCard({
    required this.titulo,
    required this.precio,
    required this.colorBorde,
    required this.colorFondo,
    this.colorTexto = Colors.black,
    this.anchoBorde = 2,
    this.badge,
    this.colorBadge,
    required this.caracteristicas,
    required this.colorBoton,
    required this.textoBoton,
    this.colorTextoBoton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colorFondo,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorBorde, width: anchoBorde),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Badge si existe
          if (badge != null)
            Positioned(
              top: -2,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorBadge ?? Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          // Contenido
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    color: colorTexto,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  precio,
                  style: TextStyle(
                    color: colorTexto,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                // Características
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: caracteristicas.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              size: 12,
                              color: Color(0xFF25D366),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                caracteristicas[index],
                                style: TextStyle(
                                  color: colorTexto,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                // Botón
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final url = Uri.parse('https://wa.me/573225609121?text=Hola%20Ricardo%20quiero%20el%20${Uri.encodeComponent(titulo)}%20en%20VENTON%20PRO');
                      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('No se pudo abrir WhatsApp')),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorBoton,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      textoBoton,
                      style: TextStyle(
                        color: colorTextoBoton ?? Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
