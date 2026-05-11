import 'package:flutter/material.dart';
import 'turismo_page.dart';
import 'negocios_page.dart';
import 'vendedores_page.dart';
import 'quimicos_page.dart';
import 'ruleta_page.dart';
import 'politica_page.dart';
import 'terminos_page.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  int _indice = 0;

  static const Color _negro = Color(0xFF0A0A0A);
  static const Color _dorado = Color(0xFFD4AF37);
  static const Color _grafito = Color(0xFF1A1A1A);

  late final List<Widget> _paginas = [
    _HomeInicio(onIrA: (i) => setState(() => _indice = i)),
    const TurismoPage(),
    const NegociosPage(),
    const VendedoresPage(),
    const RuletaPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _negro,
      body: IndexedStack(index: _indice, children: _paginas),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: _grafito,
          border: Border(top: BorderSide(color: _dorado, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _indice,
          onTap: (i) => setState(() => _indice = i),
          backgroundColor: _grafito,
          selectedItemColor: _dorado,
          unselectedItemColor: Colors.white54,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Inicio'),
            BottomNavigationBarItem(icon: Icon(Icons.travel_explore_rounded), label: 'Turismo'),
            BottomNavigationBarItem(icon: Icon(Icons.store_mall_directory_rounded), label: 'Negocios'),
            BottomNavigationBarItem(icon: Icon(Icons.handshake_rounded), label: 'Vendedores'),
            BottomNavigationBarItem(icon: Icon(Icons.casino_rounded), label: 'Ruleta'),
          ],
        ),
      ),
    );
  }
}

class _HomeInicio extends StatelessWidget {
  final void Function(int) onIrA;
  const _HomeInicio({required this.onIrA});

  static const Color _negro = Color(0xFF0A0A0A);
  static const Color _dorado = Color(0xFFD4AF37);
  static const Color _grafito = Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _negro,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Text('VENTON PRO',
                style: TextStyle(color: _dorado, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 3)),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text('Tu negocio, tus clientes, directo',
                style: TextStyle(color: Colors.white70, fontSize: 13, letterSpacing: 1)),
            ),
            const SizedBox(height: 36),
            _tarjeta(context, 'Turismo', 'Hoteles y experiencias en Santa Rosa', Icons.travel_explore_rounded, () => onIrA(1)),
            const SizedBox(height: 14),
            _tarjeta(context, 'Negocios', 'Directorio de comercios locales', Icons.store_mall_directory_rounded, () => onIrA(2)),
            const SizedBox(height: 14),
            _tarjeta(context, 'Vendedores', 'Conecta con vendedores VENTON', Icons.handshake_rounded, () => onIrA(3)),
            const SizedBox(height: 14),
            _tarjeta(context, 'Químicos Premium', 'Línea profesional VENTON', Icons.science_rounded, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const QuimicosPage()));
            }),
            const SizedBox(height: 14),
            _tarjeta(context, 'Ruleta de Premios', 'Gira y gana descuentos', Icons.casino_rounded, () => onIrA(4)),
            const SizedBox(height: 36),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PoliticaPage())),
                  child: const Text('Privacidad', style: TextStyle(color: Colors.white38, fontSize: 11)),
                ),
                const Text('·', style: TextStyle(color: Colors.white38)),
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TerminosPage())),
                  child: const Text('Términos', style: TextStyle(color: Colors.white38, fontSize: 11)),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _tarjeta(BuildContext ctx, String titulo, String sub, IconData icono, VoidCallback onTap) {
    return Material(
      color: _grafito,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _dorado.withOpacity(0.3), width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _dorado.withOpacity(0.15),
                ),
                child: Icon(icono, color: _dorado, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titulo, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(sub, style: const TextStyle(color: Colors.white60, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: _dorado),
            ],
          ),
        ),
      ),
    );
  }
}
