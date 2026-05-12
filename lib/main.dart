// VENTON PRO - main.dart
// Red social estilo Facebook/Instagram con publicidad de negocios.
// 5 tabs: Feed / Buscar / Subir / Notificaciones / Perfil
// Funciones: stories, fotos, videos, likes, comentarios, compartir, chat.
// Flutter 3.24 estricto. Sin withValues, sin initialValue en dropdowns.
//
// Dependencias en pubspec.yaml:
//   cupertino_icons: ^1.0.6
//   url_launcher: ^6.3.0
//   cached_network_image: ^3.4.1
//   shared_preferences: ^2.3.2
//   image_picker: ^1.1.2
//   video_player: ^2.9.2
//   share_plus: ^10.0.2
//
// Permisos Android (android/app/src/main/AndroidManifest.xml dentro de <manifest>):
//   <uses-permission android:name="android.permission.INTERNET"/>
//   <uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
//   <uses-permission android:name="android.permission.READ_MEDIA_VIDEO"/>
//   <uses-permission android:name="android.permission.CAMERA"/>

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart';

// ============== CONSTANTES ==============
const kFondo = Color(0xFF000814);
const kFondoBarra = Color(0xFF0A0E1A);
const kFondoTarjeta = Color(0xFF0A1628);
const kDorado = Color(0xFFD4A437);
const kWhatsappRicardo = '573225609121';
const kMiUsuario = 'tu_usuario';
const kMiNombre = 'Tú';
const kMiAvatar = 'https://i.pravatar.cc/150?img=12';

void main() => runApp(const VentonProApp());

// ============== APP RAIZ ==============
class VentonProApp extends StatelessWidget {
  const VentonProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VENTON PRO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: kFondo,
        primaryColor: kDorado,
        useMaterial3: false,
        appBarTheme: const AppBarTheme(
          backgroundColor: kFondoBarra,
          elevation: 0,
          iconTheme: IconThemeData(color: kDorado),
          titleTextStyle: TextStyle(
            color: kDorado,
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const HomeShell(),
    );
  }
}

// ============== MODELOS ==============
enum MediaTipo { foto, video }

class Post {
  final String id;
  final String autorNombre;
  final String autorUsuario;
  final String autorAvatar;
  final String plan;
  final String? whatsapp;
  final MediaTipo tipoMedia;
  final String urlMedia;
  final bool esLocal;
  final String descripcion;
  int likes;
  List<Comentario> comentarios;
  final String tiempo;

  Post({
    required this.id,
    required this.autorNombre,
    required this.autorUsuario,
    required this.autorAvatar,
    this.plan = '',
    this.whatsapp,
    required this.tipoMedia,
    required this.urlMedia,
    this.esLocal = false,
    required this.descripcion,
    this.likes = 0,
    List<Comentario>? comentarios,
    this.tiempo = 'Hace 2h',
  }) : comentarios = comentarios ?? [];
}

class Comentario {
  final String autor;
  final String avatar;
  final String texto;
  final String tiempo;
  Comentario({
    required this.autor,
    required this.avatar,
    required this.texto,
    this.tiempo = 'Ahora',
  });
}

class Historia {
  final String autor;
  final String avatar;
  final String imagen;
  final bool esMia;
  const Historia({
    required this.autor,
    required this.avatar,
    required this.imagen,
    this.esMia = false,
  });
}

class Notificacion {
  final String avatar;
  final String texto;
  final String tiempo;
  final IconData icono;
  const Notificacion({
    required this.avatar,
    required this.texto,
    required this.tiempo,
    required this.icono,
  });
}

class Chat {
  final String nombre;
  final String avatar;
  final String ultimoMensaje;
  final String tiempo;
  final bool noLeido;
  const Chat({
    required this.nombre,
    required this.avatar,
    required this.ultimoMensaje,
    required this.tiempo,
    this.noLeido = false,
  });
}

class Mensaje {
  final String texto;
  final bool esMio;
  final String tiempo;
  const Mensaje({
    required this.texto,
    required this.esMio,
    required this.tiempo,
  });
}

// ============== ESTADO GLOBAL ==============
class AppState extends ChangeNotifier {
  AppState._();
  static final AppState I = AppState._();

  final Set<String> _miLike = {};

