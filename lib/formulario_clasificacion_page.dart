import 'package:flutter/material.dart';
import 'modelos/clasificacion.dart';
import 'clasificacion_service.dart';

class FormularioClasificacionPage extends StatefulWidget {
  final Clasificacion? clasificacion;

  const FormularioClasificacionPage({
    super.key,
    this.clasificacion,
  });

  @override
  State<FormularioClasificacionPage> createState() =>
      _FormularioClasificacionPageState();
}

class _FormularioClasificacionPageState
    extends State<FormularioClasificacionPage> {

  final _formKey = GlobalKey<FormState>();

  final nombreController = TextEditingController();

  final ClasificacionService clasificacionService = ClasificacionService();

  @override
  void initState() {
    super.initState();

    if (widget.clasificacion != null) {
      nombreController.text = widget.clasificacion!.nombre;
    }
  }

  @override
  void dispose() {
    nombreController.dispose();
    super.dispose();
  }

  Future<void> guardarClasificacion() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (widget.clasificacion == null) {

      // CREAR
      final clasificacion = Clasificacion(
        id: '',
        nombre: nombreController.text.trim(),
      );

      await clasificacionService.crearClasificacion(clasificacion);

    } else {

      // ACTUALIZAR
      final clasificacion = Clasificacion(
        id: widget.clasificacion!.id,
        nombre: nombreController.text.trim(),
      );

      await clasificacionService.actualizarClasificacion(clasificacion);
    }

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    final editando = widget.clasificacion != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          editando
              ? 'Editar clasificacion'
              : 'Nueva clasificacion',
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
                  labelText: 'Nombre de clasificacion',
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


              const SizedBox(height: 20),


              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  onPressed: guardarClasificacion,

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