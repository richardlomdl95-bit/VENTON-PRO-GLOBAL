import 'package:shared_preferences/shared_preferences.dart';
import 'venton_config.dart';

/// Servicio para guardar productos favoritos del usuario.
class FavoritosService {
  FavoritosService._();
  static final FavoritosService instance = FavoritosService._();

  Future<List<String>> obtenerFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(VentonConfig.favoritosKey) ?? [];
  }

  Future<bool> esFavorito(String idProducto) async {
    final lista = await obtenerFavoritos();
    return lista.contains(idProducto);
  }

  Future<void> alternar(String idProducto) async {
    final prefs = await SharedPreferences.getInstance();
    final lista = await obtenerFavoritos();
    if (lista.contains(idProducto)) {
      lista.remove(idProducto);
    } else {
      lista.add(idProducto);
    }
    await prefs.setStringList(VentonConfig.favoritosKey, lista);
  }

  Future<void> limpiar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(VentonConfig.favoritosKey);
  }
}
