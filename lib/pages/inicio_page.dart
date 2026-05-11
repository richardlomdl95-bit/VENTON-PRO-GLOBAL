import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'turismo_page.dart';
import 'turismo_mapa_page.dart';
import 'comunidad_page.dart';
import 'mas_page.dart';
import 'subir_contenido_page.dart';
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
  String _paisSeleccionado = 'Selecciona un país';

  static const Color _crema = Color(0xFFFFF8E7);
  static const Color _azulOscuro = Color(0xFF0F1B3D);
  static const Color _dorado = Color(0xFFD4AF37);
  static const Color _naranja = Color(0xFFFF6B35);
  static const Color _verde = Color(0xFF25D366);
  static const Color _negro = Color(0xFF0A0A0A);
  static const Color _grafito = Color(0xFF1A1A1A);

  final List<String> _paises = const [
    'Selecciona un país',
    'Colombia',
    'Venezuela',
    'España',
    'Estados Unidos',
  ];

  late final List<Widget> _paginas = [
    _construirHome(),
    const TurismoPage(),
    const SizedBox.shrink(),
    const ComunidadPage(),
    const MasPage(),
  ];

  Future<void> _abrirWhatsApp() async {
    final url = Uri.parse(
      'https://wa.me/573225609121?text=Hola%20quiero%20anunciar%20en%20VENTON%20PRO',
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir WhatsApp')),
        );
      }
    }
  }

  void _abrirSubir() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SubirContenidoPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _negro,
      body: IndexedStack(index: _indice, children: _paginas),
      bottomNavigationBar: _construirBottomNav(),
    );
  }

  Widget _construirBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: _grafito,
        border: Border(top: BorderSide(color: _dorado, width: 0.5)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _tabItem(0, Icons.home_rounded, 'Inicio'),
          _tabItem(1, Icons.travel_explore_rounded, 'Turismo'),
          _tabSubir(),
          _tabItem(3, Icons.groups_rounded, 'Comunidad'),
          _tabItem(4, Icons.apps_rounded, 'Más'),
        ],
      ),
    );
  }

  Widget _tabItem(int idx, IconData icon, String label) {
    final activo = _indice == idx;
    return GestureDetector(
      onTap: () => setState(() => _indice = idx),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: activo ? _dorado : Colors.white54, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: activo ? _dorado : Colors.white54,
                fontSize: 11,
                fontWeight: activo ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabSubir() {
    return GestureDetector(
      onTap: _abrirSubir,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE8C547), _dorado],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: _dorado.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }

  Widget _construirHome() {
    return Scaffold(
      backgroundColor: _crema,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: FloatingActionButton.extended(
          onPressed: _abrirWhatsApp,
          backgroundColor: _verde,
          icon: const Icon(Icons.campaign, color: Colors.white),
          label: const Text(
            'Anunciar por WhatsApp',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _construirHeader(),
              _construirSelectorPais(),
              const SizedBox(height: 16),
              _construirStories(),
              const SizedBox(height: 12),
              _construirCarrusel(),
              const SizedBox(height: 12),
              _construirTarjetaRuleta(),
              const SizedBox(height: 12),
              _construirFooterLegal(),
              const SizedBox(height: 110),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_azulOscuro, Color(0xFF2D5016)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
      child: Column(
        children: const [
          Text(
            '🌎  VENTON PRO GLOBAL',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Publicidad, negocios, turismo y comunidad en\nColombia, Venezuela, España y Estados Unidos.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _construirSelectorPais() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selecciona tu país:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _azulOscuro),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              border: Border.all(color: _dorado, width: 1.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _paisSeleccionado,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: _dorado),
                items: _paises.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                onChanged: (v) => setState(() => _paisSeleccionado = v ?? _paises[0]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirStories() {
    final stories = <Map<String, dynamic>>[
      {'icon': Icons.add_circle, 'label': 'Publicar', 'onTap': _abrirSubir},
      {'icon': Icons.workspace_premium, 'label': 'VENTON PRO', 'onTap': () {}},
      {'icon': Icons.landscape, 'label': 'Turismo', 'onTap': () => setState(() => _indice = 1)},
      {'icon': Icons.science, 'label': 'Químicos', 'onTap': () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const QuimicosPage()));
      }},
      {'icon': Icons.map, 'label': 'Mapa', 'onTap': () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const TurismoMapaPage()));
      }},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Stories',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _azulOscuro),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: stories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (_, i) {
                final s = stories[i];
                return GestureDetector(
                  onTap: s['onTap'] as VoidCallback,
                  child: Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _dorado.withOpacity(0.85),
                          border: Border.all(color: _dorado, width: 2),
                        ),
                        child: Icon(s['icon'] as IconData, color: Colors.white, size: 32),
                      ),
                      const SizedBox(height: 6),
                      Text(s['label'] as String, style: const TextStyle(fontSize: 12, color: _azulOscuro)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirCarrusel() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF8C42), _naranja],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.local_fire_department, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🔥 Mira gratis. Comparte.',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Cuando quieras crecer, anuncia con nosotros',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirTarjetaRuleta() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.casino, color: _azulOscuro, size: 56),
          const SizedBox(height: 8),
          const Text(
            '🎰 RULETA VENTON',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _azulOscuro),
          ),
          const SizedBox(height: 6),
          const Text(
            'Gira y gana descuentos en productos VENTON',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const RuletaPage()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _dorado,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'GIRAR',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirFooterLegal() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PoliticaPage())),
            child: const Text('Privacidad', style: TextStyle(color: Colors.black45, fontSize: 11)),
          ),
          const Text('·', style: TextStyle(color: Colors.black45)),
          TextButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TerminosPage())),
            child: const Text('Términos', style: TextStyle(color: Colors.black45, fontSize: 11)),
          ),
        ],
      ),
    );
  }
}
