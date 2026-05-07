import 'dart:convert';

/// Tipos de medio que un usuario puede subir.
enum TipoMedio { foto, video, soloTexto }

/// Tipo de contenido (categoría de la publicación).
enum CategoriaPublicacion { producto, servicio, negocio, turismo }

/// Estado de moderación de la publicación.
/// VENTON PRO permite publicación inmediata con sistema de reportes
/// (cumplimiento de políticas Google Play UGC).
enum EstadoPublicacion { activa, reportada, ocultaPorUsuario, bloqueada }

/// Una publicación creada por un usuario de la app.
class Publicacion {
  final String id;
  final String autorId;
  final String autorNombre;
  final CategoriaPublicacion categoria;
  final TipoMedio tipoMedio;
  final String titulo;
  final String descripcion;
  final String? rutaArchivoLocal;
  final DateTime fechaCreacion;
  final EstadoPublicacion estado;
  final int reportes;
  final List<String> usuariosBloqueadosPorReportar;

  const Publicacion({
    required this.id,
    required this.autorId,
    required this.autorNombre,
    required this.categoria,
    required this.tipoMedio,
    required this.titulo,
    required this.descripcion,
    this.rutaArchivoLocal,
    required this.fechaCreacion,
    this.estado = EstadoPublicacion.activa,
    this.reportes = 0,
    this.usuariosBloqueadosPorReportar = const [],
  });

  Publicacion copyWith({
    EstadoPublicacion? estado,
    int? reportes,
    List<String>? usuariosBloqueadosPorReportar,
  }) {
    return Publicacion(
      id: id,
      autorId: autorId,
      autorNombre: autorNombre,
      categoria: categoria,
      tipoMedio: tipoMedio,
      titulo: titulo,
      descripcion: descripcion,
      rutaArchivoLocal: rutaArchivoLocal,
      fechaCreacion: fechaCreacion,
      estado: estado ?? this.estado,
      reportes: reportes ?? this.reportes,
      usuariosBloqueadosPorReportar:
          usuariosBloqueadosPorReportar ?? this.usuariosBloqueadosPorReportar,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'autorId': autorId,
        'autorNombre': autorNombre,
        'categoria': categoria.name,
        'tipoMedio': tipoMedio.name,
        'titulo': titulo,
        'descripcion': descripcion,
        'rutaArchivoLocal': rutaArchivoLocal,
        'fechaCreacion': fechaCreacion.toIso8601String(),
        'estado': estado.name,
        'reportes': reportes,
        'usuariosBloqueadosPorReportar': usuariosBloqueadosPorReportar,
      };

  factory Publicacion.fromJson(Map<String, dynamic> j) => Publicacion(
        id: j['id'] as String,
        autorId: j['autorId'] as String,
        autorNombre: j['autorNombre'] as String,
        categoria: CategoriaPublicacion.values.firstWhere(
          (c) => c.name == j['categoria'],
          orElse: () => CategoriaPublicacion.producto,
        ),
        tipoMedio: TipoMedio.values.firstWhere(
          (t) => t.name == j['tipoMedio'],
          orElse: () => TipoMedio.soloTexto,
        ),
        titulo: j['titulo'] as String,
        descripcion: j['descripcion'] as String,
        rutaArchivoLocal: j['rutaArchivoLocal'] as String?,
        fechaCreacion: DateTime.parse(j['fechaCreacion'] as String),
        estado: EstadoPublicacion.values.firstWhere(
          (e) => e.name == j['estado'],
          orElse: () => EstadoPublicacion.activa,
        ),
        reportes: (j['reportes'] as int?) ?? 0,
        usuariosBloqueadosPorReportar:
            (j['usuariosBloqueadosPorReportar'] as List?)
                    ?.cast<String>()
                    .toList() ??
                const [],
      );

  static String encodeList(List<Publicacion> lista) =>
      jsonEncode(lista.map((p) => p.toJson()).toList());

  static List<Publicacion> decodeList(String data) {
    if (data.isEmpty) return [];
    final raw = jsonDecode(data) as List;
    return raw
        .cast<Map<String, dynamic>>()
        .map(Publicacion.fromJson)
        .toList();
  }
}
