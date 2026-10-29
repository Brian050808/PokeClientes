import 'dart:convert';
import 'package:http/http.dart' as http;
import 'modelos/pokemon.dart';

class PokemonService {

  final String url =
      'https://pokeapi.co/api/v2/pokemon';

  Future<List<Pokemon>> obtenerPokemones() async {

    final respuesta = await http.get(
      Uri.parse('$url?limit=50'),
    );

    if (respuesta.statusCode != 200) {
      throw Exception(
        'No se pudieron obtener los Pokémon',
      );
    }

    final datos = jsonDecode(respuesta.body);

    final resultados = datos['results'] as List;

    List<Pokemon> pokemones = [];

    for (var pokemon in resultados) {

      final detalle = await http.get(
        Uri.parse(pokemon['url']),
      );

      if (detalle.statusCode == 200) {
        final datosPokemon =
        jsonDecode(detalle.body);

        pokemones.add(
          Pokemon.fromMap(datosPokemon),
        );
      }
    }

    return pokemones;
  }
}