import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Chat de comunidad en tiempo real, guardado en Firestore (gratis).
/// Colección 'comunidad' con campos: usuario, mensaje, fecha.
class PaginaComunidad extends StatefulWidget {
  const PaginaComunidad({super.key});
  @override
  State<PaginaComunidad> createState() => _PaginaComunidadState();
}

class _PaginaComunidadState extends State<PaginaComunidad> {
  final _texto = TextEditingController();
  final _coleccion = FirebaseFirestore.instance.collection('comunidad');
  String _usuario = 'Invitado';

  @override
  void initState() {
    super.initState();
    _cargarUsuario();
  }

  Future<void> _cargarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _usuario = prefs.getString('nombre_usuario') ?? 'Invitado');
  }

  Future<void> _enviar() async {
    final msg = _texto.text.trim();
    if (msg.isEmpty) return;
    _texto.clear();
    await _coleccion.add({
      'usuario': _usuario,
      'mensaje': msg,
      'fecha': FieldValue.serverTimestamp(),
    });
  }

  @override
  void dispose() {
    _texto.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comunidad VENTON PRO'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  _coleccion.orderBy('fecha', descending: true).snapshots(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snap.data!.docs;
                if (docs.isEmpty) {
                  return const Center(
                    child: Text('Sé el primero en escribir 👋'),
                  );
                }
                return ListView.builder(
                  reverse: true,
                  itemCount: docs.length,
                  itemBuilder: (_, i) {
                    final d = docs[i].data() as Map<String, dynamic>;
                    return ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(
                        d['usuario']?.toString() ?? 'Invitado',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(d['mensaje']?.toString() ?? ''),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _texto,
                      decoration: const InputDecoration(
                        hintText: 'Escribe un mensaje...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: _enviar,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