  final List<Post> posts = [
    Post(
      id: '1',
      autorNombre: 'Termales Santa Rosa',
      autorUsuario: 'termales_sr',
      autorAvatar:
          'https://images.unsplash.com/photo-1545079968-1feb95494244?w=200',
      plan: 'top',
      whatsapp: '573001234567',
      tipoMedia: MediaTipo.foto,
      urlMedia:
          'https://images.unsplash.com/photo-1545079968-1feb95494244?w=800',
      descripcion:
          '🔥 Aguas termales naturales con cascada de 75 metros. Ven y vive una experiencia inolvidable en Santa Rosa de Cabal.',
      likes: 248,
      tiempo: 'Hace 1h',
      comentarios: [
        Comentario(
            autor: 'maria_g',
            avatar: 'https://i.pravatar.cc/150?img=1',
            texto: '¡Qué hermoso lugar! 😍',
            tiempo: 'Hace 45 min'),
        Comentario(
            autor: 'juan_p',
            avatar: 'https://i.pravatar.cc/150?img=3',
            texto: '¿Cuánto cuesta la entrada?',
            tiempo: 'Hace 30 min'),
      ],
    ),
    Post(
      id: '2',
      autorNombre: 'Hotel Tacurrumbi',
      autorUsuario: 'tacurrumbi',
      autorAvatar:
          'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=200',
      plan: 'destacado',
      whatsapp: '573009876543',
      tipoMedia: MediaTipo.foto,
      urlMedia:
          'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
      descripcion:
          'Reserva tu cabaña con vista a la montaña. Piscina climatizada, desayuno típico incluido.',
      likes: 132,
      tiempo: 'Hace 3h',
      comentarios: [
        Comentario(
            autor: 'andrea_v',
            avatar: 'https://i.pravatar.cc/150?img=5',
            texto: 'Quiero ir este fin de semana',
            tiempo: 'Hace 1h'),
      ],
    ),
    Post(
      id: '3',
      autorNombre: 'Restaurante La Leyenda',
      autorUsuario: 'la_leyenda',
      autorAvatar:
          'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=200',
      plan: 'destacado',
      whatsapp: '573005554433',
      tipoMedia: MediaTipo.video,
      urlMedia:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      descripcion:
          'Bandeja paisa, trucha al ajillo y comida típica. Abierto todos los días.',
      likes: 89,
      tiempo: 'Hace 5h',
    ),
    Post(
      id: '4',
      autorNombre: 'Finca El Mirador',
      autorUsuario: 'finca_mirador',
      autorAvatar:
          'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=200',
      plan: 'visible',
      whatsapp: '573002221100',
      tipoMedia: MediaTipo.foto,
      urlMedia:
          'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=800',
      descripcion:
          'Cabañas en la montaña con tour de café incluido. Vista al amanecer del Eje Cafetero.',
      likes: 56,
      tiempo: 'Hace 8h',
    ),
  ];

  final List<Historia> historias = const [
    Historia(autor: 'Tu historia', avatar: kMiAvatar, imagen: '', esMia: true),
    Historia(
      autor: 'Termales',
      avatar:
          'https://images.unsplash.com/photo-1545079968-1feb95494244?w=200',
      imagen:
          'https://images.unsplash.com/photo-1545079968-1feb95494244?w=600',
    ),
    Historia(
      autor: 'Tacurrumbi',
      avatar:
          'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=200',
      imagen:
          'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=600',
    ),
    Historia(
      autor: 'La Leyenda',
      avatar:
          'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=200',
      imagen:
          'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=600',
    ),
    Historia(
      autor: 'Mirador',
      avatar:
          'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=200',
      imagen:
          'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=600',
    ),
  ];

  final List<Notificacion> notificaciones = const [
    Notificacion(
      avatar: 'https://i.pravatar.cc/150?img=1',
      texto: 'maria_g le dio like a tu publicación',
      tiempo: 'Hace 5 min',
      icono: Icons.favorite,
    ),
    Notificacion(
      avatar: 'https://i.pravatar.cc/150?img=3',
      texto: 'juan_p comentó: "¿Cuánto cuesta?"',
      tiempo: 'Hace 30 min',
      icono: Icons.chat_bubble,
    ),
    Notificacion(
      avatar: 'https://i.pravatar.cc/150?img=5',
      texto: 'andrea_v empezó a seguirte',
      tiempo: 'Hace 2h',
      icono: Icons.person_add,
    ),
    Notificacion(
      avatar: 'https://i.pravatar.cc/150?img=8',
      texto: 'Termales Santa Rosa publicó una nueva foto',
      tiempo: 'Hace 4h',
      icono: Icons.image,
    ),
  ];

