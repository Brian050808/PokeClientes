import 'app_db.dart';
import 'modelos/clasificacion.dart';

class ClasificacionService {
  static const _tabla = 'clasificaciones';

  // CREAR
  Future<void> crearClasificacion(Clasificacion clasificacion) =>
      AppDb.instancia.insertar(_tabla, clasificacion.toMap());

  // LEER
  Stream<List<Clasificacion>> obtenerClasificacion() {
    return AppDb.instancia.observar(_tabla).map((filas) => filas
        .map((f) => Clasificacion.fromMap(
            f['id'].toString(), Map<String, dynamic>.from(f)))
        .toList());
  }

  // ACTUALIZAR
  Future<void> actualizarClasificacion(Clasificacion clasificacion) =>
      AppDb.instancia.actualizar(_tabla, clasificacion.id, clasificacion.toMap());

  // ELIMINAR
  Future<void> eliminarClasificacion(String id) =>
      AppDb.instancia.eliminar(_tabla, id);
}
