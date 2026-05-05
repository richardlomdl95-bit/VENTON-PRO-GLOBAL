import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'venton_config.dart';

// =============================================================================
// VENTON PRO - HELPERS GLOBALES
// =============================================================================
// Utilidades estáticas para toda la aplicación
// =============================================================================

class VentonHelpers {
  // Abrir WhatsApp con mensaje pre-llenado
  static Future<void> openWhatsApp(String mensaje,
      {String? numero}) async {
    final num = numero ?? VentonConfig.adminWhatsApp;
    final uri = Uri.parse(
        'https://wa.me/$num?text=${Uri.encodeComponent(mensaje)}');
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        debugPrint('No se pudo abrir WhatsApp');
      }
    } catch (e) {
      debugPrint('WhatsApp error: $e');
    }
  }

  // Abrir Google Maps externo (gratis, sin API)
  static Future<void> abrirMapaExterno(double lat, double lng,
      {String? nombre}) async {
    final query = nombre != null
        ? '$lat,$lng($nombre)'
        : '$lat,$lng';
    final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$query');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Maps error: $e');
    }
  }

  // Registrar evento en Firestore (tracking)
  static Future<void> logEvent(
      String collection, Map<String, dynamic> data) async {
    try {
      // TODO: FIREBASE_OFF — reactivar en services/firebase_service.dart
      // await FirebaseFirestore.instance.collection(collection).add({
      //   ...data,
      //   'timestamp': FieldValue.serverTimestamp(),
      // });
      debugPrint('Firebase desactivado temporalmente: logEvent($collection, $data)');
    } catch (e) {
      debugPrint('Firestore error: $e');
    }
  }

  // Obtener ubicación del usuario (mundial)
  static Future<Position?> obtenerUbicacion() async {
    try {
      bool servicioActivo = await Geolocator.isLocationServiceEnabled();
      if (!servicioActivo) return null;

      LocationPermission permiso = await Geolocator.checkPermission();
      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
        if (permiso == LocationPermission.denied) return null;
      }
      if (permiso == LocationPermission.deniedForever) return null;

      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
    } catch (e) {
      debugPrint('Ubicación error: $e');
      return null;
    }
  }

  // Verificar límite diario de uploads (proteger Storage)
  static Future<bool> puedeSubir() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hoy = DateTime.now().toIso8601String().substring(0, 10);
      final ultimaFecha = prefs.getString('upload_fecha') ?? '';
      int conteoHoy = prefs.getInt('upload_conteo') ?? 0;

      if (ultimaFecha != hoy) {
        await prefs.setString('upload_fecha', hoy);
        await prefs.setInt('upload_conteo', 0);
        conteoHoy = 0;
      }

      return conteoHoy < VentonConfig.dailyUploadLimit;
    } catch (e) {
      return true;
    }
  }

  // Incrementar contador de uploads
  static Future<void> registrarUpload() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final actual = prefs.getInt('upload_conteo') ?? 0;
      await prefs.setInt('upload_conteo', actual + 1);
    } catch (e) {
      debugPrint('Contador upload error: $e');
    }
  }

  // Mostrar snackbar
  static void mostrarMensaje(BuildContext context, String mensaje,
      {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: error ? Colors.red[700] : VentonConfig.brandSuccess,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