  final List<Chat> chats = const [
    Chat(
      nombre: 'Termales Santa Rosa',
      avatar:
          'https://images.unsplash.com/photo-1545079968-1feb95494244?w=200',
      ultimoMensaje: 'La entrada cuesta \$35.000 socio',
      tiempo: '10:42',
      noLeido: true,
    ),
    Chat(
      nombre: 'Hotel Tacurrumbi',
      avatar:
          'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=200',
      ultimoMensaje: 'Tenemos disponibilidad este sábado',
      tiempo: 'Ayer',
    ),
    Chat(
      nombre: 'María García',
      avatar: 'https://i.pravatar.cc/150?img=1',
      ultimoMensaje: '¿Cuándo nos vemos?',
      tiempo: 'Ayer',
    ),
  ];

  bool tieneLike(String postId) => _miLike.contains(postId);

  void toggleLike(String postId) {
    final p = posts.firstWhere((p) => p.id == postId);
    if (_miLike.contains(postId)) {
      _miLike.remove(postId);
      p.likes--;
    } else {
      _miLike.add(postId);
      p.likes++;
    }
    notifyListeners();
  }

  void agregarComentario(String postId, String texto) {
    final p = posts.firstWhere((p) => p.id == postId);
    p.comentarios.add(Comentario(
      autor: kMiUsuario,
      avatar: kMiAvatar,
      texto: texto,
    ));
    notifyListeners();
  }

  void agregarPost({
    required MediaTipo tipo,
    required String rutaLocal,
    required String descripcion,
  }) {
    posts.insert(
      0,
      Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        autorNombre: kMiNombre,
        autorUsuario: kMiUsuario,
        autorAvatar: kMiAvatar,
        tipoMedia: tipo,
        urlMedia: rutaLocal,
        esLocal: true,
        descripcion: descripcion,
        tiempo: 'Ahora',
      ),
    );
    notifyListeners();
  }
}

// ============== HELPER WHATSAPP ==============
Future<void> abrirWhatsApp(String numero, String mensaje) async {
  final uri = Uri.parse(
    'https://wa.me/$numero?text=${Uri.encodeComponent(mensaje)}',
  );
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

// ============== SHELL ==============
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const FeedPage(),
      const BuscarPage(),
      const SubirPage(),
      const NotificacionesPage(),
      const PerfilPage(),
    ];

    return Scaffold(
      backgroundColor: kFondo,
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        backgroundColor: kFondoBarra,
        selectedItemColor: kDorado,
        unselectedItemColor: Colors.white60,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 28), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search, size: 28), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined, size: 32), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border, size: 28), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 28), label: ''),
        ],
      ),
    );
  }
}

// ============== FEED ==============
class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kFondo,
      appBar: AppBar(
        title: const Text('VENTON PRO'),
        actions: [
          IconButton(
            icon: const Icon(Icons.send_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChatsPage()),
            ),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: AppState.I,
        builder: (_, __) => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                color: kDorado,
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: const Text(
                  '⭐ PLAN TOP 100.000 PESOS AL MES',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 110,
                color: kFondoBarra,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: AppState.I.historias.length,
                  itemBuilder: (_, i) =>
                      _HistoriaItem(historia: AppState.I.historias[i]),
                ),
              ),
            ),
            SliverList.builder(
              itemCount: AppState.I.posts.length,
              itemBuilder: (_, i) => _PostCard(post: AppState.I.posts[i]),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}

