import 'package:flutter/material.dart';
import 'cliente_service.dart';
import 'formulario_cliente_page.dart';
import 'modelos/cliente.dart';

class ClientesPage extends StatelessWidget {
  const ClientesPage({super.key});

  @override
  Widget build(BuildContext context) {

    final ClienteService servicio = ClienteService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
      ),

      body: StreamBuilder<List<Cliente>>(
        stream: servicio.obtenerClientes(),

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

          final clientes = snapshot.data ?? [];

          if (clientes.isEmpty) {

            return const Center(
              child: Text(
                'No hay clientes registrados',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(

            itemCount: clientes.length,

            itemBuilder: (context, index) {

              final cliente = clientes[index];

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
                    cliente.nombre,
                  ),

                  subtitle: Text(
                    '${cliente.correo}\n'
                        '${cliente.telefono}',
                  ),

                  isThreeLine: true,

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
                                  FormularioClientePage(
                                    cliente: cliente,
                                  ),
                            ),
                          );
                        },
                      ),

                      // ELIMINAR
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                        ),

                        onPressed: () async {

                          await servicio
                              .eliminarCliente(
                            cliente.id,
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
              const FormularioClientePage(),
            ),
          );
        },

        child: const Icon(Icons.add),
      ),
    );
  }
}