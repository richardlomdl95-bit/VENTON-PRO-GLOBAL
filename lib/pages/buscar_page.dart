import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/venton_config.dart';
import '../core/venton_helpers.dart';
import 'experiencia_detalle_page.dart';
import 'producto_detalle_page.dart';

class BuscarPage extends StatefulWidget {
  const BuscarPage({super.key});

  @override
  State<BuscarPage> createState() => _BuscarPageState();
}

class _BuscarPageState extends State<BuscarPage> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Producto> get _productosFiltrados {
    if (_query.isEmpty) return [];
    final q = _query.toLowerCase();
    return [
      ...MockData.cafeProductos,
      ...MockData.quimicosPremium,
    ].where((p) =>
        p.nombre.toLowerCase().contains(q) ||
        p.categoria.toLowerCase().contains(q) ||
        p.descripcion.toLowerCase().contains(q)).toList();
  }

  List<Experiencia> get _experienciasFiltradas {
    if (_query.isEmpty) return [];
    final q = _query.toLowerCase();
    return MockData.turismoSantaRosa
        .where((e) =>
            e.titulo.toLowerCase().contains(q) ||
            e.ubicacion.toLowerCase().contains(q) ||
            e.descripcion.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final productos = _productosFiltrados;
    final experiencias = _experienciasFiltradas;
    final sinResultados =
        _query.isNotEmpty && productos.isEmpty && experiencias.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Buscar productos, turismo...',
            border: InputBorder.none,
            filled: false,
            prefixIcon: const Icon(Icons.search, color: AppTheme.azulMarino),
            suffixIcon: _query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _controller.clear();
                      setState(() => _query = '');
                    },
                  )
                : null,
          ),
          onChanged: (v) => setState(() => _query = v.trim()),
        ),
      ),
      body: _query.isEmpty
          ? _sugerencias()
          : sinResultados
              ? _vacio()
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  children: [
                    if (experiencias.isNotEmpty) ...[
                      _seccion('Turismo (${experiencias.length})'),
                      ...experiencias.map(_buildExperiencia),
                      const SizedBox(height: 16),
                    ],
                    if (productos.isNotEmpty) ...[
                      _seccion('Productos (${productos.length})'),
                      ...productos.map(_buildProducto),
                    ],
                  ],
                ),
    );
  }

  Widget _seccion(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 22,
            decoration: BoxDecoration(
              gradient: AppTheme.gradienteBronce,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            titulo,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppTheme.azulMarino,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProducto(Producto p) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: p.imagenUrl,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              width: 56,
              height: 56,
              color: Colors.grey[200],
            ),
            errorWidget: (_, __, ___) => Container(
              width: 56,
              height: 56,
              color: Colors.grey[200],
              child: const Icon(Icons.image_outlined),
            ),
          ),
        ),
        title: Text(
          p.nombre,
          style: const TextStyle(fontWeight: FontWeight.w700),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          VentonHelpers.formatearPrecio(p.precio),
          style: const TextStyle(
            color: AppTheme.bronceOscuro,
            fontWeight: FontWeight.w700,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppTheme.bronce),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductoDetallePage(producto: p),
          ),
        ),
      ),
    );
  }

  Widget _buildExperiencia(Experiencia e) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: e.imagenUrl,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              width: 56,
              height: 56,
              color: Colors.grey[200],
            ),
            errorWidget: (_, __, ___) => Container(
              width: 56,
              height: 56,
              color: Colors.grey[200],
              child: const Icon(Icons.terrain),
            ),
          ),
        ),
        title: Text(
          e.titulo,
          style: const TextStyle(fontWeight: FontWeight.w700),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          VentonHelpers.formatearPrecio(e.precio),
          style: const TextStyle(
            color: AppTheme.bronceOscuro,
            fontWeight: FontWeight.w700,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppTheme.bronce),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ExperienciaDetallePage(experiencia: e),
          ),
        ),
      ),
    );
  }

  Widget _sugerencias() {
    final tags = ['Café', 'Termales', 'Químicos', 'Automotriz', 'Hogar', 'Tour'];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Búsquedas populares',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppTheme.azulMarino,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: tags
                .map(
                  (t) => ActionChip(
                    label: Text(t),
                    onPressed: () {
                      _controller.text = t;
                      setState(() => _query = t);
                    },
                  ),
                )
                .toList(),
          ),
        ],
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
              Icons.search_off_rounded,
              size: 64,
              color: AppTheme.bronce.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Sin resultados para "$_query"',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppTheme.azulMarino,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Probá otra palabra o pedinos por WhatsApp',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
