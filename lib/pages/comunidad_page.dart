import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'crear_page.dart';

class ComunidadPage extends StatefulWidget {
  const ComunidadPage({super.key});

  @override
  State<ComunidadPage> createState() => _ComunidadPageState();
}

class _ComunidadPageState extends State<ComunidadPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Datos de videos
  final List<Map<String, String>> _videos = [
    {
      'nombre': 'Carlos · La Leyenda del Chorizo',
      'imagen': 'https://images.unsplash.com/photo-1544025162-d76694265947?w=600',
    },
    {
      'nombre': 'María · Hotel Tacurrumbi',
      'imagen': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=600',
    },
    {
      'nombre': 'Hernán · Termales Santa Rosa',
      'imagen': 'https://images.unsplash.com/photo-1583416750470-965b2707b355?w=600',
    },
    {
      'nombre': 'Marta · Tour del Café',
      'imagen': 'https://images.unsplash.com/photo-1442550528053-c431ecb55509?w=600',
    },
    {
      'nombre': 'Pedro · Café del Parque',
      'imagen': 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=600',
    },
  ];

  // Datos de fotos
  final List<String> _fotos = [
    'https://images.unsplash.com/photo-1583416750470-965b2707b355?w=400',
    'https://images.unsplash.com/photo-1432405972618-c60b0225b8f9?w=400',
    'https://images.unsplash.com/photo-1442550528053-c431ecb55509?w=400',
    'https://images.unsplash.com/photo-1544025162-d76694265947?w=400',
    'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400',
    'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400',
    'https://images.unsplash.com/photo-1518684079-3c830dcef090?w=400',
    'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=400',
    'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=400',
  ];

  // Datos de historias
  final List<Map<String, String>> _historias = [
    {
      'nombre': 'Hotel Tacurrumbi',
      'imagen': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=600',
      'tiempo': 'hace 2 horas',
    },
    {
      'nombre': 'La Leyenda del Chorizo',
      'imagen': 'https://images.unsplash.com/photo-1544025162-d76694265947?w=600',
      'tiempo': 'hace 4 horas',
    },
    {
      'nombre': 'Termales Santa Rosa',
      'imagen': 'https://images.unsplash.com/photo-1583416750470-965b2707b355?w=600',
      'tiempo': 'hace 6 horas',
    },
    {
      'nombre': 'Tour del Café',
      'imagen': 'https://images.unsplash.com/photo-1442550528053-c431ecb55509?w=600',
      'tiempo': 'hace 8 horas',
    },
    {
      'nombre': 'Café del Parque',
      'imagen': 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=600',
      'tiempo': 'hace 12 horas',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _contactWhatsApp(String negocio) async {
    final url = Uri.parse('https://wa.me/573225609121?text=Hola%20me%20interesó%20tu%20video%20en%20VENTON%20PRO%20de%20${Uri.encodeComponent(negocio)}');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir WhatsApp')),
        );
      }
    }
  }

  void _shareImage(String imageUrl) {
    Share.share(
      '📸 Mira esta foto de Santa Rosa de Cabal en VENTON PRO',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        title: const Text(
          'Comunidad VENTON',
          style: TextStyle(
            color: Color(0xFFD4A017),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFD4A017)),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFD4A017),
          labelColor: const Color(0xFFD4A017),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Videos'),
            Tab(text: 'Fotos'),
            Tab(text: 'Historias'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildVideosTab(),
          _buildFotosTab(),
          _buildHistoriasTab(),
        ],
      ),
    );
  }

  Widget _buildVideosTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 9 / 16,
        ),
        itemCount: _videos.length + 1, // +1 para el cuadro de publicar
        itemBuilder: (context, index) {
          if (index == 0) {
            // Primer cuadro - PUBLICA TU VIDEO
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CrearPage()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFFD4A017),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.videocam,
                      color: Colors.white,
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '📹 PUBLICA TU VIDEO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Plan Top',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final video = _videos[index - 1];
          return GestureDetector(
            onTap: () => _contactWhatsApp(video['nombre']!),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: video['imagen']!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: const Color(0xFF1A1A1A),
                        child: const Center(
                          child: CircularProgressIndicator(color: Color(0xFFD4A017)),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: const Color(0xFF1A1A1A),
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    right: 8,
                    child: Text(
                      video['nombre']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFotosTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1,
        ),
        itemCount: _fotos.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _showImageDialog(_fotos[index]),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: _fotos[index],
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: const Color(0xFF1A1A1A),
                    child: const Center(
                      child: CircularProgressIndicator(color: Color(0xFFD4A017)),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: const Color(0xFF1A1A1A),
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHistoriasTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _historias.length,
      itemBuilder: (context, index) {
        final historia = _historias[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Foto circular
              Container(
                width: 60,
                height: 60,
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFD4A017), width: 2),
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: historia['imagen']!,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: const Color(0xFF1A1A1A),
                      child: const Center(
                        child: CircularProgressIndicator(color: Color(0xFFD4A017)),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: const Color(0xFF1A1A1A),
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
              // Contenido
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        historia['nombre']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        historia['tiempo']!,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Miniatura grande de la historia
                      Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: historia['imagen']!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: const Color(0xFF1A1A1A),
                              child: const Center(
                                child: CircularProgressIndicator(color: Color(0xFFD4A017)),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: const Color(0xFF1A1A1A),
                              child: const Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 300,
                      height: 300,
                      color: const Color(0xFF1A1A1A),
                      child: const Center(
                        child: CircularProgressIndicator(color: Color(0xFFD4A017)),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 300,
                      height: 300,
                      color: const Color(0xFF1A1A1A),
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () => _shareImage(imageUrl),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
