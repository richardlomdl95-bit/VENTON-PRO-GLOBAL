import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Reproductor de YouTube inline dentro de la app (sin abrir YouTube externo).
/// El controller vive en el State y no se recrea en cada build.
/// [AutomaticKeepAliveClientMixin] evita reinicio al cambiar de pestaña.
class WidgetVideo extends StatefulWidget {
  final String url;
  final String titulo;
  const WidgetVideo({super.key, required this.url, this.titulo = 'Ver video'});

  @override
  State<WidgetVideo> createState() => _WidgetVideoState();
}

class _WidgetVideoState extends State<WidgetVideo>
    with AutomaticKeepAliveClientMixin {
  YoutubePlayerController? _controller;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _crearController();
  }

  void _crearController() {
    final id = YoutubePlayer.convertUrlToId(widget.url);
    if (id == null || id.isEmpty) return;
    _controller = YoutubePlayerController(
      initialVideoId: id,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: true,
        controlsVisibleAtStart: true,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant WidgetVideo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url == widget.url) return;
    final nuevoId = YoutubePlayer.convertUrlToId(widget.url);
    if (nuevoId == null || nuevoId.isEmpty) {
      _controller?.dispose();
      _controller = null;
      return;
    }
    if (_controller != null) {
      _controller!.load(nuevoId);
    } else {
      _crearController();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.url.isEmpty) return const SizedBox.shrink();

    final id = YoutubePlayer.convertUrlToId(widget.url);
    if (id == null || id.isEmpty || _controller == null) {
      return Container(
        height: 180,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Solo enlaces de YouTube soportados para reproducción inline.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: YoutubePlayer(
            controller: _controller!,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.blue,
          ),
        ),
        if (widget.titulo.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            widget.titulo,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ],
    );
  }
}
