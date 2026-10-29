import 'package:flutter/material.dart';
import 'auth_service.dart';

class RegistroPage extends StatefulWidget {
  const RegistroPage({super.key});

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController nombreController =
  TextEditingController();

  final TextEditingController correoController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  final TextEditingController confirmarPasswordController =
  TextEditingController();

  bool ocultarPassword = true;
  bool ocultarConfirmacion = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear cuenta'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),

        child: Form(
          key: _formKey,

          child: Column(
            children: [

              // ICONO
              const CircleAvatar(
                radius: 40,
                child: Icon(
                  Icons.person_add,
                  size: 45,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Crear una cuenta',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              // NOMBRE
              TextFormField(
                controller: nombreController,

                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),

                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return 'Ingresa tu nombre';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // CORREO
              TextFormField(
                controller: correoController,
                keyboardType:
                TextInputType.emailAddress,

                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),

                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return 'Ingresa tu correo';
                  }

                  final emailRegex = RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  );

                  if (!emailRegex.hasMatch(value)) {
                    return 'Correo electrónico no válido';
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
                    return 'Ingresa una contraseña';
                  }

                  if (value.length < 6) {
                    return 'Mínimo 6 caracteres';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // CONFIRMAR CONTRASEÑA
              TextFormField(
                controller:
                confirmarPasswordController,
                obscureText: ocultarConfirmacion,

                decoration: InputDecoration(
                  labelText: 'Confirmar contraseña',
                  prefixIcon:
                  const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),

                  suffixIcon: IconButton(
                    icon: Icon(
                      ocultarConfirmacion
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),

                    onPressed: () {
                      setState(() {
                        ocultarConfirmacion =
                        !ocultarConfirmacion;
                      });
                    },
                  ),
                ),

                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return 'Confirma tu contraseña';
                  }

                  if (value !=
                      passwordController.text) {
                    return 'Las contraseñas no coinciden';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 25),

              // REGISTRAR
              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  onPressed: () async {

                    if (_formKey.currentState!.validate()) {

                      try {

                        await AuthService().registrar(
                          email: correoController.text.trim(),
                          password: passwordController.text,
                        );

                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Cuenta creada correctamente',
                            ),
                          ),
                        );

                        Navigator.pop(context);

                      } on AuthException catch (e) {

                        String mensaje;

                        switch (e.code) {

                          case 'email-already-in-use':
                            mensaje = 'Este correo ya está registrado.';
                            break;

                          case 'invalid-email':
                            mensaje = 'El correo no es válido.';
                            break;

                          case 'weak-password':
                            mensaje = 'La contraseña es demasiado débil.';
                            break;

                          default:
                            mensaje = 'Error: ${e.code} - ${e.message}';                        }

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
                    'Registrarse',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}