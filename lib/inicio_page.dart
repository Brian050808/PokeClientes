import 'package:flutter/material.dart';
import 'package:proyecto10ids1/Camara_page.dart';
import 'package:proyecto10ids1/clasificacion_page.dart';
import 'package:proyecto10ids1/contactos.dart';
import 'package:proyecto10ids1/login_page.dart';
import 'package:proyecto10ids1/pokemon_page.dart';
import 'clientes_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InicioPage extends StatelessWidget {
  const InicioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [

            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF52ABEB),
                    Color(0xFF63D0A1),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.account_circle,
                    size: 60,
                    color: Colors.white,
                  ),

                  SizedBox(height: 10),

                  Text(
                    'Menú',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Clientes'),
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const ClientesPage(),
                  ),
                );

              },
            ),
            ListTile(
              leading: const Icon(Icons.leaderboard),
              title: const Text('Clasificación'),
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const ClasificacionPage(),
                  ),
                );

              },
            ),
            ListTile(
              leading: const Icon(Icons.catching_pokemon),
              title: const Text('Pokemones'),
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const PokemonPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.contacts),
              title: const Text('Contactos'),
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const Contactos(),
                  ),
                );

              },
            ),
            ListTile(
              leading: const Icon(Icons.qr_code_scanner),
              title: const Text('Camara'),
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const CamaraPage(),
                  ),
                );

              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('sesionIniciada');

                if (!context.mounted) return;

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                      (route) => false,
                );
              },
            ),
          ],
        ),
      ),

      body: const Center(
        child: Text(
          'Bienvenido',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}