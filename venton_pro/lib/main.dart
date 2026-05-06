import 'package:flutter/material.dart';
import 'core/home_shell.dart';
import 'core/theme.dart';
import 'core/venton_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const HomeShell(),
    );
  }
}
