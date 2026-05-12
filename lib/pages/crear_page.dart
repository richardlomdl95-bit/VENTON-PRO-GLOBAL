import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

class CrearPage extends StatefulWidget {
  const CrearPage({super.key});

  @override
  State<CrearPage> createState() => _CrearPageState();
}

class _CrearPageState extends State<CrearPage> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedMedia;
  bool _isVideo = false;
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _selectedMedia = File(image.path);
        _isVideo = false;
      });
      _showPreviewDialog();
    }
  }

  Future<void> _recordVideo() async {
    final XFile? video = await _picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(seconds: 60),
    );
    if (video != null) {
      setState(() {
        _selectedMedia = File(video.path);
        _isVideo = true;
      });
      _showPreviewDialog();
    }
  }

  Future<void> _pickFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedMedia = File(image.path);
        _isVideo = false;
      });
      _showPreviewDialog();
    }
  }

  void _shareSantaRosa() {
    Share.share(
      '🌴 Conoce Santa Rosa de Cabal en VENTON PRO 👇\nDescarga la app: vitrina digital de Risaralda',
    );
  }

  void _showPreviewDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_isVideo ? 'Vista previa del video' : 'Vista previa de la foto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: _selectedMedia != null
                  ? _isVideo
                      ? const Icon(Icons.videocam, size: 50)
                      : Image.file(_selectedMedia!, fit: BoxFit.cover)
                  : const Icon(Icons.image, size: 50),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Añade un comentario...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _publishToWhatsApp();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
            ),
            child: Text(_isVideo ? 'Publicar video 24h' : 'Publicar historia 24h'),
          ),
        ],
      ),
    );
  }

  void _publishToWhatsApp() async {
    final url = Uri.parse('https://wa.me/573225609121?text=Hola%20publiqué%20mi%20${_isVideo ? 'video' : 'historia'}%20en%20VENTON%20PRO');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir WhatsApp')),
        );
      }
    }
  }

  void _contactWhatsApp(String plan) async {
    final url = Uri.parse('https://wa.me/573225609121?text=Hola%20Ricardo%20quiero%20el%20Plan%20$plan%20en%20VENTON%20PRO');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir WhatsApp')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        title: const Text(
          'Crear',
          style: TextStyle(
            color: Color(0xFFD4A017),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFD4A017)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // PARTE SUPERIOR - PUBLICA GRATIS
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
                        label: '📸 Tomar Foto',
                        color: Colors.blue.shade100,
                        iconColor: Colors.blue.shade700,
                        onTap: _takePhoto,
                      ),
                      _buildActionCard(
                        icon: Icons.videocam,
                        label: '🎥 Grabar Video',
                        color: Colors.purple.shade100,
                        iconColor: Colors.purple.shade700,
                        onTap: _recordVideo,
                      ),
                      _buildActionCard(
                        icon: Icons.photo_library,
                        label: '🖼️ Subir de Galería',
                        color: Colors.green.shade100,
                        iconColor: Colors.green.shade700,
                        onTap: _pickFromGallery,
                      ),
                      _buildActionCard(
                        icon: Icons.share,
                        label: '📲 Compartir Santa Rosa',
                        color: const Color(0xFFD4A017).withOpacity(0.2),
                        iconColor: const Color(0xFFD4A017),
                        onTap: _shareSantaRosa,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // PARTE INFERIOR - ANUNCIA TU NEGOCIO
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Separador
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4A017),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    margin: const EdgeInsets.only(bottom: 16),
                  ),
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
                    'Llega a turistas de Colombia, Venezuela, España y USA',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // PLAN VISIBLE
                  _buildPlanCard(
                    title: 'BÁSICO',
                    price: '\$20.000 COP/mes',
                    features: [
                      '✓ Aparece en listados',
                      '✓ Foto del negocio',
                      '✓ Botón WhatsApp',
                    ],
                    buttonColor: const Color(0xFF25D366),
                    buttonText: 'Empezar',
                    backgroundColor: Colors.white,
                    borderColor: const Color(0xFFD4A017),
                    onTap: () => _contactWhatsApp('Visible'),
                  ),

                  const SizedBox(height: 12),

                  // PLAN DESTACADO
                  _buildPlanCard(
                    title: 'DESTACADO',
                    price: '\$50.000 COP/mes',
                    features: [
                      '✓ Todo del Visible',
                      '✓ Aparece en Historias',
                      '✓ Foto más grande',
                    ],
                    buttonColor: const Color(0xFF25D366),
                    buttonText: 'Empezar',
                    backgroundColor: Colors.white,
                    borderColor: const Color(0xFFD4A017),
                    borderWidth: 3,
                    badge: 'POPULAR',
                    badgeColor: Colors.red,
                    onTap: () => _contactWhatsApp('Destacado'),
                  ),

                  const SizedBox(height: 12),

                  // PLAN TOP
                  _buildPlanCard(
                    title: 'TOP',
                    price: '\$100.000 COP/mes',
                    features: [
                      '✓ Todo del Destacado',
                      '✓ Primera pantalla',
                      '✓ Video promocional',
                    ],
                    buttonColor: Colors.black,
                    buttonText: 'Empezar',
                    backgroundColor: const Color(0xFFD4A017),
                    textColor: Colors.black,
                    badge: 'PREMIUM',
                    badgeColor: const Color(0xFFD4A017),
                    onTap: () => _contactWhatsApp('Top'),
                  ),

                  const SizedBox(height: 20),

                  // Banner PLAN SEMILLA
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF25D366),
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
                          'Primer mes GRATIS para los primeros 20 negocios',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Botón WhatsApp final
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _contactWhatsApp('Semilla'),
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
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
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
    required Color color,
    required Color iconColor,
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
            Icon(icon, color: iconColor, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: iconColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
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
    required List<String> features,
    required Color buttonColor,
    required String buttonText,
    required Color backgroundColor,
    Color textColor = Colors.black,
    Color borderColor = const Color(0xFFD4A017),
    double borderWidth = 1,
    String? badge,
    Color? badgeColor,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: features.map((feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        feature,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 11,
                        ),
                      ),
                    )).toList(),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
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
          if (badge != null)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeColor ?? Colors.red,
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
            ),
        ],
      ),
    );
  }
}
