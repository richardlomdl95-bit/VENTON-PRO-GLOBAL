import 'package:flutter/material.dart';

class VentonConfig {
  VentonConfig._();

  static const String appName = 'VENTON PRO';
  static const String appVersion = '2.1.7';
  static const String slogan = 'Vendé más. Crecé más.';

  static const String whatsappNumber = '573225609121';
  static const String mensajeBienvenida =
      'Hola VENTON PRO, quiero más información.';

  static const List<String> mercados = [
    'Colombia',
    'España',
    'Venezuela',
    'USA',
  ];

  // Ruleta
  static const int ruletaJugadasParaPremio = 500;
  static const int horasEntreJugadas = 24;
  static const String ruletaJugadasGlobalKey = 'ruleta_jugadas_global';
  static const String ruletaUltimaJugadaKey = 'ruleta_ultima_jugada';
  static const String ruletaCodigoPremioKey = 'ruleta_codigo_premio';

  // Storage
  static const String favoritosKey = 'venton_favoritos';

  // Web
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
  final String categoria;
  final bool destacado;
  final int? descuentoPorcentaje;
  final List<String> caracteristicas;

  const Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.descripcionLarga,
    required this.precio,
    this.precioAntes,
    required this.imagenUrl,
    required this.categoria,
    this.moneda = 'COP',
    this.destacado = false,
    this.descuentoPorcentaje,
    this.caracteristicas = const [],
  });

  bool get tieneDescuento =>
      descuentoPorcentaje != null && descuentoPorcentaje! > 0;
}

/// Experiencia turística — ahora con WhatsApp del dueño
@immutable
class Experiencia {
  final String id;
  final String titulo;
  final String descripcion;
  final String descripcionLarga;
  final String ubicacion;
  final double precio;
  final String imagenUrl;
  final List<String> incluye;
  final String duracion;
  final String whatsappDueno; // 🆕 WhatsApp directo al dueño
  final String nombreDueno;
  final String nombreNegocio;

