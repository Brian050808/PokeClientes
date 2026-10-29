import 'package:flutter/material.dart';
import 'modelos/cliente.dart';
import 'cliente_service.dart';
import 'modelos/clasificacion.dart';
import 'clasificacion_service.dart';

class FormularioClientePage extends StatefulWidget {
  final Cliente? cliente;

  const FormularioClientePage({
    super.key,
    this.cliente,
  });

  @override
  State<FormularioClientePage> createState() =>
      _FormularioClientePageState();
}

class _FormularioClientePageState
    extends State<FormularioClientePage> {

  final _formKey = GlobalKey<FormState>();

  final nombreController = TextEditingController();
  final telefonoController = TextEditingController();
  final correoController = TextEditingController();

  final ClienteService clienteService = ClienteService();
  final ClasificacionService clasificacionService =
  ClasificacionService();

  String clasificacionSeleccionada = 'Sin clasificación';

  @override
  void initState() {
    super.initState();

    if (widget.cliente != null) {
      nombreController.text = widget.cliente!.nombre;
      telefonoController.text = widget.cliente!.telefono;
      correoController.text = widget.cliente!.correo;

      clasificacionSeleccionada =
          widget.cliente!.clasificacion;
    }
  }

  @override
  void dispose() {
    nombreController.dispose();
    telefonoController.dispose();
    correoController.dispose();
    super.dispose();
  }

  Future<void> guardarCliente() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final cliente = Cliente(
      id: widget.cliente?.id ?? '',
      nombre: nombreController.text.trim(),
      telefono: telefonoController.text.trim(),
      correo: correoController.text.trim(),
      clasificacion: clasificacionSeleccionada,
    );

    if (widget.cliente == null) {
      await clienteService.crearCliente(cliente);
    } else {
      await clienteService.actualizarCliente(cliente);
    }

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    final editando = widget.cliente != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          editando
              ? 'Editar cliente'
              : 'Nuevo cliente',
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            children: [

              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa el nombre';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: telefonoController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa el teléfono';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: correoController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa el correo';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // CLASIFICACIÓN
              StreamBuilder<List<Clasificacion>>(
                stream: clasificacionService.obtenerClasificacion(),
                builder: (context, snapshot) {

                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Text(
                      'Error al cargar las clasificaciones',
                    );
                  }

                  final clasificaciones =
                      snapshot.data ?? [];

                  return DropdownButtonFormField<String>(
                    value: clasificacionSeleccionada,

                    decoration: const InputDecoration(
                      labelText: 'Clasificación',
                      prefixIcon: Icon(Icons.category),
                      border: OutlineInputBorder(),
                    ),

                    items: [
                      const DropdownMenuItem<String>(
                        value: 'Sin clasificación',
                        child: Text('Sin clasificación'),
                      ),

                      ...clasificaciones.map((clasificacion) {
                        return DropdownMenuItem<String>(
                          value: clasificacion.nombre,
                          child: Text(clasificacion.nombre),
                        );
                      }),
                    ],

                    onChanged: (valor) {
                      if (valor != null) {
                        setState(() {
                          clasificacionSeleccionada = valor;
                        });
                      }
                    },
                  );
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  onPressed: guardarCliente,

                  child: Text(
                    editando
                        ? 'Actualizar'
                        : 'Guardar',
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