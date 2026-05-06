import 'package:flutter/material.dart';

/// Configuración global de VENTON PRO.
/// Constantes, modelos de datos y datos mock para OLA 1 (sin Firebase).
class VentonConfig {
  VentonConfig._();

  // Identidad
  static const String appName = 'VENTON PRO';
  static const String appVersion = '2.1.0';
  static const String slogan = 'Vendé más. Crecé más.';

  // Contacto
  static const String whatsappNumber = '573225609121';
  static const String mensajeBienvenida =
      'Hola VENTON PRO, quiero más información.';

  // Mercados
  static const List<String> mercados = ['Colombia', 'USA', 'Venezuela'];

  // Ruleta
  static const int ruletaJugadasParaPremio = 500;
  static const String ruletaKey = 'ruleta_jugadas_total';

  // URLs legales (placeholder OLA 1, real en OLA 3)
  static const String urlPolitica = 'https://ventonpro.com/privacidad';
  static const String urlTerminos = 'https://ventonpro.com/terminos';
  static const String urlEliminacionCuenta =
      'https://ventonpro.com/eliminar-cuenta';
}

// ============================================================
// MODELOS DE DATOS
// ============================================================

@immutable
class Producto {
  final String id;
  final String nombre;
  final String descripcion;
  final double precio;
  final String moneda;
  final String imagenUrl;
  final String categoria;

  const Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imagenUrl,
    required this.categoria,
    this.moneda = 'COP',
  });
}

@immutable
class Negocio {
  final String id;
  final String nombre;
  final String descripcion;
  final String ciudad;
  final String imagenUrl;
  final String categoria;

  const Negocio({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.ciudad,
    required this.imagenUrl,
    required this.categoria,
  });
}

@immutable
class Vendedor {
  final String id;
  final String nombre;
  final String ciudad;
  final String especialidad;
  final String imagenUrl;
  final double calificacion;
  final int ventasMes;

  const Vendedor({
    required this.id,
    required this.nombre,
    required this.ciudad,
    required this.especialidad,
    required this.imagenUrl,
    required this.calificacion,
    required this.ventasMes,
  });
}

@immutable
class Experiencia {
  final String id;
  final String titulo;
  final String descripcion;
  final String ubicacion;
  final double precio;
  final String imagenUrl;

  const Experiencia({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.ubicacion,
    required this.precio,
    required this.imagenUrl,
  });
}

// ============================================================
// DATOS MOCK (reemplazables por Firebase en OLA 2)
// ============================================================

class MockData {
  MockData._();

  static const List<Experiencia> turismoSantaRosa = [
    Experiencia(
      id: 'tur_001',
      titulo: 'Termales Santa Rosa de Cabal',
      descripcion:
          'Visita guiada a las aguas termales más famosas de Colombia. Incluye transporte y refrigerio.',
      ubicacion: 'Santa Rosa de Cabal, Risaralda',
      precio: 180000,
      imagenUrl: 'https://images.unsplash.com/photo-1551244072-5d12893278ab',
    ),
    Experiencia(
      id: 'tur_002',
      titulo: 'Tour del Café Premium',
      descripcion:
          'Recorrido por finca cafetera tradicional. Cosecha, tueste y cata incluidos.',
      ubicacion: 'Eje Cafetero, Risaralda',
      precio: 120000,
      imagenUrl: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085',
    ),
    Experiencia(
      id: 'tur_003',
      titulo: 'Cascadas de San Ramón',
      descripcion: 'Caminata ecológica con guía nativo a las cascadas naturales.',
      ubicacion: 'Santa Rosa de Cabal',
      precio: 95000,
      imagenUrl: 'https://images.unsplash.com/photo-1432405972618-c60b0225b8f9',
    ),
  ];

  static const List<Producto> quimicosPremium = [
    Producto(
      id: 'qui_001',
      nombre: 'Desengrasante Industrial Pro',
      descripcion:
          'Fórmula concentrada para uso pesado. Galón de 4 litros. Biodegradable.',
      precio: 95000,
      imagenUrl: 'https://images.unsplash.com/photo-1583947215259-38e31be8751f',
      categoria: 'Industrial',
    ),
    Producto(
      id: 'qui_002',
      nombre: 'Cera Automotriz Premium',
      descripcion:
          'Protección y brillo de larga duración. Aplicación profesional.',
      precio: 65000,
      imagenUrl: 'https://images.unsplash.com/photo-1607860108855-64acf2078ed9',
      categoria: 'Automotriz',
    ),
    Producto(
      id: 'qui_003',
      nombre: 'Limpiador Multiusos Concentrado',
      descripcion: 'Rinde 20 litros por galón. Aroma fresco. Ph neutro.',
      precio: 48000,
      imagenUrl: 'https://images.unsplash.com/photo-1585421514738-01798e348b17',
      categoria: 'Hogar',
    ),
  ];

  static const List<Producto> cafeProductos = [
    Producto(
      id: 'caf_001',
      nombre: 'Café de Origen Santa Rosa 500g',
      descripcion:
          'Tueste medio. Notas a chocolate y caramelo. Cosecha del Eje Cafetero.',
      precio: 38000,
      imagenUrl: 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e',
      categoria: 'Café',
    ),
    Producto(
      id: 'caf_002',
      nombre: 'Café Premium Selección 1kg',
      descripcion: 'Granos selectos en grano. Ideal para baristas y conocedores.',
      precio: 72000,
      imagenUrl: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085',
      categoria: 'Café',
    ),
  ];

  static const List<Negocio> negocios = [
    Negocio(
      id: 'neg_001',
      nombre: 'Distribuidora Aliados VENTON',
      descripcion:
          'Programa de distribución mayorista de productos premium. Margen garantizado.',
      ciudad: 'Pereira',
      imagenUrl: 'https://images.unsplash.com/photo-1556761175-5973dc0f32e7',
      categoria: 'Distribución',
    ),
    Negocio(
      id: 'neg_002',
      nombre: 'Franquicia Tour Cafetero',
      descripcion:
          'Operá tu propio tour turístico bajo la marca VENTON PRO. Soporte total.',
      ciudad: 'Santa Rosa de Cabal',
      imagenUrl: 'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09',
      categoria: 'Turismo',
    ),
  ];

  static const List<Vendedor> vendedoresDestacados = [
    Vendedor(
      id: 'ven_001',
      nombre: 'Carolina Restrepo',
      ciudad: 'Pereira',
      especialidad: 'Químicos Industriales',
      imagenUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
      calificacion: 4.9,
      ventasMes: 87,
    ),
    Vendedor(
      id: 'ven_002',
      nombre: 'Andrés Gómez',
      ciudad: 'Medellín',
      especialidad: 'Turismo y Café',
      imagenUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
      calificacion: 4.8,
      ventasMes: 64,
    ),
    Vendedor(
      id: 'ven_003',
      nombre: 'Lucía Martínez',
      ciudad: 'Bogotá',
      especialidad: 'Línea Premium',
      imagenUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80',
      calificacion: 5.0,
      ventasMes: 102,
    ),
  ];
}
