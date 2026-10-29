import 'app_db.dart';
import 'modelos/cliente.dart';

class ClienteService {
  static const _tabla = 'clientes';

  // CREAR
  Future<void> crearCliente(Cliente cliente) =>
      AppDb.instancia.insertar(_tabla, cliente.toMap());

  // LEER
  Stream<List<Cliente>> obtenerClientes() {
    return AppDb.instancia.observar(_tabla).map((filas) => filas
        .map((f) => Cliente.fromMap(f['id'].toString(), Map<String, dynamic>.from(f)))
        .toList());
  }

  // ACTUALIZAR
  Future<void> actualizarCliente(Cliente cliente) =>
      AppDb.instancia.actualizar(_tabla, cliente.id, cliente.toMap());

  // ELIMINAR
  Future<void> eliminarCliente(String id) =>
      AppDb.instancia.eliminar(_tabla, id);
}
