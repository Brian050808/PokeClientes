class Pokemon {
  final int id;
  final String nombre;
  final String imagen;
  final List<String> tipos;
  final int altura;
  final int peso;
  final List<String> habilidades;
  final List<EstadisticaPokemon> estadisticas;

  Pokemon({
    required this.id,
    required this.nombre,
    required this.imagen,
    required this.tipos,
    required this.altura,
    required this.peso,
    required this.habilidades,
    required this.estadisticas,
  });

  factory Pokemon.fromMap(Map<String, dynamic> map) {
    return Pokemon(
      id: map['id'],
      nombre: map['name'],
      imagen: map['sprites']['front_default'] ?? '',
      tipos: (map['types'] as List)
          .map((tipo) => tipo['type']['name'].toString())
          .toList(),
      altura: map['height'],
      peso: map['weight'],
      habilidades: (map['abilities'] as List)
          .map((habilidad) =>
          habilidad['ability']['name'].toString())
          .toList(),
      estadisticas: (map['stats'] as List)
          .map((estadistica) =>
          EstadisticaPokemon.fromMap(estadistica))
          .toList(),
    );
  }
}

class EstadisticaPokemon {
  final String nombre;
  final int valor;

  EstadisticaPokemon({
    required this.nombre,
    required this.valor,
  });

  factory EstadisticaPokemon.fromMap(
      Map<String, dynamic> map) {
    return EstadisticaPokemon(
      nombre: map['stat']['name'],
      valor: map['base_stat'],
    );
  }
}