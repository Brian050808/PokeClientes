import 'package:flutter/material.dart';
import 'modelos/pokemon.dart';

class PokemonDetallePage extends StatelessWidget {

  final Pokemon pokemon;

  const PokemonDetallePage({
    super.key,
    required this.pokemon,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          pokemon.nombre.toUpperCase(),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            Image.network(
              pokemon.imagen,
              width: 200,
              height: 200,
            ),

            Text(
              pokemon.nombre.toUpperCase(),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tipos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Wrap(
              spacing: 8,

              children: pokemon.tipos.map(
                    (tipo) {
                  return Chip(
                    label: Text(
                      tipo.toUpperCase(),
                    ),
                  );
                },
              ).toList(),
            ),

            const SizedBox(height: 20),

            Card(
              child: Column(
                children: [

                  ListTile(
                    leading:
                    const Icon(Icons.height),
                    title: const Text('Altura'),
                    subtitle: Text(
                      '${pokemon.altura / 10} metros',
                    ),
                  ),

                  ListTile(
                    leading:
                    const Icon(Icons.monitor_weight),
                    title: const Text('Peso'),
                    subtitle: Text(
                      '${pokemon.peso / 10} kg',
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Habilidades',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            ...pokemon.habilidades.map(
                  (habilidad) {
                return ListTile(
                  leading:
                  const Icon(Icons.flash_on),
                  title: Text(
                    habilidad.toUpperCase(),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Estadísticas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            ...pokemon.estadisticas.map(
                  (estadistica) {
                return ListTile(
                  title: Text(
                    estadistica.nombre
                        .toUpperCase(),
                  ),

                  trailing: Text(
                    estadistica.valor.toString(),
                    style: const TextStyle(
                      fontWeight:
                      FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}