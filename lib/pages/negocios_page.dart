import 'package:flutter/material.dart';
import '../core/venton_config.dart';
import '../core/venton_helpers.dart';

// =============================================================================

class PublicidadPage extends StatelessWidget {
  const PublicidadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publicidad VENTON'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE65100), Color(0xFFFFA726)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Anúnciate con VENTON PRO',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text(
                    'Tu negocio visible en Santa Rosa, Colombia y el mundo. Activación en segundos.',
                    style: TextStyle(color: Colors.white, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Planes de publicidad',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _PlanPublicidad(
            nombre: 'BÁSICO',
            precio: 30000,
            color: const Color(0xFF1976D2),
            beneficios: const [
              'Perfil del negocio en VENTON PRO',
              'Hasta 3 fotos',
              'Botón WhatsApp directo',
              'Aparición en categoría',
              'Duración: 30 días',
            ],
          ),
          _PlanPublicidad(
            nombre: 'PREMIUM',
            precio: 80000,
            color: const Color(0xFFE65100),
            destacado: true,
            beneficios: const [
              'Todo lo del plan Básico',
              'Hasta 10 fotos + 1 video',
              'Badge "PATROCINADO" dorado',
              'Top en búsquedas y categoría',
              'Notificaciones push a turistas',
              'Duración: 30 días',
            ],
          ),
          _PlanPublicidad(
            nombre: 'TOP',
            precio: 150000,
            color: VentonConfig.brandGold,
            beneficios: const [
              'Todo lo del plan Premium',
              'Fotos y videos ilimitados',
              'Aparece en pantalla principal',
              'Banner en Inicio',
              'Reporte mensual de visitas',
              'Duración: 30 días',
            ],
          ),
          const SizedBox(height: 16),
          Card(
            color: Colors.amber[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.celebration, color: Colors.orange),
                      SizedBox(width: 8),
                      Text('Promoción especial',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                      'Los primeros 50 negocios de Santa Rosa de Cabal: '
                      'PUBLICIDAD GRATIS por 3 meses. Comprueba antes de pagar.'),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () {
                      VentonHelpers.logEvent(
                          'gratis_50', {'origen': 'publicidad'});
                      VentonHelpers.openWhatsApp(
                          'Hola, quiero entrar a los 50 negocios gratis de VENTON PRO');
                    },
                    icon: const Icon(Icons.card_giftcard),
                    label: const Text('Quiero ser uno de los 50 gratis'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanPublicidad extends StatelessWidget {
  final String nombre;
  final int precio;
  final Color color;
  final List<String> beneficios;
  final bool destacado;

  const _PlanPublicidad({
    required this.nombre,
    required this.precio,
    required this.color,
    required this.beneficios,
    this.destacado = false,
  });

  @override
  Widget build(BuildContext context) {
    final precioStr = '\$${(precio / 1000).toStringAsFixed(0)}.000';
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: destacado
            ? BorderSide(color: color, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(nombre,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
                if (destacado) ...[
                  const SizedBox(width: 8),
                  const Text('Más popular',
                      style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(precioStr,
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold)),
                const Text(' COP / mes',
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 12),
            ...beneficios.map((b) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle, size: 18, color: color),
                      const SizedBox(width: 8),
                      Expanded(child: Text(b)),
                    ],
                  ),
                )),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  VentonHelpers.logEvent('publicidad_interes',
                      {'plan': nombre, 'precio': precio});
                  VentonHelpers.openWhatsApp(
                      'Hola, quiero el plan $nombre de publicidad VENTON PRO ($precioStr/mes)');
                },
                style: FilledButton.styleFrom(backgroundColor: color),
                child: const Text('Contratar este plan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
