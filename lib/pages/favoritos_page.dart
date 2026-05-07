import 'package:flutter/material.dart';
import '../core/favoritos_service.dart';
import '../core/theme.dart';
import '../core/venton_config.dart';
import 'widgets/_grilla_productos.dart';

class FavoritosPage extends StatefulWidget {
  const FavoritosPage({super.key});

  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  List<Producto> _favoritos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final ids = await FavoritosService.instance.obtenerFavoritos();
    final todos = [
      ...MockData.cafeProductos,
      ...MockData.quimicosPremium,
    ];
    final favs = todos.where((p) => ids.contains(p.id)).toList();
    if (!mounted) return;
    setState(() {
      _favoritos = favs;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis favoritos')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _favoritos.isEmpty
              ? _vacio()
              : RefreshIndicator(
                  onRefresh: _cargar,
                  child: GrillaProductos(productos: _favoritos),
                ),
    );
  }

  Widget _vacio() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border_rounded,
              size: 72,
              color: AppTheme.bronce.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Aún no tenés favoritos',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: AppTheme.azulMarino,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tocá el corazón en cualquier producto para guardarlo acá.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
