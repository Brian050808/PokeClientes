import 'package:flutter/material.dart';
import 'package:proyecto10ids1/sesion_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MiAplicacion());
}

class MiAplicacion extends StatelessWidget {
  const MiAplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF52ABEB),
        ),
        useMaterial3: true,
      ),
      home: const SesionPage(),
    );
  }
}
