import 'package:flutter/material.dart';

class VentonConfig {
  VentonConfig._();

  static const String appName = 'VENTON PRO';
  static const String appVersion = '2.1.6';
  static const String slogan = 'Vendé más. Crecé más.';

  static const String whatsappNumber = '573225609121';
  static const String mensajeBienvenida =
      'Hola VENTON PRO, quiero más información.';

  static const List<String> mercados = ['Colombia', 'USA', 'Venezuela'];

  static const int ruletaJugadasParaPremio = 500;
  static const String ruletaKey = 'ruleta_jugadas_total';
  static const String ruletaHistorialKey = 'ruleta_historial';

  static const String favoritosKey = 'venton_favoritos';

  static const String urlPolitica = 'https://ventonpro.com/privacidad';
  static const String urlTerminos = 'https://ventonpro.com/terminos';
  static const String urlEliminacionCuenta =
      'https://ventonpro.com/eliminar-cuenta';
}

// ============================================================
// MODELOS
// ============================================================

@immutable
class Producto {
  final String id;
  final String nombre;
  final String descripcion;
  final String descripcionLarga;
  final double precio;
  final double? precioAntes;
  final String moneda;
  final String imagenUrl;
  final List<String> imagenesGaleria;
  final String categoria;
  final bool destacado;
  final int? descuentoPorcentaje;

  const Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.descripcionLarga,
    required this.precio,
    this.precioAntes,
    required this.imagenUrl,
    this.imagenesGaleria = const [],
    required this.categoria,
    this.moneda = 'COP',
    this.destacado = false,
    this.descuentoPorcentaje,
  });

  bool get tieneDescuento =>
      descuentoPorcentaje != null && descuentoPorcentaje! > 0;
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
  final String whatsappPropio;
  final String biografia;

  const Vendedor({
    required this.id,
    required this.nombre,
    required this.ciudad,
    required this.especialidad,
    required this.imagenUrl,
    required this.calificacion,
    required this.ventasMes,
    required this.whatsappPropio,
    required this.biografia,
  });
}

@immutable
class Experiencia {
  final String id;
  final String titulo;
  final String descripcion;
  final String descripcionLarga;
  final String ubicacion;
  final double precio;
  final String imagenUrl;
  final List<String> imagenesGaleria;
  final List<String> incluye;
  final String duracion;

  const Experiencia({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.descripcionLarga,
    required this.ubicacion,
    required this.precio,
    required this.imagenUrl,
    this.imagenesGaleria = const [],
    this.incluye = const [],
    this.duracion = '1 día',
  });
}

// ============================================================
// MOCK DATA ENRIQUECIDA
// ============================================================

class MockData {
  MockData._();

  static const List<Experiencia> turismoSantaRosa = [
    Experiencia(
      id: 'tur_001',
      titulo: 'Termales Santa Rosa de Cabal',
      descripcion: 'Visita guiada a las aguas termales más famosas de Colombia.',
      descripcionLarga:
          'Vivís un día completo en las aguas termales naturales de Santa Rosa, rodeado de cascadas y bosque andino. Salida desde Pereira en transporte cómodo, refrigerio incluido, guía bilingüe y entrada a la zona privada de termales. Ideal para parejas, familias y grupos.',
      ubicacion: 'Santa Rosa de Cabal, Risaralda',
      precio: 180000,
      imagenUrl:
          'https://images.unsplash.com/photo-1551244072-5d12893278ab?w=800',
      duracion: '1 día completo',
      incluye: [
        'Transporte ida y vuelta',
        'Entrada a termales',
        'Refrigerio típico',
        'Guía bilingüe',
        'Seguro de viaje',
      ],
    ),
    Experiencia(
      id: 'tur_002',
      titulo: 'Tour del Café Premium',
      descripcion: 'Recorrido por finca cafetera tradicional.',
      descripcionLarga:
          'Conocé el proceso completo del café desde la planta hasta la taza. Visita a finca tradicional del Eje Cafetero, recorrido por cultivos, demostración de tueste, taller de cata y degustación. Llevate medio kilo de café como recuerdo.',
      ubicacion: 'Eje Cafetero, Risaralda',
      precio: 120000,
      imagenUrl:
          'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800',
      duracion: 'Medio día',
      incluye: [
        'Tour por finca cafetera',
        'Cata profesional',
        '500g de café de regalo',
        'Almuerzo típico',
      ],
    ),
    Experiencia(
      id: 'tur_003',
      titulo: 'Cascadas de San Ramón',
      descripcion: 'Caminata ecológica con guía nativo a las cascadas.',
      descripcionLarga:
          'Caminata moderada por sendero ecológico hasta las cascadas naturales de San Ramón. 4 horas de aventura con baño en pozos naturales, almuerzo campesino y guía local conocedor de la región.',
      ubicacion: 'Santa Rosa de Cabal',
      precio: 95000,
      imagenUrl:
          'https://images.unsplash.com/photo-1432405972618-c60b0225b8f9?w=800',
      duracion: '4-5 horas',
      incluye: [
        'Guía local',
        'Almuerzo campesino',
        'Equipo de seguridad',
      ],
    ),
    Experiencia(
      id: 'tur_004',
      titulo: 'Parque Nacional Los Nevados',
      descripcion: 'Aventura de altura al páramo y nevados.',
      descripcionLarga:
          'Excursión de día completo al Parque Nacional Los Nevados. Caminata por el páramo, mirador del Nevado del Ruiz, almuerzo en refugio de altura. Recomendado para personas en buen estado físico.',
      ubicacion: 'Manizales / Risaralda',
      precio: 240000,
      imagenUrl:
          'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800',
      duracion: '1 día completo',
      incluye: [
        'Transporte 4x4',
        'Almuerzo de altura',
        'Equipamiento básico',
        'Guía especializado',
      ],
    ),
    Experiencia(
      id: 'tur_005',
      titulo: 'Avistamiento de aves',
      descripcion: 'Birdwatching en reserva privada del Eje Cafetero.',
      descripcionLarga:
          'Tour especializado de avistamiento con experto ornitólogo. Más de 80 especies registradas en la zona. Incluye binoculares, guía técnica y transporte privado.',
      ubicacion: 'Reserva Otún Quimbaya',
      precio: 150000,
      imagenUrl:
          'https://images.unsplash.com/photo-1444464666168-49d633b86797?w=800',
      duracion: 'Medio día',
      incluye: [
        'Guía ornitólogo',
        'Binoculares',
        'Guía de aves impresa',
        'Refrigerio',
      ],
    ),
  ];

