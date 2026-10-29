import 'package:flutter/material.dart';
import 'pokemon_service.dart';
import 'modelos/pokemon.dart';
import 'pokemon_detalle_page.dart';

class PokemonPage extends StatefulWidget {
  const PokemonPage({super.key});

  @override
  State<PokemonPage> createState() =>
      _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {

  final PokemonService pokemonService =
  PokemonService();

  late Future<List<Pokemon>> pokemones;

  @override
  void initState() {
    super.initState();

    pokemones =
        pokemonService.obtenerPokemones();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('APIs REST Pokémon'),
      ),

      body: FutureBuilder<List<Pokemon>>(
        future: pokemones,

        builder: (context, snapshot) {

          // CARGANDO
          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // ERROR
          if (snapshot.hasError) {

            return Center(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [

                  const Icon(
                    Icons.error_outline,
                    size: 60,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'No se pudieron cargar los Pokémon',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {

                      setState(() {
                        pokemones =
                            pokemonService
                                .obtenerPokemones();
                      });

                    },

                    child: const Text(
                      'Reintentar',
                    ),
                  ),
                ],
              ),
            );
          }

          final lista =
              snapshot.data ?? [];

          if (lista.isEmpty) {
            return const Center(
              child: Text(
                'No hay Pokémon disponibles',
              ),
            );
          }

          // LISTA
          return ListView.builder(

            itemCount: lista.length,

            itemBuilder: (context, index) {

              final pokemon =
              lista[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),

                child: ListTile(

                  leading: Image.network(
                    pokemon.imagen,
                    width: 70,
                    height: 70,
                  ),

                  title: Text(
                    pokemon.nombre
                        .toUpperCase(),
                    style: const TextStyle(
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  subtitle: Text(
                    'Tipo: ${pokemon.tipos.join(', ')}',
                  ),

                  trailing:
                  const Icon(
                    Icons.arrow_forward_ios,
                  ),

                  onTap: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PokemonDetallePage(
                              pokemon: pokemon,
                            ),
                      ),
                    );

                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}