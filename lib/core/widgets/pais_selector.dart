import 'package:flutter/material.dart';
import '../theme.dart';
import '../venton_config.dart';

class PaisSelector extends StatefulWidget {
  final String? paisSeleccionado;
  final Function(String) onPaisChanged;

  const PaisSelector({
    super.key,
    this.paisSeleccionado,
    required this.onPaisChanged,
  });

  @override
  State<PaisSelector> createState() => _PaisSelectorState();
}

class _PaisSelectorState extends State<PaisSelector> {
  String? _paisActual;

  @override
  void initState() {
    super.initState();
    _paisActual = widget.paisSeleccionado;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.bronce.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selecciona tu país:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.bronceOscuro,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _paisActual,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppTheme.bronce.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.bronce),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            hint: const Text('Selecciona un país'),
            items: VentonConfig.mercados.map((pais) {
              return DropdownMenuItem<String>(
                value: pais,
                child: Row(
                  children: [
                    Icon(
                      Icons.flag_rounded,
                      color: AppTheme.bronce,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        pais,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (pais) {
              if (pais != null) {
                setState(() => _paisActual = pais);
                widget.onPaisChanged(pais!);
              }
            },
          ),
        ],
      ),
    );
  }
}
