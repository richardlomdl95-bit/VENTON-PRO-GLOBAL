import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'venton_config.dart';

/// Servicio que maneja TODA la lógica de la ruleta:
/// - 1 jugada cada 24 horas por usuario
/// - Contador global compartido
/// - Premios escalonados (jugada 100, 250, 500)
/// - Códigos únicos anti-captura
class RuletaService {
  RuletaService._();
  static final RuletaService instance = RuletaService._();

  final Random _random = Random();

  /// Verifica si el usuario PUEDE jugar (24h pasaron desde la última)
  Future<bool> puedeJugar() async {
    final prefs = await SharedPreferences.getInstance();
    final ultima = prefs.getInt(VentonConfig.ruletaUltimaJugadaKey);
    if (ultima == null) return true;
    final ahora = DateTime.now().millisecondsSinceEpoch;
    final diff = ahora - ultima;
    final horas24 = VentonConfig.horasEntreJugadas * 60 * 60 * 1000;
    return diff >= horas24;
  }

  /// Tiempo restante hasta la próxima jugada (en segundos)
  Future<int> segundosHastaProximaJugada() async {
    final prefs = await SharedPreferences.getInstance();
    final ultima = prefs.getInt(VentonConfig.ruletaUltimaJugadaKey);
    if (ultima == null) return 0;
    final ahora = DateTime.now().millisecondsSinceEpoch;
    final diff = ahora - ultima;
    final horas24 = VentonConfig.horasEntreJugadas * 60 * 60 * 1000;
    final restanteMs = horas24 - diff;
    if (restanteMs <= 0) return 0;
    return (restanteMs / 1000).floor();
  }

  /// Obtiene el contador GLOBAL de jugadas (compartido entre todos los usuarios)
  /// En OLA 2 esto irá a Firebase. Por ahora simulamos con SharedPreferences local.
  Future<int> jugadasGlobales() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(VentonConfig.ruletaJugadasGlobalKey) ?? 0;
  }

  /// Realiza una jugada y devuelve el premio + código único.
  /// Esta es la función central de la ruleta.
  Future<ResultadoRuleta> jugar() async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Aumentar contador global
    final globalActual = await jugadasGlobales();
    final nuevoGlobal = globalActual + 1;
    await prefs.setInt(VentonConfig.ruletaJugadasGlobalKey, nuevoGlobal);

    // 2. Marcar última jugada
    await prefs.setInt(
      VentonConfig.ruletaUltimaJugadaKey,
      DateTime.now().millisecondsSinceEpoch,
    );

    // 3. Determinar premio
    final premio = _determinarPremio(nuevoGlobal);

    // 4. Generar código único anti-captura
    final codigo = _generarCodigoUnico();

    // 5. Guardar código en historial
    await _guardarCodigo(codigo, premio.id);

    return ResultadoRuleta(
      premio: premio,
      codigoUnico: codigo,
      jugadasGlobales: nuevoGlobal,
    );
  }

  /// Determina qué premio sale según probabilidades + reglas de premios escalonados.
  PremioRuleta _determinarPremio(int jugadaGlobal) {
    // Premios escalonados: cada 100 jugadas hay garantía de un champú
    // Cada 250: producto mediano garantizado
    // Cada 500: gran premio garantizado
    if (jugadaGlobal % VentonConfig.ruletaJugadasParaPremio == 0) {
      return MockData.premiosRuleta
          .firstWhere((p) => p.tipo == TipoPremio.granPremio);
    }
    if (jugadaGlobal % 250 == 0) {
      final medianos = MockData.premiosRuleta
          .where((p) => p.tipo == TipoPremio.productoMediano)
          .toList();
      return medianos[_random.nextInt(medianos.length)];
    }
    if (jugadaGlobal % 100 == 0) {
      return MockData.premiosRuleta
          .firstWhere((p) => p.id == 'p_champu');
    }

    // Probabilidades normales (sumadas = 100)
    final r = _random.nextInt(100);
    if (r < 60) {
      // 60% sigue intentando
      return MockData.premiosRuleta
          .firstWhere((p) => p.tipo == TipoPremio.sigueIntentando);
    } else if (r < 85) {
      // 25% cupón descuento (5% o 10%)
      final cupones = MockData.premiosRuleta
          .where((p) => p.tipo == TipoPremio.cuponDescuento)
          .toList();
      return cupones[_random.nextInt(cupones.length)];
    } else if (r < 95) {
      // 10% champú chico
      return MockData.premiosRuleta.firstWhere((p) => p.id == 'p_champu');
    } else {
      // 5% productos medianos
      final medianos = MockData.premiosRuleta
          .where((p) => p.tipo == TipoPremio.productoMediano)
          .toList();
      return medianos[_random.nextInt(medianos.length)];
    }
  }

  /// Genera código único de 8 caracteres alfanuméricos
  /// Formato: VTN-XXXX-XXXX
  String _generarCodigoUnico() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // Sin O/0/I/1 confusas
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = timestamp.substring(timestamp.length - 4);
    final rand = String.fromCharCodes(
      Iterable.generate(
        4,
        (_) => chars.codeUnitAt(_random.nextInt(chars.length)),
      ),
    );
    return 'VTN-$rand-$hash';
  }

  Future<void> _guardarCodigo(String codigo, String premioId) async {
    final prefs = await SharedPreferences.getInstance();
    final lista = prefs.getStringList('ruleta_codigos_emitidos') ?? [];
    lista.add('$codigo|$premioId|${DateTime.now().toIso8601String()}');
    // Mantener solo los últimos 50
    if (lista.length > 50) lista.removeRange(0, lista.length - 50);
    await prefs.setStringList('ruleta_codigos_emitidos', lista);
  }

  /// Para testing — resetear todo
  Future<void> resetear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(VentonConfig.ruletaUltimaJugadaKey);
    await prefs.remove(VentonConfig.ruletaJugadasGlobalKey);
    await prefs.remove('ruleta_codigos_emitidos');
  }
}

/// Resultado de una jugada de ruleta
class ResultadoRuleta {
  final PremioRuleta premio;
  final String codigoUnico;
  final int jugadasGlobales;

  const ResultadoRuleta({
    required this.premio,
    required this.codigoUnico,
    required this.jugadasGlobales,
  });
}
