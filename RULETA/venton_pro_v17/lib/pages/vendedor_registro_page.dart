import 'package:flutter/material.dart';
import '../core/venton_helpers.dart';

class VendedorRegistroPage extends StatefulWidget {
  const VendedorRegistroPage({super.key});

  @override
  State<VendedorRegistroPage> createState() => _VendedorRegistroPageState();
}

class _VendedorRegistroPageState extends State<VendedorRegistroPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _ciudad = TextEditingController();
  final _experiencia = TextEditingController();
  final _telefono = TextEditingController();
  String _mercado = 'Colombia';

  @override
  void dispose() {
    _nombre.dispose();
    _ciudad.dispose();
    _experiencia.dispose();
    _telefono.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final mensaje = '''
Hola VENTON PRO, quiero registrarme como vendedor:

Nombre: ${_nombre.text}
Ciudad: ${_ciudad.text}
País/Mercado: $_mercado
Teléfono: ${_telefono.text}
Experiencia: ${_experiencia.text}
''';

    final ok = await VentonHelpers.abrirWhatsApp(mensaje: mensaje);
    if (!mounted) return;
    if (!ok) {
      VentonHelpers.mostrarSnack(
        context,
        'No se pudo abrir WhatsApp. Verificá que esté instalado.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ser vendedor VENTON')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Unite a la red de vendedores de VENTON PRO. Productos premium, comisiones competitivas, soporte completo.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nombre,
              decoration: const InputDecoration(
                labelText: 'Nombre completo',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Requerido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _ciudad,
              decoration: const InputDecoration(
                labelText: 'Ciudad',
                prefixIcon: Icon(Icons.location_city),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Requerido' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _mercado,
              decoration: const InputDecoration(
                labelText: 'País / Mercado',
                prefixIcon: Icon(Icons.public),
              ),
              items: const [
                DropdownMenuItem(value: 'Colombia', child: Text('Colombia')),
                DropdownMenuItem(value: 'USA', child: Text('USA')),
                DropdownMenuItem(value: 'Venezuela', child: Text('Venezuela')),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _mercado = v);
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _telefono,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Teléfono / WhatsApp',
                prefixIcon: Icon(Icons.phone),
              ),
              validator: (v) =>
                  (v == null || v.trim().length < 7) ? 'Teléfono inválido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _experiencia,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Experiencia en ventas',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.work_outline),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _enviar,
              icon: const Icon(Icons.chat),
              label: const Text('Enviar por WhatsApp'),
            ),
          ],
        ),
      ),
    );
  }
}
