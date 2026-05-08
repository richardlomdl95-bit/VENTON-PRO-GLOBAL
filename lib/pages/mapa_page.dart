import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/venton_helpers.dart';

class NegocioMapa {
  final String id;
  final String nombre;
  final String descripcion;
  final String direccion;
  final double latitud;
  final double longitud;
  final String telefono;
  final String categoria;
  final String imagenUrl;

  const NegocioMapa({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.direccion,
    required this.latitud,
    required this.longitud,
    required this.telefono,
    required this.categoria,
    required this.imagenUrl,
  });
}

class MapaPage extends StatefulWidget {
  const MapaPage({super.key});

  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final List<NegocioMapa> _negocios = [
    NegocioMapa(
      id: '1',
      nombre: 'VENTON PRO Santa Rosa',
      descripcion: 'Tienda principal de productos VENTON',
      direccion: 'Calle Principal #123, Santa Rosa, Colombia',
      latitud: 4.8713,
      longitud: -75.8875,
      telefono: '+57 322 560 9121',
      categoria: 'Tienda',
      imagenUrl: 'https://via.placeholder.com/150/1A4D2E/FFFFFF?text=VENTON',
    ),
    NegocioMapa(
      id: '2',
      nombre: 'Café El Paraíso',
      descripcion: 'Café especial y productos locales',
      direccion: 'Avenida Central #456, Santa Rosa, Colombia',
      latitud: 4.8723,
      longitud: -75.8885,
      telefono: '+57 311 234 5678',
      categoria: 'Café',
      imagenUrl: 'https://via.placeholder.com/150/8B4513/FFFFFF?text=CAFÉ',
    ),
    NegocioMapa(
      id: '3',
      nombre: 'Químicos Industriales',
      descripcion: 'Productos químicos para industria',
      direccion: 'Carrera 10 #789, Santa Rosa, Colombia',
      latitud: 4.8703,
      longitud: -75.8865,
      telefono: '+57 300 987 6543',
      categoria: 'Químicos',
      imagenUrl: 'https://via.placeholder.com/150/4169E1/FFFFFF?text=QUÍMICOS',
    ),
    NegocioMapa(
      id: '4',
      nombre: 'Turismo Aventura',
      descripcion: 'Tours y experiencias turísticas',
      direccion: 'Plaza Principal #101, Santa Rosa, Colombia',
      latitud: 4.8733,
      longitud: -75.8895,
      telefono: '+57 312 345 6789',
      categoria: 'Turismo',
      imagenUrl: 'https://via.placeholder.com/150/28A745/FFFFFF?text=TURISMO',
    ),
  ];

  List<NegocioMapa> _negociosFiltrados = [];
    NegocioMapa(
      id: '1',
      nombre: 'VENTON PRO Santa Rosa',
      descripcion: 'Tienda principal de productos VENTON',
      direccion: 'Calle Principal #123, Santa Rosa, Colombia',
      latitud: 4.8713,
      longitud: -75.8875,
      telefono: '+57 322 560 9121',
      categoria: 'Tienda',
      imagenUrl: 'https://via.placeholder.com/150/1A4D2E/FFFFFF?text=VENTON',
    ),
    NegocioMapa(
      id: '2',
      nombre: 'Café El Paraíso',
      descripcion: 'Café especial y productos locales',
      direccion: 'Avenida Central #456, Santa Rosa, Colombia',
      latitud: 4.8723,
      longitud: -75.8885,
      telefono: '+57 311 234 5678',
      categoria: 'Café',
      imagenUrl: 'https://via.placeholder.com/150/8B4513/FFFFFF?text=CAFÉ',
    ),
    NegocioMapa(
      id: '3',
      nombre: 'Químicos Industriales',
      descripcion: 'Productos químicos para industria',
      direccion: 'Carrera 10 #789, Santa Rosa, Colombia',
      latitud: 4.8703,
      longitud: -75.8865,
      telefono: '+57 300 987 6543',
      categoria: 'Químicos',
      imagenUrl: 'https://via.placeholder.com/150/4169E1/FFFFFF?text=QUÍMICOS',
    ),
    NegocioMapa(
      id: '4',
      nombre: 'Turismo Aventura',
      descripcion: 'Tours y experiencias turísticas',
      direccion: 'Plaza Principal #101, Santa Rosa, Colombia',
      latitud: 4.8733,
      longitud: -75.8895,
      telefono: '+57 312 345 6789',
      categoria: 'Turismo',
      imagenUrl: 'https://via.placeholder.com/150/28A745/FFFFFF?text=TURISMO',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mapa de Negocios',
          style: TextStyle(
            color: AppTheme.bronce,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.bronce),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (categoria) {
              setState(() {
                if (categoria != null) {
                  _negociosFiltrados = _negocios.where((n) => n.categoria == categoria).toList();
                } else {
                  _negociosFiltrados = _negocios;
                }
              });
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: null,
                  child: Text('Todos'),
                ),
                const PopupMenuItem<String>(
                  value: 'Hoteles',
                  child: Text('Hoteles'),
                ),
                const PopupMenuItem<String>(
                  value: 'Restaurantes',
                  child: Text('Restaurantes'),
                ),
                const PopupMenuItem<String>(
                  value: 'Químicos',
                  child: Text('Químicos'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Mapa placeholder
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.azulMarino.withOpacity(0.1),
                  AppTheme.bronce.withOpacity(0.1),
                ],
              ),
              border: Border.all(color: AppTheme.bronce.withOpacity(0.3)),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map_rounded,
                    size: 64,
                    color: AppTheme.bronce.withOpacity(0.6),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Mapa interactivo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.bronce.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_negocios.length} negocios cerca',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Lista de negocios
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _negociosFiltrados.length,
              itemBuilder: (context, index) {
                final negocio = _negociosFiltrados[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.bronce.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(negocio.imagenUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          negocio.nombre,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              negocio.descripcion,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              negocio.direccion,
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.bronce.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            negocio.categoria,
                            style: TextStyle(
                              color: AppTheme.bronce,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      // Botones de acción
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _mostrarDetalle(negocio),
                                icon: const Icon(Icons.info_outline, size: 16),
                                label: const Text('Ver detalle'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.azulMarino,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  textStyle: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => VentonHelpers.abrirWhatsApp(
                                  numeroPersonalizado: negocio.telefono,
                                  mensaje: 'Hola, estoy interesado en tu negocio: ${negocio.nombre}',
                                ),
                                icon: const Icon(Icons.message, size: 16),
                                label: const Text('WhatsApp'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF25D366),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  textStyle: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _abrirGoogleMaps(negocio),
                                icon: const Icon(Icons.directions, size: 16),
                                label: const Text('Cómo llegar'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  textStyle: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDetalle(NegocioMapa negocio) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(negocio.nombre),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              negocio.descripcion,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Dirección: ${negocio.direccion}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              'Teléfono: ${negocio.telefono}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              'Categoría: ${negocio.categoria}',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _abrirGoogleMaps(NegocioMapa negocio) {
    final url = 'https://www.google.com/maps/search/?api=1&query=${negocio.latitud},${negocio.longitud}';
    VentonHelpers.abrirUrl(url);
  }
}
