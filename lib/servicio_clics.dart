import 'package:cloud_firestore/cloud_firestore.dart';

/// Cuenta cuántas veces miran o contactan un negocio.
/// Esto sirve para venderle publicidad al dueño: "lo vieron 300 personas".
class ServicioClics {
  static final _db = FirebaseFirestore.instance;

  /// Suma 1 clic al negocio. Llamar cuando alguien lo abre o le da WhatsApp.
  static Future<void> registrar(String idNegocio) async {
    await _db.collection('negocios').doc(idNegocio).set(
      {'clics': FieldValue.increment(1)},
      SetOptions(merge: true),
    );
  }

  /// Lee el total de clics del negocio (para el panel del dueño).
  static Future<int> total(String idNegocio) async {
    final doc = await _db.collection('negocios').doc(idNegocio).get();
    final data = doc.data();
    if (data == null || data['clics'] == null) return 0;
    return (data['clics'] as num).toInt();
  }
}
