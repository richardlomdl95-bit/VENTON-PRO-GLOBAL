import 'package:flutter/material.dart';

// =============================================================================
// VENTON PRO - CONFIGURACIÓN GLOBAL
// =============================================================================
// Configuración centralizada de la aplicación
// =============================================================================

class VentonConfig {
  // Información de la aplicación
  static const String appName = 'VENTON PRO';
  static const String version = '3.0.0';

  // Contacto principal del negocio (Ricardo)
  static const String adminWhatsApp = '573225609121';
  static const String adminEmail = 'ventonpro@gmail.com';

  // Colores de marca
  static const Color brandPrimary = Color(0xFF0D47A1);
  static const Color brandAccent = Color(0xFFFFC107);
  static const Color brandGold = Color(0xFFD4AF37);
  static const Color brandSuccess = Color(0xFF25D366);

  // Configuración de uploads (proteger Storage)
  static const int maxImageSizeKB = 500;
  static const int maxVideoSizeMB = 15;
  static const int maxVideoDurationSeconds = 60;
  static const int dailyUploadLimit = 5;

  // Sistema de comisiones de vendedores
  static const double comisionBronce = 0.25;
  static const double comisionPlata = 0.30;
  static const double comisionOro = 0.35;
  static const double comisionCafe = 0.20;

  // Planes de publicidad (COP)
  static const Map<String, int> planesPublicidad = {
    'basico': 30000,
    'premium': 80000,
    'top': 150000,
  };

  // Lugares precargados de Santa Rosa de Cabal
  static const List<Map<String, dynamic>> lugaresIniciales = [
    {
      'nombre': 'Termales Santa Rosa de Cabal',
      'categoria': 'turismo',
      'descripcion': 'Aguas termales naturales con cascada espectacular',
      'precio': '\$41.000–\$77.000',
      'lat': 4.8722,
      'lng': -75.5775,
      'imagen': 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=800',
    },
    {
      'nombre': 'Termales San Vicente',
      'categoria': 'turismo',
      'descripcion': 'Reserva termal en la montaña, aguas más limpias',
      'precio': '\$60.000–\$95.000',
      'lat': 4.8500,
      'lng': -75.5500,
      'imagen': 'https://images.unsplash.com/photo-1602002418816-5c0aeef426aa?w=800',
    },
    {
      'nombre': 'Chorros de Don Lolo',
      'categoria': 'turismo',
      'descripcion': 'Cascadas naturales y aguas termales en río',
      'precio': 'Desde \$15.000',
      'lat': 4.8400,
      'lng': -75.5400,
      'imagen': 'https://images.unsplash.com/photo-1432405972618-c60b0225b8f9?w=800',
    },
    {
      'nombre': 'Parque Las Araucarias',
      'categoria': 'turismo',
      'descripcion': 'Plaza principal de Santa Rosa, iglesia y vida local',
      'precio': 'Gratis',
      'lat': 4.8693,
      'lng': -75.6233,
      'imagen': 'https://images.unsplash.com/photo-1518998053901-5348d3961a04?w=800',
    },
    {
      'nombre': 'Tour del Café — Eje Cafetero',
      'categoria': 'turismo',
      'descripcion': 'Recorrido por finca cafetera con cata incluida',
      'precio': 'Desde \$80.000',
      'lat': 4.8600,
      'lng': -75.6100,
      'imagen': 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=800',
    },
  ];

  // Catálogo de Café VENTON (3 niveles, altura real)
  static const List<Map<String, dynamic>> catalogoCafe = [
    {
      'id': 'venton_altura',
      'nombre': 'CAFÉ VENTON ALTURA',
      'altura': '1.500–1.800 msnm',
      'descripcion': 'Café excelso del Eje Cafetero. Dulce y balanceado.',
      'precioLibraCOP': 28000,
      'precioKiloCOP': 52000,
      'precioLibraUSD': 9,
      'precioKiloUSD': 17,
      'imagen': 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=800',
    },
    {
      'id': 'venton_especial',
      'nombre': 'CAFÉ VENTON ESPECIAL',
      'altura': '1.800–2.000 msnm',
      'descripcion': 'Café especial. Notas cítricas y florales, cuerpo medio.',
      'precioLibraCOP': 45000,
      'precioKiloCOP': 85000,
      'precioLibraUSD': 14,
      'precioKiloUSD': 27,
      'imagen': 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800',
    },
    {
      'id': 'venton_microlote',
      'nombre': 'CAFÉ VENTON MICRO-LOTE',
      'altura': '1.900–2.000 msnm',
      'descripcion': 'Edición limitada de finca específica. Taza compleja.',
      'precioLibraCOP': 70000,
      'precioKiloCOP': 130000,
      'precioLibraUSD': 22,
      'precioKiloUSD': 42,
      'imagen': 'https://images.unsplash.com/photo-1442550528053-c431ecb55509?w=800',
    },
  ];
}
