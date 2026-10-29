import 'package:flutter/material.dart';
import 'clasificacion_service.dart';
import 'formulario_clasificacion_page.dart';
import 'modelos/clasificacion.dart';

class ClasificacionPage extends StatelessWidget {
  const ClasificacionPage({super.key});

  @override
  Widget build(BuildContext context) {

    final ClasificacionService servicio = ClasificacionService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clasificacion'),
      ),

      body: StreamBuilder<List<Clasificacion>>(
        stream: servicio.obtenerClasificacion(),

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {

            return Center(
              child: Text(
                'Error: ${snapshot.error}',
              ),
            );
          }

          final clasificaciones = snapshot.data ?? [];

          if (clasificaciones.isEmpty) {

            return const Center(
              child: Text(
                'No hay clasificaciones registrados',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(

            itemCount: clasificaciones.length,

            itemBuilder: (context, index) {

              final clasificacion = clasificaciones[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),

                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),

                  title: Text(
                    clasificacion.nombre,
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [

                      // EDITAR
                      IconButton(
                        icon: const Icon(Icons.edit),

                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FormularioClasificacionPage(
                                    clasificacion: clasificacion,
                                  ),
                            ),
                          );
                        },
                      ),

                      // ELIMINAR
                      IconButton(
                        icon: const Icon(Icons.delete),

                        onPressed: () async {
                          await servicio.eliminarClasificacion(
                            clasificacion.id,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      // CREAR
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
              const FormularioClasificacionPage(),
            ),
          );
        },

        child: const Icon(Icons.add),
      ),
    );
  }
}