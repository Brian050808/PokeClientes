import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'inicio_page.dart';
import 'login_page.dart'; // Cambia el nombre si tu login tiene otro archivo.

class SesionPage extends StatefulWidget {
  const SesionPage({super.key});

  @override
  State<SesionPage> createState() => _SesionPageState();
}

class _SesionPageState extends State<SesionPage> {
  bool? sesionIniciada;

  @override
  void initState() {
    super.initState();
    verificarSesion();
  }

  Future<void> verificarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    final iniciada = prefs.getBool('sesionIniciada') ?? false;

    if (!mounted) return;

    setState(() {
      sesionIniciada = iniciada;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (sesionIniciada == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (sesionIniciada!) {
      return const InicioPage();
    }

    return const LoginPage();
  }
}