  static const List<Producto> quimicosPremium = [
    Producto(
      id: 'qui_001',
      nombre: 'Desengrasante Industrial Pro',
      descripcion: 'Galón 4L · Biodegradable',
      descripcionLarga:
          'Fórmula concentrada de uso pesado para industria, talleres y cocinas industriales. Remueve grasa pesada, aceite quemado y residuos orgánicos sin dañar superficies metálicas. Galón de 4 litros, biodegradable certificado.',
      precio: 95000,
      imagenUrl:
          'https://images.unsplash.com/photo-1583947215259-38e31be8751f?w=800',
      categoria: 'Industrial',
      destacado: true,
    ),
    Producto(
      id: 'qui_002',
      nombre: 'Cera Automotriz Premium',
      descripcion: 'Brillo profesional · Larga duración',
      descripcionLarga:
          'Cera líquida de aplicación profesional con polímeros sintéticos. Protege la pintura de rayos UV, lluvia ácida y manchas. Brillo espejo de hasta 60 días. Botella de 500 ml.',
      precio: 65000,
      precioAntes: 80000,
      descuentoPorcentaje: 18,
      imagenUrl:
          'https://images.unsplash.com/photo-1607860108855-64acf2078ed9?w=800',
      categoria: 'Automotriz',
      destacado: true,
    ),
    Producto(
      id: 'qui_003',
      nombre: 'Limpiador Multiusos Concentrado',
      descripcion: 'Rinde 20L · Aroma fresco · Ph neutro',
      descripcionLarga:
          'Concentrado multiusos de pH neutro. 1 galón rinde hasta 20 litros de producto listo para usar. Seguro para todas las superficies del hogar. Aroma cítrico fresco y duradero.',
      precio: 48000,
      imagenUrl:
          'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=800',
      categoria: 'Hogar',
    ),
    Producto(
      id: 'qui_004',
      nombre: 'Shampoo para Auto sin Sales',
      descripcion: 'No daña la cera · 4 litros',
      descripcionLarga:
          'Shampoo automotriz neutro sin sales que respeta la cera y los selladores aplicados. Espuma abundante, fácil enjuague, brillo instantáneo. Ideal para uso semanal.',
      precio: 55000,
      precioAntes: 70000,
      descuentoPorcentaje: 21,
      imagenUrl:
          'https://images.unsplash.com/photo-1605618826115-fb9e776cd224?w=800',
      categoria: 'Automotriz',
    ),
    Producto(
      id: 'qui_005',
      nombre: 'Desinfectante Hospitalario',
      descripcion: 'Bactericida · Galón 4L',
      descripcionLarga:
          'Desinfectante de grado hospitalario con amonio cuaternario de 5ª generación. Elimina 99.9% de bacterias, hongos y virus. Uso profesional en clínicas, gimnasios, restaurantes y oficinas.',
      precio: 78000,
      imagenUrl:
          'https://images.unsplash.com/photo-1584744982491-665216d95f8b?w=800',
      categoria: 'Industrial',
      destacado: true,
    ),
    Producto(
      id: 'qui_006',
      nombre: 'Aromatizante de Ambiente Lavanda',
      descripcion: '1 litro · Larga duración',
      descripcionLarga:
          'Aromatizante concentrado con esencia importada de lavanda. Aplicación con dosificador o difusor. Perdura hasta 8 horas en ambientes cerrados.',
      precio: 32000,
      imagenUrl:
          'https://images.unsplash.com/photo-1600857544200-b2f666a9a2ec?w=800',
      categoria: 'Hogar',
    ),
  ];

