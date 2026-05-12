import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/splash_screen.dart';
import 'core/theme.dart';
import 'core/venton_config.dart';
import 'main_navigation_page.dart';
import 'pages/anunciar_page.dart';
import 'pages/crear_page.dart';
import 'pages/comunidad_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase initialization with error handling
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Firebase initialization failed: $e');
    // App continues even if Firebase fails
  }
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const VentonProApp());
}

class VentonProApp extends StatelessWidget {
  const VentonProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: VentonConfig.appName,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/anunciar': (context) => const AnunciarPage(),
        '/crear': (context) => const CrearPage(),
        '/comunidad': (context) => const ComunidadPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(
            builder: (context) => const MainNavigationPage(),
          );
        }
        return null;
      },
    );
  }
}
