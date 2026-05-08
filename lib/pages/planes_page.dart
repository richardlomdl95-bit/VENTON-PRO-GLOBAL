import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/venton_helpers.dart';
import '../core/widgets/venton_logo.dart';

class PlanesPage extends StatelessWidget {
  const PlanesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: false,
            backgroundColor: AppTheme.azulMarino,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.azulMarino,
                      AppTheme.azulMarinoOscuro,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const VentonProLogo(size: 100, conTexto: true),
                        const SizedBox(height: 8),
                        Text(
                          'Haz que tu negocio crezca',
                          style: TextStyle(
                            color: AppTheme.bronceClaro,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Planes publicitarios para todos los presupuestos',
                          style: TextStyle(
                            color: AppTheme.bronceClaro.withOpacity(0.8),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 24),
              _buildPlan(
                context,
                titulo: 'GRATIS',
                precio: '0',
                color: Colors.green,
                beneficios: [
                  'Ver contenido',
                  'Compartir',
                  '1 publicación básica',
                ],
              ),
              const SizedBox(height: 16),
              _buildPlan(
                context,
                titulo: 'BÁSICO',
                precio: '\$20.000',
                color: Colors.blue,
                beneficios: [
                  '3 publicaciones',
                  'WhatsApp visible',
                  'Negocio destacado',
                ],
              ),
              const SizedBox(height: 16),
              _buildPlan(
                context,
                titulo: 'PRO',
                precio: '\$50.000',
                color: Colors.purple,
                beneficios: [
                  '10 publicaciones',
                  'Destacado en ciudad',
                  'Video promocional',
                ],
              ),
              const SizedBox(height: 16),
              _buildPlan(
                context,
                titulo: 'PREMIUM',
                precio: '\$120.000',
                color: Colors.amber,
                beneficios: [
                  'Banner principal',
                  'Prioridad arriba',
                  'Más visibilidad',
                ],
              ),
              const SizedBox(height: 32),
              _buildBotonWhatsApp(context),
              const SizedBox(height: 32),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildPlan(
    BuildContext context, {
    required String titulo,
    required String precio,
    required Color color,
    required List<String> beneficios,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                titulo,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  precio,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Beneficios:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          ...beneficios.map((beneficio) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: color,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    beneficio,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildBotonWhatsApp(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton.icon(
        onPressed: () {
          VentonHelpers.abrirWhatsApp(
            mensaje: 'Hola, quiero activar un plan publicitario en VENTON PRO GLOBAL.',
          );
        },
        icon: const Icon(Icons.message_rounded),
        label: 'Activar por WhatsApp',
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF25D366),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