  const Experiencia({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.descripcionLarga,
    required this.ubicacion,
    required this.precio,
    required this.imagenUrl,
    required this.whatsappDueno,
    required this.nombreDueno,
    required this.nombreNegocio,
    this.incluye = const [],
    this.duracion = '1 día',
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

/// Negocio publicitario (hotel, restaurante, panadería, etc.)
@immutable
class NegocioAnunciante {
  final String id;
  final String nombre;
  final String tipo; // Hotel, Restaurante, Panadería, etc.
  final String ciudad;
  final String pais;
  final String descripcion;
  final String imagenUrl;
  final String whatsappDueno;
  final String nombreDueno;
  final String plan; // Visible, Destacado, Top
  final bool verificado;

  const NegocioAnunciante({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.ciudad,
    required this.pais,
    required this.descripcion,
    required this.imagenUrl,
    required this.whatsappDueno,
    required this.nombreDueno,
    this.plan = 'Visible',
    this.verificado = true,
  });
}

/// Premio de la ruleta — con código único
@immutable
class PremioRuleta {
  final String id;
  final String nombre;
  final String descripcion;
  final IconData icono;
  final Color color;
  final TipoPremio tipo;

  const PremioRuleta({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.icono,
    required this.color,
    required this.tipo,
  });
}

enum TipoPremio {
  sigueIntentando,
  cuponDescuento,
  productoChico,
  productoMediano,
  granPremio,
}

// ============================================================
// MOCK DATA
// ============================================================

class MockData {
  MockData._();

  // ---------- TURISMO con WhatsApp DUEÑO ----------
  static const List<Experiencia> turismoSantaRosa = [
    Experiencia(
      id: 'tur_001',
      titulo: 'Termales Santa Rosa de Cabal',
      descripcion: 'Aguas termales naturales con cascadas',
      descripcionLarga:
          'Día completo en las aguas termales naturales de Santa Rosa, rodeado de cascadas y bosque andino. Salida desde Pereira, refrigerio incluido, guía bilingüe.',
      ubicacion: 'Santa Rosa de Cabal, Risaralda',
      precio: 180000,
      imagenUrl:
          'https://images.unsplash.com/photo-1551244072-5d12893278ab?w=800',
      duracion: '1 día completo',
      whatsappDueno: '573114567001',
      nombreDueno: 'Don Carlos',
      nombreNegocio: 'Termales del Otoño',
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
      descripcion: 'Recorrido por finca cafetera tradicional',
      descripcionLarga:
          'Conocé el proceso completo del café desde la planta hasta la taza. Visita a finca tradicional, recorrido por cultivos, demostración de tueste, taller de cata y degustación.',
      ubicacion: 'Eje Cafetero, Risaralda',
      precio: 120000,
      imagenUrl:
          'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800',
      duracion: 'Medio día',
      whatsappDueno: '573114567002',
      nombreDueno: 'Doña Marta',
      nombreNegocio: 'Finca La Esperanza',
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
      descripcion: 'Caminata ecológica con guía nativo',
      descripcionLarga:
          'Caminata moderada por sendero ecológico hasta las cascadas naturales de San Ramón. 4 horas de aventura con baño en pozos naturales y almuerzo campesino.',
      ubicacion: 'Santa Rosa de Cabal',
      precio: 95000,
      imagenUrl:
          'https://images.unsplash.com/photo-1432405972618-c60b0225b8f9?w=800',
      duracion: '4-5 horas',
      whatsappDueno: '573114567003',
      nombreDueno: 'Don Hernán',
      nombreNegocio: 'Eco-Tours San Ramón',
      incluye: ['Guía local', 'Almuerzo campesino', 'Equipo de seguridad'],
    ),
    Experiencia(
      id: 'tur_004',
      titulo: 'Parque Nacional Los Nevados',
      descripcion: 'Aventura de altura al páramo',
      descripcionLarga:
          'Excursión de día completo al Parque Nacional Los Nevados. Caminata por el páramo, mirador del Nevado del Ruiz, almuerzo en refugio de altura.',
      ubicacion: 'Manizales / Risaralda',
      precio: 240000,
      imagenUrl:
          'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800',
      duracion: '1 día completo',
      whatsappDueno: '573114567004',
      nombreDueno: 'Don Mauricio',
      nombreNegocio: 'Andes Adventures',
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
      descripcion: 'Birdwatching en reserva privada',
      descripcionLarga:
          'Tour especializado de avistamiento con experto ornitólogo. Más de 80 especies registradas en la zona.',
      ubicacion: 'Reserva Otún Quimbaya',
      precio: 150000,
      imagenUrl:
          'https://images.unsplash.com/photo-1444464666168-49d633b86797?w=800',
      duracion: 'Medio día',
      whatsappDueno: '573114567005',
      nombreDueno: 'Doña Ana',
      nombreNegocio: 'Aves del Quindío',
      incluye: [
        'Guía ornitólogo',
        'Binoculares',
        'Guía de aves impresa',
        'Refrigerio',
      ],
    ),
  ];

  // ---------- QUÍMICOS ----------
  static const List<Producto> quimicosPremium = [
    Producto(
      id: 'qui_001',
      nombre: 'Desengrasante Industrial Pro',
      descripcion: 'Galón 4L · Biodegradable',
      descripcionLarga:
          'Fórmula concentrada de uso pesado. Remueve grasa pesada, aceite quemado y residuos orgánicos. Galón de 4 litros, biodegradable certificado.',
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
          'Cera líquida con polímeros sintéticos. Protege la pintura de rayos UV, lluvia ácida y manchas. Brillo espejo de hasta 60 días.',
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
          'Concentrado multiusos de pH neutro. 1 galón rinde hasta 20 litros. Seguro para todas las superficies. Aroma cítrico fresco.',
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
          'Shampoo automotriz neutro sin sales. Espuma abundante, fácil enjuague, brillo instantáneo.',
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
          'Desinfectante de grado hospitalario con amonio cuaternario. Elimina 99.9% de bacterias, hongos y virus.',
      precio: 78000,
      imagenUrl:
          'https://images.unsplash.com/photo-1584744982491-665216d95f8b?w=800',
      categoria: 'Industrial',
      destacado: true,
    ),
    Producto(
      id: 'qui_006',
      nombre: 'Champú de Romero VENTON',
      descripcion: '500ml · Natural · Sin sal · Sin colorantes',
      descripcionLarga:
          'Champú artesanal premium VENTON elaborado a base de romero, quina y canela. Sin sal, sin colorantes. 100% natural. Fortalece el cabello desde la raíz, estimula el crecimiento y devuelve el brillo natural. Ideal para cualquier tipo de cabello.',
      precio: 35000,
      imagenUrl:
          'https://images.unsplash.com/photo-1585870683023-a86c12d23f8f?w=800',
      categoria: 'Cuidado Personal',
      destacado: true,
      caracteristicas: [
        '500 ml',
        'A base de romero, quina y canela',
        'Libre de sal',
        'Libre de colorantes',
        '100% natural',
        'Fortalece el cabello',
      ],
    ),
  ];

  // ---------- CAFÉ ----------
  static const List<Producto> cafeProductos = [
    Producto(
      id: 'caf_001',
      nombre: 'Café de Origen Santa Rosa 500g',
      descripcion: 'Tueste medio · Notas chocolate',
      descripcionLarga:
          'Café 100% arábica cultivado en las laderas del volcán Santa Rosa. Tueste medio que resalta notas a chocolate negro y caramelo. Taza de 84 puntos SCA.',
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
          'Selección premium en grano entero. Granos de mayor tamaño, dulzor pronunciado y acidez balanceada.',
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
          'Café descafeinado por proceso suizo natural, conserva todo el sabor. Tueste medio-oscuro.',
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
          'Concentrado de cold brew con extracción lenta de 18 horas. Diluí 1:3 con agua o leche.',
      precio: 24000,
      imagenUrl:
          'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=800',
      categoria: 'Café',
    ),
  ];

  // ---------- VENDEDORES ----------
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

  // ---------- NEGOCIOS ANUNCIANTES (preview hotelería/comercio) ----------
  static const List<NegocioAnunciante> negociosAnunciantes = [
    NegocioAnunciante(
      id: 'neg_001',
      nombre: 'Hotel Termales del Otoño',
      tipo: 'Hotel',
      ciudad: 'Santa Rosa de Cabal',
      pais: 'Colombia',
      descripcion:
          'Hotel boutique con piscinas termales privadas, spa y vista al volcán. Habitaciones premium con jacuzzi.',
      imagenUrl:
          'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
      whatsappDueno: '573114567001',
      nombreDueno: 'Don Carlos',
      plan: 'Top',
    ),
    NegocioAnunciante(
      id: 'neg_002',
      nombre: 'Restaurante La Esquina',
      tipo: 'Restaurante',
      ciudad: 'Pereira',
      pais: 'Colombia',
      descripcion:
          'Cocina colombiana tradicional con toque moderno. Especialidad en bandeja paisa y trucha del río.',
      imagenUrl:
          'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800',
      whatsappDueno: '573114567010',
      nombreDueno: 'Doña Beatriz',
      plan: 'Destacado',
    ),
    NegocioAnunciante(
      id: 'neg_003',
      nombre: 'Panadería El Buen Pan',
      tipo: 'Panadería',
      ciudad: 'Santa Rosa de Cabal',
      pais: 'Colombia',
      descripcion:
          'Pan artesanal recién horneado, pastelería fina y café de la región. Abierto desde las 5 AM.',
      imagenUrl:
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=800',
      whatsappDueno: '573114567020',
      nombreDueno: 'Don Pedro',
      plan: 'Visible',
    ),
  ];

  // ---------- PREMIOS RULETA ----------
  static const List<PremioRuleta> premiosRuleta = [
    PremioRuleta(
      id: 'p_sigue_1',
      nombre: 'Sigue intentando',
      descripcion: 'Volvé mañana, ¡suerte para la próxima!',
      icono: Icons.refresh_rounded,
      color: Color(0xFF0D2849),
      tipo: TipoPremio.sigueIntentando,
    ),
    PremioRuleta(
      id: 'p_sigue_2',
      nombre: 'Sigue intentando',
      descripcion: 'Volvé mañana, ¡suerte para la próxima!',
      icono: Icons.refresh_rounded,
      color: Color(0xFF0D2849),
      tipo: TipoPremio.sigueIntentando,
    ),
    PremioRuleta(
      id: 'p_cup5',
      nombre: 'Cupón -5%',
      descripcion: 'Descuento del 5% en tu próxima compra VENTON PRO',
      icono: Icons.local_offer_rounded,
      color: Color(0xFFB87333),
      tipo: TipoPremio.cuponDescuento,
    ),
    PremioRuleta(
      id: 'p_cup10',
      nombre: 'Cupón -10%',
      descripcion: 'Descuento del 10% en tu próxima compra VENTON PRO',
      icono: Icons.local_offer_rounded,
      color: Color(0xFFB87333),
      tipo: TipoPremio.cuponDescuento,
    ),
    PremioRuleta(
      id: 'p_champu',
      nombre: 'Champú Romero VENTON',
      descripcion:
          '500ml de Champú VENTON natural a base de romero, quina y canela. Sin sal, sin colorantes.',
      icono: Icons.spa_rounded,
      color: Color(0xFF0D2849),
      tipo: TipoPremio.productoChico,
    ),
    PremioRuleta(
      id: 'p_tour',
      nombre: 'Tour Café gratis',
      descripcion: 'Tour por finca cafetera tradicional para 1 persona',
      icono: Icons.coffee_rounded,
      color: Color(0xFFB87333),
      tipo: TipoPremio.productoMediano,
    ),
    PremioRuleta(
      id: 'p_giftcard',
      nombre: 'Gift Card \$20.000',
      descripcion: 'Tarjeta regalo de \$20.000 en negocios VENTON PRO',
      icono: Icons.card_giftcard_rounded,
      color: Color(0xFF0D2849),
      tipo: TipoPremio.productoMediano,
    ),
    PremioRuleta(
      id: 'p_combo',
      nombre: '🏆 Combo Limpieza VENTON',
      descripcion:
          'Champú Romero 500ml + Jabón 4L + Desinfectante 4L. Premio mayor cada 500 jugadas globales.',
      icono: Icons.emoji_events_rounded,
      color: Color(0xFFB87333),
      tipo: TipoPremio.granPremio,
    ),
  ];

  /// Productos destacados del inicio
  static List<Producto> get destacadosInicio => [
        ...quimicosPremium.where((p) => p.destacado),
        ...cafeProductos.where((p) => p.destacado),
      ];

  /// Productos en oferta
  static List<Producto> get productosEnOferta => [
        ...quimicosPremium.where((p) => p.tieneDescuento),
        ...cafeProductos.where((p) => p.tieneDescuento),
      ];
}
