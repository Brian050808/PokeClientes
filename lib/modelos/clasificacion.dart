class Clasificacion {
  final String id;
  final String nombre;

  Clasificacion({
    required this.id,
    required this.nombre,

  });

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,

    };
  }

  factory Clasificacion.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    return Clasificacion(
      id: id,
      nombre: map['nombre'] ?? '',
    );
  }
}