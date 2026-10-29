import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'registro_page.dart';
import 'inicio_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController correoController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  bool ocultarPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF52ABEB),
              Color(0xFF63D0A1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),

            child: Card(
              elevation: 10,

              child: Padding(
                padding: const EdgeInsets.all(25),

                child: Form(
                  key: _formKey,

                  child: Column(
                    children: [

                      // LOGOTIPO
                      const CircleAvatar(
                        radius: 45,
                        backgroundColor: Color(0xFF52ABEB),
                        child: Icon(
                          Icons.lock_person,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Iniciar sesión',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // CORREO
                      TextFormField(
                        controller: correoController,
                        keyboardType:
                        TextInputType.emailAddress,

                        decoration: const InputDecoration(
                          labelText: 'Correo electrónico',
                          hintText: 'ejemplo@correo.com',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),

                        validator: (value) {
                          if (value == null ||
                              value.isEmpty) {
                            return 'Ingresa tu correo electrónico';
                          }

                          final emailRegex = RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          );

                          if (!emailRegex.hasMatch(value)) {
                            return 'Ingresa un correo válido';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // CONTRASEÑA
                      TextFormField(
                        controller: passwordController,
                        obscureText: ocultarPassword,

                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: const Icon(Icons.lock),
                          border: const OutlineInputBorder(),

                          suffixIcon: IconButton(
                            icon: Icon(
                              ocultarPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),

                            onPressed: () {
                              setState(() {
                                ocultarPassword =
                                !ocultarPassword;
                              });
                            },
                          ),
                        ),

                        validator: (value) {
                          if (value == null ||
                              value.isEmpty) {
                            return 'Ingresa tu contraseña';
                          }

                          if (value.length < 6) {
                            return 'La contraseña debe tener al menos 6 caracteres';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 25),

                      // INICIAR SESIÓN
                      SizedBox(
                        width: double.infinity,
                        height: 50,

                        child: ElevatedButton(
                          onPressed: () async {

                            if (_formKey.currentState!.validate()) {

                              try {

                                await AuthService().iniciarSesion(
                                  email: correoController.text.trim(),
                                  password: passwordController.text,
                                );
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.setBool('sesionIniciada', true);
                                if (!mounted) return;
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const InicioPage(),
                                  ),
                                );

                              } on AuthException catch (e) {

                                String mensaje;

                                switch (e.code) {

                                  case 'invalid-credential':
                                    mensaje = 'Correo o contraseña incorrectos.';
                                    break;

                                  case 'invalid-email':
                                    mensaje = 'El correo no es válido.';
                                    break;

                                  case 'user-disabled':
                                    mensaje = 'Esta cuenta está deshabilitada.';
                                    break;

                                  default:
                                    mensaje = 'No se pudo iniciar sesión.';
                                }

                                if (!mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(mensaje),
                                  ),
                                );
                              }
                            }
                          },

                          child: const Text(
                            'Iniciar sesión',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // REGISTRAR
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const RegistroPage(),
                            ),
                          );
                        },

                        child: const Text(
                          '¿No tienes una cuenta? Regístrate',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}