class _HistoriaItem extends StatelessWidget {
  final Historia historia;
  const _HistoriaItem({required this.historia});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (historia.esMia) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Toca el botón + abajo para subir tu historia'),
              backgroundColor: kDorado,
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => _StoryViewer(historia: historia)),
          );
        }
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: kDorado, width: 2.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: historia.avatar,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            Container(color: Colors.black26),
                        errorWidget: (_, __, ___) =>
                            Container(color: Colors.black26),
                      ),
                    ),
                  ),
                ),
                if (historia.esMia)
                  Positioned(
                    bottom: 0,
                    right: 6,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: kDorado,
                        shape: BoxShape.circle,
                        border: Border.all(color: kFondoBarra, width: 2),
                      ),
                      child: const Icon(Icons.add,
                          color: Colors.black, size: 14),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              historia.autor,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryViewer extends StatelessWidget {
  final Historia historia;
  const _StoryViewer({required this.historia});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: CachedNetworkImage(
                  imageUrl: historia.imagen,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                right: 12,
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: historia.avatar,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(historia.autor,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============== POST CARD ==============
class _PostCard extends StatelessWidget {
  final Post post;
  const _PostCard({required this.post});

  Color get _colorPlan {
    switch (post.plan) {
      case 'top':
        return kDorado;
      case 'destacado':
        return const Color(0xFFE07B00);
      case 'visible':
        return Colors.white24;
      default:
        return Colors.transparent;
    }
  }

  String get _etiquetaPlan {
    switch (post.plan) {
      case 'top':
        return 'TOP';
      case 'destacado':
        return 'DESTACADO';
      case 'visible':
        return 'PATROCINADO';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final yaLike = AppState.I.tieneLike(post.id);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      color: kFondoTarjeta,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: kFondo,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: post.autorAvatar,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) =>
                          const Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              post.autorNombre,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          if (post.plan.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: _colorPlan,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                _etiquetaPlan,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(post.tiempo,
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 11)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.white70),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          if (post.tipoMedia == MediaTipo.foto)
            _MediaFoto(post: post)
          else
            _MediaVideo(post: post),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    yaLike ? Icons.favorite : Icons.favorite_border,
                    color: yaLike ? Colors.red : Colors.white,
                    size: 28,
                  ),
                  onPressed: () => AppState.I.toggleLike(post.id),
                ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline,
                      color: Colors.white, size: 26),
                  onPressed: () => _abrirComentarios(context, post),
                ),
                IconButton(
                  icon: const Icon(Icons.send_outlined,
                      color: Colors.white, size: 26),
                  onPressed: () => Share.share(
                    '${post.autorNombre} en VENTON PRO:\n${post.descripcion}',
                  ),
                ),
                const Spacer(),
                if (post.whatsapp != null)
                  TextButton.icon(
                    onPressed: () => abrirWhatsApp(
                      post.whatsapp!,
                      'Hola, vi su negocio en VENTON PRO y quiero más información sobre ${post.autorNombre}.',
                    ),
                    icon: const Icon(Icons.chat, color: Colors.black, size: 16),
                    label: const Text(
                      'WhatsApp',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: kDorado,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${post.likes} me gusta',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    children: [
                      TextSpan(
                        text: '${post.autorUsuario}  ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: post.descripcion),
                    ],
                  ),
                ),
                if (post.comentarios.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () => _abrirComentarios(context, post),
                    child: Text(
                      'Ver los ${post.comentarios.length} comentarios',
                      style: const TextStyle(
                          color: Colors.white54, fontSize: 12),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _abrirComentarios(BuildContext context, Post post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kFondoTarjeta,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _ComentariosSheet(post: post),
    );
  }
}

class _MediaFoto extends StatelessWidget {
  final Post post;
  const _MediaFoto({required this.post});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: post.esLocal
          ? Image.file(File(post.urlMedia), fit: BoxFit.cover)
          : CachedNetworkImage(
              imageUrl: post.urlMedia,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(color: Colors.black26),
              errorWidget: (_, __, ___) => Container(color: Colors.black26),
            ),
    );
  }
}

class _MediaVideo extends StatefulWidget {
  final Post post;
  const _MediaVideo({required this.post});
  @override
  State<_MediaVideo> createState() => _MediaVideoState();
}

