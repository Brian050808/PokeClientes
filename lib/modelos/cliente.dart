class Cliente {
  final String id;
  final String nombre;
  final String telefono;
  final String correo;
  final String clasificacion;

  Cliente({
    required this.id,
    required this.nombre,
    required this.telefono,
    required this.correo,
    this.clasificacion = 'Sin clasificación',
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'telefono': telefono,
      'correo': correo,
      'clasificacion': clasificacion,
    };
  }

  factory Cliente.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    return Cliente(
      id: id,
      nombre: map['nombre'] ?? '',
      telefono: map['telefono'] ?? '',
      correo: map['correo'] ?? '',
      clasificacion: map['clasificacion'] ?? 'Sin clasificación',
    );
  }
}