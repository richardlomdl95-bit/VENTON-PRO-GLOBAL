import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../core/venton_config.dart';
import '../core/venton_helpers.dart';

// =============================================================================

class MasPage extends StatelessWidget {
  const MasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Más opciones'),
      ),
      body: ListView(
        children: [
          _ItemMenu(
              icon: Icons.handshake,
              titulo: 'Sé vendedor VENTON',
              subtitulo: 'Gana comisiones desde cualquier país',
              color: const Color(0xFF6A1B9A),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const VendedoresPage()))),
          _ItemMenu(
              icon: Icons.science,
              titulo: 'Productos químicos',
              subtitulo: 'Premium para flotas y plantas',
              color: const Color(0xFF00838F),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const Scaffold(
                    body: Center(child: Text('Próximamente'))
                  )))),
          _ItemMenu(
              icon: Icons.casino,
              titulo: 'Ruleta VENTON',
              subtitulo: 'Promoción gratis. Premios para clientes.',
              color: VentonConfig.brandAccent,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const Scaffold(
                    body: Center(child: Text('Próximamente'))
                  )))),
          const Divider(),
          _ItemMenu(
              icon: Icons.add_a_photo,
              titulo: 'Subir contenido',
              subtitulo: 'Comparte fotos y videos de Santa Rosa',
              color: VentonConfig.brandPrimary,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const Scaffold(
                    body: Center(child: Text('Próximamente'))
                  )))),
          _ItemMenu(
              icon: Icons.flag,
              titulo: 'Reportar contenido',
              subtitulo: 'Ayúdanos a mantener la app limpia',
              color: Colors.red[700]!,
              onTap: () => _reportarGeneral(context)),
          const Divider(),
          _ItemMenu(
              icon: Icons.privacy_tip,
              titulo: 'Política de privacidad',
              subtitulo: 'Cómo cuidamos tus datos',
              color: Colors.blueGrey,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const Scaffold(
                    body: Center(child: Text('Próximamente'))
                  )))),
          _ItemMenu(
              icon: Icons.gavel,
              titulo: 'Términos de uso',
              subtitulo: 'Reglas de la comunidad',
              color: Colors.blueGrey,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const Scaffold(
                    body: Center(child: Text('Próximamente'))
                  )))),
          _ItemMenu(
              icon: Icons.info_outline,
              titulo: 'Acerca de VENTON PRO',
              subtitulo: 'Versión ${VentonConfig.version}',
              color: Colors.blueGrey,
              onTap: () => _acercaDe(context)),
        ],
      ),
    );
  }

  void _reportarGeneral(BuildContext context) {
    VentonHelpers.openWhatsApp(
        'Hola, quiero reportar contenido inapropiado en VENTON PRO');
  }

  void _acercaDe(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: VentonConfig.appName,
      applicationVersion: VentonConfig.version,
      applicationLegalese:
          '© 2026 VENTON PRO\nMarketplace digital de Santa Rosa de Cabal',
    );
  }
}

class _ItemMenu extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String subtitulo;
  final Color color;
  final VoidCallback onTap;

  const _ItemMenu({
    required this.icon,
    required this.titulo,
    required this.subtitulo,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color)),
      title: Text(titulo,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitulo),
      onTap: onTap,
    );
  }
}

// =============================================================================

class VendedoresPage extends StatelessWidget {
  const VendedoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vendedores VENTON')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6A1B9A), Color(0xFFAB47BC)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Gana plata en cualquier país',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text(
                    'Vende publicidad y café VENTON PRO. Recibe tu plata directo a tu cuenta.',
                    style: TextStyle(color: Colors.white, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Niveles de comisión',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _NivelVendedor(
              nombre: 'BRONCE',
              comision: 25,
              requisito: 'Al registrarte',
              color: const Color(0xFFCD7F32)),
          _NivelVendedor(
              nombre: 'PLATA',
              comision: 30,
              requisito: 'Al traer 5 clientes',
              color: const Color(0xFFC0C0C0)),
          _NivelVendedor(
              nombre: 'ORO',
              comision: 35,
              requisito: 'Al traer 20 clientes',
              color: const Color(0xFFFFD700)),
          const SizedBox(height: 20),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Lo que necesitas para registrarte',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  _Requisito(texto: 'Nombre completo'),
                  _Requisito(texto: 'Dirección'),
                  _Requisito(texto: 'Teléfono / WhatsApp'),
                  _Requisito(
                      texto:
                          'Cuenta bancaria o digital (Nequi, Daviplata, PayPal, Wise)'),
                  _Requisito(texto: 'País'),
                  SizedBox(height: 8),
                  Text('Eso es todo. Sin papeleos complicados.',
                      style: TextStyle(
                          fontStyle: FontStyle.italic, color: Colors.grey)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const VendedorRegistroPage())),
              icon: const Icon(Icons.app_registration),
              label: const Text('Registrarme como vendedor',
                  style: TextStyle(fontSize: 16)),
              style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF6A1B9A),
                  padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
          ),
        ],
      ),
    );
  }
}

