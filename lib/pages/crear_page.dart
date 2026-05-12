import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class CrearPage extends StatefulWidget {
  const CrearPage({super.key});

  @override
  State<CrearPage> createState() => _CrearPageState();
}

class _CrearPageState extends State<CrearPage> {
  final ImagePicker _picker = ImagePicker();

  void _tomarFoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final url = Uri.parse('https://wa.me/573225609121?text=Hola%20Ricardo%20tomé%20una%20foto%20para%20publicar%20en%20VENTON%20PRO');
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _grabarVideo() async {
    final XFile? video = await _picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(seconds: 60),
    );
    if (video != null) {
      final url = Uri.parse('https://wa.me/573225609121?text=Hola%20Ricardo%20grabé%20un%20video%20para%20publicar%20en%20VENTON%20PRO');
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _subirDeGaleria() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final url = Uri.parse('https://wa.me/573225609121?text=Hola%20Ricardo%20subí%20una%20foto%20desde%20galería%20para%20publicar%20en%20VENTON%20PRO');
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _compartirVenton() {
    Share.share(
      '🌴 Conoce Santa Rosa de Cabal en VENTON PRO 👇\nDescarga la app: vitrina digital de Risaralda',
    );
  }

  void _contactarPlan(String plan) async {
    final url = Uri.parse('https://wa.me/573225609121?text=Hola%20Ricardo%20quiero%20el%20Plan%20${Uri.encodeComponent(plan)}%20en%20VENTON%20PRO');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD4A017),
        title: const Text(
          'Crear',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // SECCIÓN ARRIBA - PUBLICA GRATIS
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFD4A017).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD4A017)),
              ),
              child: Column(
                children: [
                  const Text(
                    '📱 Comparte tu momento',
                    style: TextStyle(
                      color: Color(0xFFD4A017),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Gratis · Aparece 24 horas',
                    style: TextStyle(
                      color: Color(0xFFD4A017),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.2,
                    children: [
                      _buildActionCard(
                        icon: Icons.camera_alt,
                        label: 'Tomar Foto',
                        sublabel: 'Cámara directa',
                        color: const Color(0xFF3B82F6),
                        onTap: _tomarFoto,
                      ),
                      _buildActionCard(
                        icon: Icons.videocam,
                        label: 'Grabar Video',
                        sublabel: 'Hasta 60 segundos',
                        color: const Color(0xFF8B5CF6),
                        onTap: _grabarVideo,
                      ),
                      _buildActionCard(
                        icon: Icons.photo_library,
                        label: 'De Galería',
                        sublabel: 'Subir foto/video',
                        color: const Color(0xFF10B981),
                        onTap: _subirDeGaleria,
                      ),
                      _buildActionCard(
                        icon: Icons.share,
                        label: 'Compartir VENTON',
                        sublabel: 'A tus redes',
                        color: const Color(0xFFD4A017),
                        onTap: _compartirVenton,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // SEPARADOR
            Container(
              width: double.infinity,
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFD4A017),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 20),

            // SECCIÓN ABAJO - ANUNCIA TU NEGOCIO
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const Text(
                    '🏪 ¿TIENES UN NEGOCIO?',
                    style: TextStyle(
                      color: Color(0xFFD4A017),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Aparece permanente en VENTON PRO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Llega a turistas de Colombia 🇨🇴 Venezuela 🇻🇪 España 🇪🇸 USA 🇺🇸',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // PLAN VISIBLE
                  _buildPlanCard(
                    title: 'PLAN VISIBLE',
                    price: '\$20.000 COP/mes',
                    backgroundColor: const Color(0xFF1A1A1A),
                    borderColor: const Color(0xFFD4A017),
                    features: const [
                      'Aparece en listados',
                      'Foto del negocio',
                      'Botón WhatsApp directo',
                    ],
                    buttonText: 'Quiero este plan',
                    onTap: () => _contactarPlan('Visible'),
                  ),

                  const SizedBox(height: 12),

                  // PLAN DESTACADO
                  _buildPlanCard(
                    title: 'PLAN DESTACADO',
                    price: '\$50.000 COP/mes',
                    backgroundColor: const Color(0xFF1A1A1A),
                    borderColor: const Color(0xFFD4A017),
                    borderWidth: 3,
                    badge: 'POPULAR',
                    badgeColor: const Color(0xFFDC143C),
                    features: const [
                      'Todo del Visible',
                      'Aparece en Historias',
                      'Foto más grande',
                      'Prioridad en búsqueda',
                    ],
                    buttonText: 'Quiero este plan',
                    onTap: () => _contactarPlan('Destacado'),
                  ),

                  const SizedBox(height: 12),

                  // PLAN TOP
                  _buildPlanCard(
                    title: 'PLAN TOP',
                    price: '\$100.000 COP/mes',
                    backgroundColor: const Color(0xFFD4A017),
                    textColor: Colors.black,
                    badge: 'PREMIUM',
                    badgeColor: Colors.black,
                    features: const [
                      'Todo del Destacado',
                      'Primera pantalla',
                      'Video promocional',
                      'Estadísticas mensuales',
                      'Soporte prioritario',
                    ],
                    buttonText: 'Quiero este plan',
                    buttonColor: Colors.black,
                    onTap: () => _contactarPlan('Top'),
                  ),

                  const SizedBox(height: 20),

                  // BANNER PLAN SEMILLA
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(12),
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
                        const SizedBox(height: 4),
                        const Text(
                          'Primer mes GRATIS para los primeros 20 negocios de Santa Rosa',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _contactarPlan('Semilla'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF10B981),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Hablar con Ricardo',
                              style: TextStyle(
                                color: Color(0xFF10B981),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required String sublabel,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 50),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              sublabel,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    required Color backgroundColor,
    required Color borderColor,
    required List<String> features,
    required String buttonText,
    required VoidCallback onTap,
    Color textColor = Colors.white,
    Color buttonColor = const Color(0xFF25D366),
    double borderWidth = 1,
    String? badge,
    Color? badgeColor,
  }) {
    return Container(
      width: double.infinity,
      height: 160,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Row(
                    children: [
                      const Text('✓ ', style: TextStyle(color: Color(0xFFD4A017))),
                      Expanded(
                        child: Text(
                          feature,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Column(
              children: [
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      badge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(height: 80),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(
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