  static const List<Producto> cafeProductos = [
    Producto(
      id: 'caf_001',
      nombre: 'Café de Origen Santa Rosa 500g',
      descripcion: 'Tueste medio · Notas chocolate',
      descripcionLarga:
          'Café de origen 100% arábica cultivado en las laderas del volcán Santa Rosa. Tueste medio que resalta notas a chocolate negro, caramelo y cereza madura. Cosecha del Eje Cafetero, taza de 84 puntos SCA.',
      precio: 38000,
      imagenUrl:
          'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=800',
      categoria: 'Café',
      destacado: true,
    ),
    Producto(
      id: 'caf_002',
      nombre: 'Café Premium Selección 1kg',
      descripcion: 'Granos selectos · Para baristas',
      descripcionLarga:
          'Selección premium en grano entero, ideal para baristas y conocedores. Granos de mayor tamaño, dulzor pronunciado y acidez balanceada. Empaque de 1 kg con válvula de aroma.',
      precio: 72000,
      precioAntes: 85000,
      descuentoPorcentaje: 15,
      imagenUrl:
          'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800',
      categoria: 'Café',
      destacado: true,
    ),
    Producto(
      id: 'caf_003',
      nombre: 'Café Decaf Suizo 250g',
      descripcion: 'Sin cafeína · Proceso natural',
      descripcionLarga:
          'Café descafeinado por proceso suizo natural (sin químicos), conserva todo el sabor del café tradicional. Tueste medio-oscuro, notas a frutos secos y cacao.',
      precio: 28000,
      imagenUrl:
          'https://images.unsplash.com/photo-1497636577773-f1231844b336?w=800',
      categoria: 'Café',
    ),
    Producto(
      id: 'caf_004',
      nombre: 'Café Cold Brew Concentrado',
      descripcion: 'Botella 500ml · Listo para servir',
      descripcionLarga:
          'Concentrado de cold brew preparado con extracción lenta de 18 horas. Diluí 1:3 con agua o leche. Sin azúcar añadida, sabor suave y dulzura natural.',
      precio: 24000,
      imagenUrl:
          'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=800',
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
      imagenUrl:
          'https://images.unsplash.com/photo-1556761175-5973dc0f32e7?w=800',
      categoria: 'Distribución',
    ),
    Negocio(
      id: 'neg_002',
      nombre: 'Franquicia Tour Cafetero',
      descripcion:
          'Operá tu propio tour turístico bajo la marca VENTON PRO. Soporte total.',
      ciudad: 'Santa Rosa de Cabal',
      imagenUrl:
          'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=800',
      categoria: 'Turismo',
    ),
  ];

  static const List<Vendedor> vendedoresDestacados = [
    Vendedor(
      id: 'ven_001',
      nombre: 'Carolina Restrepo',
      ciudad: 'Pereira',
      especialidad: 'Químicos Industriales',
      imagenUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
      calificacion: 4.9,
      ventasMes: 87,
      whatsappPropio: '573114567890',
      biografia:
          'Vendedora líder en químicos industriales con 5 años de experiencia. Atiende empresas y mayoristas en Eje Cafetero.',
    ),
    Vendedor(
      id: 'ven_002',
      nombre: 'Andrés Gómez',
      ciudad: 'Medellín',
      especialidad: 'Turismo y Café',
      imagenUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
      calificacion: 4.8,
      ventasMes: 64,
      whatsappPropio: '573145678901',
      biografia:
          'Especialista en planes turísticos y café premium. Cobertura nacional, envíos a todo Colombia.',
    ),
    Vendedor(
      id: 'ven_003',
      nombre: 'Lucía Martínez',
      ciudad: 'Bogotá',
      especialidad: 'Línea Premium',
      imagenUrl:
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400',
      calificacion: 5.0,
      ventasMes: 102,
      whatsappPropio: '573156789012',
      biografia:
          'Top seller VENTON PRO. Atención personalizada para clientes premium en Bogotá y alrededores.',
    ),
    Vendedor(
      id: 'ven_004',
      nombre: 'Mateo Vargas',
      ciudad: 'Cali',
      especialidad: 'Automotriz',
      imagenUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400',
      calificacion: 4.7,
      ventasMes: 58,
      whatsappPropio: '573167890123',
      biografia:
          'Asesor especializado en línea automotriz. Atiende lavaderos, talleres y detailers.',
    ),
  ];

  /// Productos destacados del inicio (top picks)
  static List<Producto> get destacadosInicio => [
        ...quimicosPremium.where((p) => p.destacado),
        ...cafeProductos.where((p) => p.destacado),
      ];

  /// Productos en oferta (con descuento)
  static List<Producto> get productosEnOferta => [
        ...quimicosPremium.where((p) => p.tieneDescuento),
        ...cafeProductos.where((p) => p.tieneDescuento),
      ];
}
