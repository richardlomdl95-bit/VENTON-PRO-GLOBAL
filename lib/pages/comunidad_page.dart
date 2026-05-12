import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ComunidadPage extends StatelessWidget {
  const ComunidadPage({super.key});

  void _contactWhatsApp(String negocio) async {
    final url = Uri.parse('https://wa.me/573225609121?text=Hola%20me%20interesó%20tu%20video%20en%20VENTON%20PRO%20de%20${Uri.encodeComponent(negocio)}');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('No se pudo abrir WhatsApp');
    }
  }

  void _shareImage() {
    Share.share('📸 Mira esto en VENTON PRO 👇 Santa Rosa de Cabal');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
          bottom: Container(
            color: const Color(0xFF1A1A1A),
            child: TabBar(
              indicatorColor: const Color(0xFFD4A017),
              labelColor: const Color(0xFFD4A017),
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(
                  icon: Icon(Icons.play_circle),
                  text: "Videos",
                ),
                Tab(
                  icon: Icon(Icons.photo),
                  text: "Fotos",
                ),
                Tab(
                  icon: Icon(Icons.auto_stories),
                  text: "Historias",
                ),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            _VideosTab(),
            _FotosTab(),
            _HistoriasTab(),
          ],
        ),
      ),
    );
  }
}

class _VideosTab extends StatelessWidget {
  const _VideosTab();

  void _contactWhatsApp(String negocio) async {
    final url = Uri.parse('https://wa.me/573225609121?text=Hola%20me%20interesó%20tu%20video%20en%20VENTON%20PRO%20de%20${Uri.encodeComponent(negocio)}');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('No se pudo abrir WhatsApp');
    }
  }

  @override
  Widget build(BuildContext context) {
    final videos = [
      {
        'nombre': 'Carlos · La Leyenda',
        'imagen': 'https://images.unsplash.com/photo-1544025162-d76694265947?w=600',
      },
      {
        'nombre': 'María · Tacurrumbi',
        'imagen': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=600',
      },
      {
        'nombre': 'Hernán · Termales',
        'imagen': 'https://images.unsplash.com/photo-1583416750470-965b2707b355?w=600',
      },
      {
        'nombre': 'Marta · Tour Café',
        'imagen': 'https://images.unsplash.com/photo-1442550528053-c431ecb55509?w=600',
      },
      {
        'nombre': 'Pedro · Café Parque',
        'imagen': 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=600',
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 9 / 16,
        ),
        itemCount: 6, // 5 videos + 1 publicar
        itemBuilder: (context, index) {
          if (index == 0) {
            // Item PUBLICAR
            return GestureDetector(
              onTap: () {
                // Navegar a la pestaña Crear (índice 2)
                DefaultTabController.of(context)?.animateTo(2);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFD4A017)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.videocam,
                        size: 60,
                        color: Colors.white,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '📹 PUBLICA TU VIDEO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Plan Top \$100k',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final video = videos[index - 1];
          return GestureDetector(
            onTap: () => _contactWhatsApp(video['nombre']!),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
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
                          child: CircularProgressIndicator(
                            color: Color(0xFFD4A017),
                          ),
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
                  const Center(
                    child: Icon(
                      Icons.play_circle_fill,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Text(
                      video['nombre']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
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
}

class _FotosTab extends StatelessWidget {
  const _FotosTab();

  void _shareImage() {
    Share.share('📸 Mira esto en VENTON PRO 👇 Santa Rosa de Cabal');
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
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
                        child: CircularProgressIndicator(
                          color: Color(0xFFD4A017),
                        ),
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
              child: IconButton(
                onPressed: _shareImage,
                icon: Container(
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

  @override
  Widget build(BuildContext context) {
    final fotos = [
      'https://images.unsplash.com/photo-1583416750470-965b2707b355?w=300',
      'https://images.unsplash.com/photo-1432405972618-c60b0225b8f9?w=300',
      'https://images.unsplash.com/photo-1442550528053-c431ecb55509?w=300',
      'https://images.unsplash.com/photo-1544025162-d76694265947?w=300',
      'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=300',
      'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=300',
      'https://images.unsplash.com/photo-1518684079-3c830dcef090?w=300',
      'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=300',
      'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=300',
    ];

    return Padding(
      padding: const EdgeInsets.all(8),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: 1,
        ),
        itemCount: fotos.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _showImageDialog(context, fotos[index]),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: fotos[index],
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: const Color(0xFF1A1A1A),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFD4A017),
                      ),
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
}

class _HistoriasTab extends StatelessWidget {
  const _HistoriasTab();

  void _shareStory(String negocio) {
    Share.share('📖 $negocio en VENTON PRO 👇 Santa Rosa de Cabal');
  }

  @override
  Widget build(BuildContext context) {
    final historias = [
      {
        'nombre': 'Hotel Tacurrumbi',
        'tiempo': 'hace 2h',
        'imagen': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=600',
      },
      {
        'nombre': 'La Leyenda del Chorizo',
        'tiempo': 'hace 4h',
        'imagen': 'https://images.unsplash.com/photo-1544025162-d76694265947?w=600',
      },
      {
        'nombre': 'Termales Santa Rosa',
        'tiempo': 'hace 6h',
        'imagen': 'https://images.unsplash.com/photo-1583416750470-965b2707b355?w=600',
      },
      {
        'nombre': 'Tour del Café',
        'tiempo': 'hace 8h',
        'imagen': 'https://images.unsplash.com/photo-1442550528053-c431ecb55509?w=600',
      },
      {
        'nombre': 'Café del Parque',
        'tiempo': 'hace 12h',
        'imagen': 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=600',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: historias.length,
      itemBuilder: (context, index) {
        final historia = historias[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con perfil
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: const Color(0xFFD4A017),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: historia['imagen']!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: const Color(0xFF1A1A1A),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFD4A017),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        historia['nombre']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        historia['tiempo']!,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Imagen grande
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: historia['imagen']!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 200,
                    color: const Color(0xFF1A1A1A),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFD4A017),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 200,
                    color: const Color(0xFF1A1A1A),
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                      size: 40,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Botones de interacción
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.favorite_border),
                    color: Colors.grey,
                    iconSize: 20,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.chat_bubble_outline),
                    color: Colors.grey,
                    iconSize: 20,
                  ),
                  IconButton(
                    onPressed: () => _shareStory(historia['nombre']!),
                    icon: const Icon(Icons.share),
                    color: Colors.grey,
                    iconSize: 20,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