class _MediaVideoState extends State<_MediaVideo> {
  VideoPlayerController? _ctrl;
  bool _listo = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      _ctrl = widget.post.esLocal
          ? VideoPlayerController.file(File(widget.post.urlMedia))
          : VideoPlayerController.networkUrl(Uri.parse(widget.post.urlMedia));
      await _ctrl!.initialize();
      _ctrl!.setLooping(true);
      if (mounted) setState(() => _listo = true);
    } catch (_) {
      if (mounted) setState(() => _listo = false);
    }
  }

  @override
  void dispose() {
    _ctrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_listo || _ctrl == null) {
      return AspectRatio(
        aspectRatio: 1,
        child: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(color: kDorado),
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          _ctrl!.value.isPlaying ? _ctrl!.pause() : _ctrl!.play();
        });
      },
      child: AspectRatio(
        aspectRatio: _ctrl!.value.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(_ctrl!),
            if (!_ctrl!.value.isPlaying)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(16),
                child: const Icon(Icons.play_arrow,
                    color: Colors.white, size: 48),
              ),
          ],
        ),
      ),
    );
  }
}

// ============== COMENTARIOS ==============
class _ComentariosSheet extends StatefulWidget {
  final Post post;
  const _ComentariosSheet({required this.post});
  @override
  State<_ComentariosSheet> createState() => _ComentariosSheetState();
}