class _NivelVendedor extends StatelessWidget {
  final String nombre;
  final int comision;
  final String requisito;
  final Color color;

  const _NivelVendedor({
    required this.nombre,
    required this.comision,
    required this.requisito,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text('$comision%',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
          ),
        ),
        title: Text(nombre,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(requisito),
      ),
    );
  }
}

class _Requisito extends StatelessWidget {
  final String texto;
  const _Requisito({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle,
              size: 18, color: VentonConfig.brandSuccess),
          const SizedBox(width: 8),
          Expanded(child: Text(texto)),
        ],
      ),
    );
  }
}

// =============================================================================

class VendedorRegistroPage extends StatefulWidget {
  const VendedorRegistroPage({super.key});

  @override
  State<VendedorRegistroPage> createState() => _VendedorRegistroPageState();
}

class _VendedorRegistroPageState extends State<VendedorRegistroPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _direccionCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _cuentaCtrl = TextEditingController();
  String _pais = 'Colombia';
  bool _aceptoTerminos = false;
  bool _enviando = false;

  final List<String> _paises = const [
    'Colombia',
    'Estados Unidos',
    'España',
    'México',
    'Argentina',
    'Venezuela',
    'Ecuador',
    'Perú',
    'Chile',
    'Brasil',
    'Otro'
  ];

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _direccionCtrl.dispose();
    _telefonoCtrl.dispose();
    _cuentaCtrl.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_aceptoTerminos) {
      VentonHelpers.mostrarMensaje(
          context, 'Debes aceptar los términos', error: true);
      return;
    }

    setState(() => _enviando = true);

    try {
      final codigoUnico = _generarCodigoUnico();
      await VentonHelpers.logEvent('vendedores_registro', {
        'nombre': _nombreCtrl.text.trim(),
        'direccion': _direccionCtrl.text.trim(),
        'telefono': _telefonoCtrl.text.trim(),
        'cuenta': _cuentaCtrl.text.trim(),
        'pais': _pais,
        'codigo_unico': codigoUnico,
        'nivel': 'BRONCE',
        'comision': 0.25,
        'estado': 'pendiente_revision',
      });

      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: const Text('🎉 Registro recibido'),
          content: Text(
              'Tu código único de vendedor es:\n\n$codigoUnico\n\n'
              'Te contactaremos por WhatsApp para activarte. ¡Bienvenido al equipo VENTON!'),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
                VentonHelpers.openWhatsApp(
                    'Hola, soy ${_nombreCtrl.text}, código $codigoUnico. Acabo de registrarme como vendedor VENTON PRO.');
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) {
        VentonHelpers.mostrarMensaje(context,
            'Error al registrar. Intenta de nuevo.', error: true);
      }
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  String _generarCodigoUnico() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final r = math.Random();
    return 'V-${List.generate(6, (_) => chars[r.nextInt(chars.length)]).join()}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de vendedor')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Solo 5 datos. Sin papeleos.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nombreCtrl,
              decoration: const InputDecoration(
                  labelText: 'Nombre completo',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder()),
              validator: (v) =>
                  (v == null || v.trim().length < 3) ? 'Nombre requerido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _direccionCtrl,
              decoration: const InputDecoration(
                  labelText: 'Dirección',
                  prefixIcon: Icon(Icons.home),
                  border: OutlineInputBorder()),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Dirección requerida' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _telefonoCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                  labelText: 'Teléfono / WhatsApp',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder()),
              validator: (v) =>
                  (v == null || v.trim().length < 7) ? 'Teléfono inválido' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _pais,
              decoration: const InputDecoration(
                  labelText: 'País',
                  prefixIcon: Icon(Icons.public),
                  border: OutlineInputBorder()),
              items: _paises
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (v) => setState(() => _pais = v ?? 'Colombia'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _cuentaCtrl,
              decoration: const InputDecoration(
                  labelText: 'Cuenta para recibir pagos',
                  hintText: 'Ej: Nequi 3001234567 / PayPal correo@ejemplo.com',
                  prefixIcon: Icon(Icons.account_balance),
                  border: OutlineInputBorder()),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Cuenta requerida' : null,
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              value: _aceptoTerminos,
              onChanged: (v) => setState(() => _aceptoTerminos = v ?? false),
              title: const Text('Acepto los términos de uso y la política de privacidad',
                  style: TextStyle(fontSize: 13)),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _enviando ? null : _enviar,
              icon: _enviando
                  ? const SizedBox(
                      width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.check),
              label: Text(_enviando ? 'Enviando...' : 'Enviar registro'),
              style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
          ],
        ),
      ),
    );
  }
}
