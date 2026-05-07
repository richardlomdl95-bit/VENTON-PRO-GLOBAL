import 'package:shared_preferences/shared_preferences.dart';
import 'models/publicacion_model.dart';

/// Servicio que administra publicaciones de usuarios.
/// En OLA 1.5 guarda en almacenamiento local (shared_preferences).
/// En OLA 2 se migra a Firebase Firestore + Storage sin cambiar la API pública.
class PublicacionesService {
  PublicacionesService._();
  static final PublicacionesService instance = PublicacionesService._();

  static const _kPublicacionesKey = 'venton_publicaciones';
  static const _kUsuariosBloqueadosKey = 'venton_usuarios_bloqueados';
  static const _kUsuarioActualKey = 'venton_usuario_actual_id';
  static const _kPublicacionesOcultasKey = 'venton_publicaciones_ocultas';

  /// Umbral de reportes a partir del cual se oculta automáticamente.
  /// Cumple con política Google Play de UGC.
  static const int umbralReportesAutoOcultar = 3;

  Future<List<Publicacion>> obtenerTodas() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kPublicacionesKey) ?? '';
    return Publicacion.decodeList(raw);
  }

  /// Obtiene publicaciones visibles para el usuario actual,
  /// filtrando bloqueados, ocultas y reportadas masivamente.
  Future<List<Publicacion>> obtenerVisibles() async {
    final todas = await obtenerTodas();
    final bloqueados = await obtenerUsuariosBloqueados();
    final ocultas = await obtenerPublicacionesOcultas();

    return todas.where((p) {
      if (p.estado == EstadoPublicacion.bloqueada) return false;
      if (p.estado == EstadoPublicacion.ocultaPorUsuario) return false;
      if (p.reportes >= umbralReportesAutoOcultar) return false;
      if (bloqueados.contains(p.autorId)) return false;
      if (ocultas.contains(p.id)) return false;
      return true;
    }).toList()
      ..sort((a, b) => b.fechaCreacion.compareTo(a.fechaCreacion));
  }

  Future<void> guardar(Publicacion publicacion) async {
    final prefs = await SharedPreferences.getInstance();
    final lista = await obtenerTodas();
    lista.add(publicacion);
    await prefs.setString(
      _kPublicacionesKey,
      Publicacion.encodeList(lista),
    );
  }

  Future<void> _actualizarLista(List<Publicacion> lista) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kPublicacionesKey,
      Publicacion.encodeList(lista),
    );
  }

  /// Reportar una publicación. Si pasa el umbral, se oculta automáticamente.
  Future<void> reportar(String publicacionId, String usuarioReportador) async {
    final lista = await obtenerTodas();
    final idx = lista.indexWhere((p) => p.id == publicacionId);
    if (idx == -1) return;

    final pub = lista[idx];
    if (pub.usuariosBloqueadosPorReportar.contains(usuarioReportador)) {
      return;
    }
    final nuevaListaReportadores = [
      ...pub.usuariosBloqueadosPorReportar,
      usuarioReportador,
    ];
    final nuevoConteo = pub.reportes + 1;
    final nuevoEstado = nuevoConteo >= umbralReportesAutoOcultar
        ? EstadoPublicacion.bloqueada
        : EstadoPublicacion.reportada;

    lista[idx] = pub.copyWith(
      reportes: nuevoConteo,
      estado: nuevoEstado,
      usuariosBloqueadosPorReportar: nuevaListaReportadores,
    );
    await _actualizarLista(lista);
  }

  Future<void> ocultarParaUsuario(String publicacionId) async {
    final prefs = await SharedPreferences.getInstance();
    final ocultas = prefs.getStringList(_kPublicacionesOcultasKey) ?? [];
    if (!ocultas.contains(publicacionId)) {
      ocultas.add(publicacionId);
      await prefs.setStringList(_kPublicacionesOcultasKey, ocultas);
    }
  }

  Future<List<String>> obtenerPublicacionesOcultas() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_kPublicacionesOcultasKey) ?? [];
  }

  Future<void> bloquearUsuario(String autorId) async {
    final prefs = await SharedPreferences.getInstance();
    final bloqueados = prefs.getStringList(_kUsuariosBloqueadosKey) ?? [];
    if (!bloqueados.contains(autorId)) {
      bloqueados.add(autorId);
      await prefs.setStringList(_kUsuariosBloqueadosKey, bloqueados);
    }
  }

  Future<void> desbloquearUsuario(String autorId) async {
    final prefs = await SharedPreferences.getInstance();
    final bloqueados = prefs.getStringList(_kUsuariosBloqueadosKey) ?? [];
    bloqueados.remove(autorId);
    await prefs.setStringList(_kUsuariosBloqueadosKey, bloqueados);
  }

  Future<List<String>> obtenerUsuariosBloqueados() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_kUsuariosBloqueadosKey) ?? [];
  }

  /// Eliminar una publicación propia del usuario.
  Future<void> eliminarPropia(String publicacionId, String usuarioId) async {
    final lista = await obtenerTodas();
    lista.removeWhere(
      (p) => p.id == publicacionId && p.autorId == usuarioId,
    );
    await _actualizarLista(lista);
  }

  /// Obtiene o crea un ID único anónimo para el usuario actual.
  /// En OLA 2 será el UID de Firebase Auth.
  Future<String> obtenerUsuarioActualId() async {
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString(_kUsuarioActualKey);
    if (id == null || id.isEmpty) {
      id = 'user_${DateTime.now().millisecondsSinceEpoch}';
      await prefs.setString(_kUsuarioActualKey, id);
    }
    return id;
  }

  /// Eliminar todos los datos del usuario actual (cumplimiento Google Play).
  Future<void> eliminarTodosMisDatos() async {
    final prefs = await SharedPreferences.getInstance();
    final usuarioId = await obtenerUsuarioActualId();
    final lista = await obtenerTodas();
    lista.removeWhere((p) => p.autorId == usuarioId);
    await _actualizarLista(lista);
    await prefs.remove(_kUsuarioActualKey);
    await prefs.remove(_kUsuariosBloqueadosKey);
    await prefs.remove(_kPublicacionesOcultasKey);
  }
}
