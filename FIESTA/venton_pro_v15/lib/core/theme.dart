import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tema visual oficial de VENTON PRO.
/// Paleta basada en el escudo: azul marino profundo + bronce premium.
/// Tipografía Poppins para identidad de marca premium.
class AppTheme {
  AppTheme._();

  // Paleta oficial VENTON PRO (extraída del escudo)
  static const Color azulMarino = Color(0xFF0D2849);
  static const Color azulMarinoOscuro = Color(0xFF071A33);
  static const Color azulMarinoClaro = Color(0xFF1A4275);

  static const Color bronce = Color(0xFFB87333);
  static const Color bronceClaro = Color(0xFFD49A5C);
  static const Color bronceOscuro = Color(0xFF8B5A2B);

  static const Color crema = Color(0xFFFAF7F2);
  static const Color whatsappGreen = Color(0xFF25D366);

  // Degradados premium reutilizables
  static const LinearGradient gradienteEscudo = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [azulMarino, azulMarinoOscuro],
  );

  static const LinearGradient gradienteBronce = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [bronceClaro, bronce, bronceOscuro],
  );

  static const LinearGradient gradienteHeader = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [azulMarino, azulMarinoClaro],
  );

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: azulMarino,
      onPrimary: Colors.white,
      primaryContainer: azulMarinoClaro,
      onPrimaryContainer: Colors.white,
      secondary: bronce,
      onSecondary: Colors.white,
      secondaryContainer: bronceClaro,
      onSecondaryContainer: Colors.white,
      tertiary: bronceOscuro,
      onTertiary: Colors.white,
      error: const Color(0xFFB3261E),
      onError: Colors.white,
      surface: isDark ? const Color(0xFF121A26) : crema,
      onSurface: isDark ? Colors.white : azulMarinoOscuro,
      surfaceContainerHighest: isDark
          ? const Color(0xFF1E2733)
          : const Color(0xFFEDE7DC),
      onSurfaceVariant: isDark ? Colors.white70 : azulMarino,
      outline: isDark ? Colors.white24 : Colors.black26,
    );

    final baseTextTheme = GoogleFonts.poppinsTextTheme(
      isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: baseTextTheme.apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          color: colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: azulMarino,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          elevation: 2,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: azulMarino,
          side: const BorderSide(color: bronce, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: bronce, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: GoogleFonts.poppins(fontSize: 14),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 8,
        height: 70,
        backgroundColor: colorScheme.surface,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        indicatorColor: bronce.withOpacity(0.18),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: bronceOscuro,
            );
          }
          return GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface.withOpacity(0.7),
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: bronceOscuro, size: 26);
          }
          return IconThemeData(
            color: colorScheme.onSurface.withOpacity(0.6),
            size: 24,
          );
        }),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shadowColor: azulMarino.withOpacity(0.15),
        color: isDark ? const Color(0xFF1A2433) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: bronce.withOpacity(0.12),
        labelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: bronceOscuro,
        ),
        side: BorderSide.none,
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withOpacity(0.3),
        thickness: 0.5,
      ),
    );
  }
}
