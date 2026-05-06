import 'package:flutter/material.dart';
import '../core/venton_helpers.dart';

class SubirContenidoPage extends StatefulWidget {
  const SubirContenidoPage({super.key});

  @override
  State<SubirContenidoPage> createState() => _SubirContenidoPageState();
}

class _SubirContenidoPageState extends State<SubirContenidoPage> {
  final _formKey = GlobalKey<FormState>();
  final _titulo = TextEditingController();
  final _descripcion = TextEditingController();
  final _enlace = TextEditingController();
  String _tipo = 'Producto';

  @override
  void dispose() {
    _titulo.dispose();
    _descripcion.dispose();
    _enlace.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final mensaje = '''
Hola VENTON PRO, quiero publicar este contenido:

Tipo: $_tipo
Título: ${_titulo.text}
Descripción: ${_descripcion.text}
Enlace/Imagen: ${_enlace.text.isEmpty ? 'Sin enlace' : _enlace.text}
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
      appBar: AppBar(title: const Text('Subir contenido')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tu contenido será revisado por el equipo de VENTON PRO antes de publicarse.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _tipo,
              decoration: const InputDecoration(
                labelText: 'Tipo de contenido',
                prefixIcon: Icon(Icons.category),
              ),
              items: const [
                DropdownMenuItem(value: 'Producto', child: Text('Producto')),
                DropdownMenuItem(value: 'Servicio', child: Text('Servicio')),
                DropdownMenuItem(value: 'Negocio', child: Text('Negocio')),
                DropdownMenuItem(value: 'Turismo', child: Text('Turismo')),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _tipo = v);
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _titulo,
              decoration: const InputDecoration(
                labelText: 'Título',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Requerido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descripcion,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.description),
              ),
              validator: (v) =>
                  (v == null || v.trim().length < 10) ? 'Mínimo 10 caracteres' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _enlace,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'Enlace o imagen (opcional)',
                prefixIcon: Icon(Icons.link),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _enviar,
              icon: const Icon(Icons.send),
              label: const Text('Enviar para revisión'),
            ),
          ],
        ),
      ),
    );
  }
}