class _ComentariosSheetState extends State<_ComentariosSheet> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollCtrl) => Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text('Comentarios',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            const Divider(color: Colors.white12),
            Expanded(
              child: AnimatedBuilder(
                animation: AppState.I,
                builder: (_, __) => ListView.builder(
                  controller: scrollCtrl,
                  itemCount: widget.post.comentarios.length,
                  itemBuilder: (_, i) {
                    final c = widget.post.comentarios[i];
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 18,
                        backgroundColor: kFondo,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: c.avatar,
                            width: 36,
                            height: 36,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13),
                          children: [
                            TextSpan(
                                text: '${c.autor}  ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(text: c.texto),
                          ],
                        ),
                      ),
                      subtitle: Text(c.tiempo,
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 11)),
                    );
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.white12)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Escribe un comentario...',
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: kFondo,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: kDorado),
                    onPressed: () {
                      final t = _ctrl.text.trim();
                      if (t.isEmpty) return;
                      AppState.I.agregarComentario(widget.post.id, t);
                      _ctrl.clear();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============== BUSCAR ==============
class BuscarPage extends StatefulWidget {
  const BuscarPage({super.key});
  @override
  State<BuscarPage> createState() => _BuscarPageState();
}

class _BuscarPageState extends State<BuscarPage> {
  String _filtro = '';

  @override
  Widget build(BuildContext context) {
    final filtrados = _filtro.isEmpty
        ? AppState.I.posts
        : AppState.I.posts
            .where((p) =>
                p.autorNombre.toLowerCase().contains(_filtro.toLowerCase()) ||
                p.descripcion.toLowerCase().contains(_filtro.toLowerCase()))
            .toList();
    return Scaffold(
      backgroundColor: kFondo,
      appBar: AppBar(
        title: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Buscar negocios, lugares...',
            hintStyle: const TextStyle(color: Colors.white54),
            filled: true,
            fillColor: kFondo,
            prefixIcon: const Icon(Icons.search, color: Colors.white54),
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (v) => setState(() => _filtro = v),
        ),
      ),
      body: AnimatedBuilder(
        animation: AppState.I,
        builder: (_, __) => GridView.builder(
          padding: const EdgeInsets.all(2),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemCount: filtrados.length,
          itemBuilder: (_, i) {
            final p = filtrados[i];
            return Stack(
              children: [
                Positioned.fill(
                  child: p.tipoMedia == MediaTipo.foto
                      ? (p.esLocal
                          ? Image.file(File(p.urlMedia), fit: BoxFit.cover)
                          : CachedNetworkImage(
                              imageUrl: p.urlMedia, fit: BoxFit.cover))
                      : Container(
                          color: Colors.black,
                          child: const Center(
                            child: Icon(Icons.play_circle,
                                color: Colors.white, size: 40),
                          ),
                        ),
                ),
                if (p.tipoMedia == MediaTipo.video)
                  const Positioned(
                    top: 4,
                    right: 4,
                    child:
                        Icon(Icons.videocam, color: Colors.white, size: 18),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ============== SUBIR ==============
class SubirPage extends StatefulWidget {
  const SubirPage({super.key});
  @override
  State<SubirPage> createState() => _SubirPageState();
}

class _SubirPageState extends State<SubirPage> {
  final _picker = ImagePicker();
  final _descCtrl = TextEditingController();
  XFile? _archivo;
  MediaTipo? _tipo;

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _tomarFoto(ImageSource fuente) async {
    final x = await _picker.pickImage(source: fuente, imageQuality: 85);
    if (x != null) {
      setState(() {
        _archivo = x;
        _tipo = MediaTipo.foto;
      });
    }
  }

  Future<void> _tomarVideo(ImageSource fuente) async {
    final x = await _picker.pickVideo(source: fuente);
    if (x != null) {
      setState(() {
        _archivo = x;
        _tipo = MediaTipo.video;
      });
    }
  }

  void _publicar() {
    if (_archivo == null || _tipo == null) return;
    AppState.I.agregarPost(
      tipo: _tipo!,
      rutaLocal: _archivo!.path,
      descripcion: _descCtrl.text.trim().isEmpty
          ? 'Nueva publicación'
          : _descCtrl.text.trim(),
    );
    setState(() {
      _archivo = null;
      _tipo = null;
      _descCtrl.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Publicación creada ✓'),
        backgroundColor: kDorado,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kFondo,
      appBar: AppBar(
        title: const Text('Nueva publicación'),
        actions: [
          if (_archivo != null)
            TextButton(
              onPressed: _publicar,
              child: const Text(
                'Publicar',
                style: TextStyle(
                    color: kDorado,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_archivo != null) ...[
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _tipo == MediaTipo.foto
                      ? Image.file(File(_archivo!.path), fit: BoxFit.cover)
                      : Container(
                          color: Colors.black,
                          child: const Center(
                            child: Icon(Icons.videocam,
                                color: kDorado, size: 60),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descCtrl,
                style: const TextStyle(color: Colors.white),
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Escribe una descripción...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: kFondoTarjeta,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => setState(() {
                  _archivo = null;
                  _tipo = null;
                  _descCtrl.clear();
                }),
                child: const Text('Cancelar',
                    style: TextStyle(color: Colors.white70)),
              ),
            ] else ...[
              const SizedBox(height: 20),
              const Icon(Icons.add_photo_alternate, color: kDorado, size: 80),
              const SizedBox(height: 16),
              const Text(
                'Sube una foto o video',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _BotonSubir(
                icono: Icons.camera_alt,
                texto: 'Tomar foto',
                onTap: () => _tomarFoto(ImageSource.camera),
              ),
              _BotonSubir(
                icono: Icons.photo_library,
                texto: 'Elegir foto de galería',
                onTap: () => _tomarFoto(ImageSource.gallery),
              ),
              _BotonSubir(
                icono: Icons.videocam,
                texto: 'Grabar video',
                onTap: () => _tomarVideo(ImageSource.camera),
              ),
              _BotonSubir(
                icono: Icons.video_library,
                texto: 'Elegir video de galería',
                onTap: () => _tomarVideo(ImageSource.gallery),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BotonSubir extends StatelessWidget {
  final IconData icono;
  final String texto;
  final VoidCallback onTap;
  const _BotonSubir({
    required this.icono,
    required this.texto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icono, color: Colors.black),
        label: Text(texto,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: kDorado,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

// ============== NOTIFICACIONES ==============
class NotificacionesPage extends StatelessWidget {
  const NotificacionesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kFondo,
      appBar: AppBar(title: const Text('Notificaciones')),
      body: ListView.separated(
        itemCount: AppState.I.notificaciones.length,
        separatorBuilder: (_, __) =>
            const Divider(color: Colors.white12, height: 1),
        itemBuilder: (_, i) {
          final n = AppState.I.notificaciones[i];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: kFondoTarjeta,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: n.avatar,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(n.texto,
                style: const TextStyle(color: Colors.white, fontSize: 14)),
            subtitle: Text(n.tiempo,
                style: const TextStyle(color: Colors.white54, fontSize: 12)),
            trailing: Icon(n.icono, color: kDorado, size: 20),
          );
        },
      ),
    );
  }
}

// ============== PERFIL ==============
class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kFondo,
      appBar: AppBar(
        title: const Text(kMiUsuario),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: AppState.I,
        builder: (_, __) {
          final misPosts = AppState.I.posts
              .where((p) => p.autorUsuario == kMiUsuario)
              .toList();
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: kFondoTarjeta,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: kMiAvatar,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _Stat(
                                numero: '${misPosts.length}',
                                etiqueta: 'Posts'),
                            const _Stat(numero: '128', etiqueta: 'Seguidores'),
                            const _Stat(numero: '94', etiqueta: 'Siguiendo'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(kMiNombre,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                        SizedBox(height: 4),
                        Text(
                          'Vendedor VENTON PRO 🇨🇴\nSanta Rosa de Cabal',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: kDorado),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: const Text('Editar perfil',
                              style: TextStyle(color: kDorado)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => abrirWhatsApp(
                            kWhatsappRicardo,
                            'Hola Ricardo, soy vendedor VENTON PRO.',
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: kDorado),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: const Text('WhatsApp',
                              style: TextStyle(color: kDorado)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(color: Colors.white12, height: 1),
                if (misPosts.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Icon(Icons.camera_alt_outlined,
                            color: Colors.white24, size: 60),
                        SizedBox(height: 12),
                        Text('Aún no tienes publicaciones',
                            style: TextStyle(color: Colors.white54)),
                      ],
                    ),
                  )
                else
                  GridView.builder(
                    padding: const EdgeInsets.all(2),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    itemCount: misPosts.length,
                    itemBuilder: (_, i) {
                      final p = misPosts[i];
                      return p.tipoMedia == MediaTipo.foto
                          ? (p.esLocal
                              ? Image.file(File(p.urlMedia), fit: BoxFit.cover)
                              : CachedNetworkImage(
                                  imageUrl: p.urlMedia, fit: BoxFit.cover))
                          : Container(
                              color: Colors.black,
                              child: const Icon(Icons.play_circle,
                                  color: Colors.white, size: 36),
                            );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String numero;
  final String etiqueta;
  const _Stat({required this.numero, required this.etiqueta});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(numero,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        Text(etiqueta,
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}

// ============== CHATS ==============
class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kFondo,
      appBar: AppBar(title: const Text('Mensajes')),
      body: ListView.separated(
        itemCount: AppState.I.chats.length,
        separatorBuilder: (_, __) =>
            const Divider(color: Colors.white12, height: 1),
        itemBuilder: (_, i) {
          final c = AppState.I.chats[i];
          return ListTile(
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: kFondoTarjeta,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: c.avatar,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(c.nombre,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text(c.ultimoMensaje,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: c.noLeido ? Colors.white : Colors.white54,
                  fontWeight: c.noLeido ? FontWeight.bold : FontWeight.normal,
                )),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(c.tiempo,
                    style: TextStyle(
                        color: c.noLeido ? kDorado : Colors.white54,
                        fontSize: 11)),
                if (c.noLeido) ...[
                  const SizedBox(height: 4),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: kDorado,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ChatPage(chat: c)),
            ),
          );
        },
      ),
    );
  }
}

// ============== CHAT INDIVIDUAL ==============
class ChatPage extends StatefulWidget {
  final Chat chat;
  const ChatPage({super.key, required this.chat});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _ctrl = TextEditingController();
  late List<Mensaje> _mensajes;

  @override
  void initState() {
    super.initState();
    _mensajes = [
      const Mensaje(texto: 'Hola, buenas tardes', esMio: false, tiempo: '10:30'),
      const Mensaje(
          texto: '¿En qué le puedo ayudar?', esMio: false, tiempo: '10:31'),
      Mensaje(
          texto: widget.chat.ultimoMensaje,
          esMio: false,
          tiempo: widget.chat.tiempo),
    ];
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _enviar() {
    final t = _ctrl.text.trim();
    if (t.isEmpty) return;
    setState(() {
      _mensajes.add(Mensaje(texto: t, esMio: true, tiempo: 'Ahora'));
      _ctrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kFondo,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: kFondoTarjeta,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: widget.chat.avatar,
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(widget.chat.nombre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      const TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _mensajes.length,
              itemBuilder: (_, i) {
                final m = _mensajes[i];
                return Align(
                  alignment:
                      m.esMio ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    decoration: BoxDecoration(
                      color: m.esMio ? kDorado : kFondoTarjeta,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      m.texto,
                      style: TextStyle(
                          color: m.esMio ? Colors.black : Colors.white,
                          fontSize: 14),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: kFondoBarra,
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Mensaje...',
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: kFondo,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: kDorado),
                    onPressed: _enviar,
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
