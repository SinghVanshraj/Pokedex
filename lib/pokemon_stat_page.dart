import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inner_shadow_widget/inner_shadow_widget.dart';
import 'package:pokedex/pokemon_stat.dart';

class PokemonStatPage extends StatefulWidget {
  final String name;
  const PokemonStatPage({super.key, required this.name});

  @override
  State<PokemonStatPage> createState() => _PokemonStatPageState();
}

class _PokemonStatPageState extends State<PokemonStatPage> {
  late Future<Map<String, dynamic>> pokemon1;

  Future<Map<String, dynamic>> getpokemon1(String name) async {
    try {
      final res = await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon/${name.toString()}'),
      );

      if (res.statusCode != 200) {
        throw 'Failed to load Pokémon. Status code: ${res.statusCode}';
      }

      final data = jsonDecode(res.body);

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    pokemon1 = getpokemon1(widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      //body
      body: SafeArea(
        child: FutureBuilder(
          future: pokemon1,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: const CircularProgressIndicator.adaptive());
            }

            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            final data = snapshot.data!;
            final result = data;
            final List type = result['types'] ?? [];
            final pokemonName = result['name'];
            final number = result['id'];
            final pokemonPicture =
                (result['sprites']['front_default']).toString().isNotEmpty
                ? (result['sprites']['front_default']).toString()
                : (result['sprites']['back_default']).toString().isNotEmpty
                ? (result['sprites']['back_default']).toString()
                : (result['sprites']['front_shiny']).toString().isNotEmpty
                ? (result['sprites']['front_shiny']).toString()
                : (result['sprites']['back_shiny']).toString();
            final pokemonType1 = result['types'][0]['type']['name'];
            final pokemonType2 = type.length > 1
                ? result['types'][1]['type']['name']
                : 'none';
            final pokemonWeight = result['weight'];
            final pokemonHeight = result['height'];

            //Background Color Main
            Color getmaincard(String v) {
              if (v.toString().toLowerCase() == 'fire') {
                return Colors.red;
              } else if (v.toString().toLowerCase() == 'water') {
                return Colors.blue;
              } else if (v.toString().toLowerCase() == 'grass') {
                return Colors.green;
              } else if (v.toString().toLowerCase() == 'electric') {
                return Colors.yellow;
              } else if (v.toString().toLowerCase() == 'normal') {
                return Colors.grey;
              } else if (v.toString().toLowerCase() == 'bug') {
                return Colors.lime.shade800;
              } else if (v.toString().toLowerCase() == 'ghost') {
                return Colors.deepPurple;
              } else if (v.toString().toLowerCase() == 'rock') {
                return Colors.lime.shade800;
              } else if (v.toString().toLowerCase() == 'ground') {
                return Colors.yellow.shade700;
              } else if (v.toString().toLowerCase() == 'poison') {
                return Colors.purple.shade900;
              } else if (v.toString().toLowerCase() == 'fairy') {
                return Colors.pinkAccent.shade100;
              } else if (v.toString().toLowerCase() == 'ice') {
                return Colors.cyanAccent.shade100;
              } else if (v.toString().toLowerCase() == 'dark') {
                return Colors.brown;
              } else if (v.toString().toLowerCase() == 'steel') {
                return Colors.grey.shade400;
              } else if (v.toString().toLowerCase() == 'flying') {
                return const Color.fromARGB(255, 177, 150, 252);
              } else if (v.toString().toLowerCase() == 'fighting') {
                return const Color.fromARGB(255, 213, 92, 48);
              } else if (v.toString().toLowerCase() == 'dragon') {
                return Colors.purple;
              } else if (v.toString().toLowerCase() == 'psychic') {
                return Colors.pink;
              } else {
                return Colors.blueGrey;
              }
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: getmaincard(pokemonType1.toString().toLowerCase()),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(
                                Icons.arrow_back_rounded,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              pokemonName
                                      .toString()
                                      .substring(0, 1)
                                      .toUpperCase() +
                                  pokemonName.toString().substring(
                                    1,
                                    pokemonName.toString().length,
                                  ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            number.toString().length == 5
                                ? number.toString()
                                : number.toString().length == 4
                                ? "#0${number.toString()}"
                                : number.toString().length == 3
                                ? "#00${number.toString()}"
                                : number.toString().length == 2
                                ? '#000${number.toString()}'
                                : '#0000${number.toString()}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadiusGeometry.directional(
                      topStart: Radius.zero,
                      topEnd: Radius.zero,
                      bottomStart: Radius.circular(40),
                      bottomEnd: Radius.circular(40),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: getmaincard(
                          pokemonType1.toString().toLowerCase(),
                        ),
                      ),
                      height: 250,
                      width: double.infinity,
                      child: Column(
                        children: [
                          Image.network(
                            pokemonPicture,
                            height: 190,
                            width: double.infinity,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // name
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          pokemonName.toString().substring(0, 1).toUpperCase() +
                              pokemonName.toString().substring(
                                1,
                                pokemonName.toString().length,
                              ),
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ],
                    ),
                  ),
                  // Type
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Card(
                        color: getmaincard(pokemonType1.toString()),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Container(
                          height: 50,
                          width: 100,
                          alignment: Alignment.center,
                          child: Text(
                            pokemonType1
                                    .toString()
                                    .substring(0, 1)
                                    .toUpperCase() +
                                pokemonType1.toString().substring(
                                  1,
                                  pokemonType1.toString().length,
                                ),
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        color: getmaincard(pokemonType2.toString()),
                        child: Container(
                          height: 50,
                          width: 100,
                          alignment: Alignment.center,
                          child: Text(
                            pokemonType2
                                    .toString()
                                    .substring(0, 1)
                                    .toUpperCase() +
                                pokemonType2.toString().substring(
                                  1,
                                  pokemonType2.toString().length,
                                ),
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //Physical Weight and Height
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 100,
                        width: 140,
                        child: Card(
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${(pokemonWeight / 10)} Kg',
                                style: const TextStyle(
                                  fontSize: 32,
                                  color: Colors.white,
                                ),
                              ),
                              const Icon(
                                Icons.monitor_weight,
                                color: Colors.white,
                                size: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 100,
                        width: 140,
                        child: Card(
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${(pokemonHeight / 10)} M',
                                style: const TextStyle(
                                  fontSize: 32,
                                  color: Colors.white,
                                ),
                              ),
                              const Icon(
                                Icons.height,
                                color: Colors.white,
                                size: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    height: 100,
                    width: double.infinity,
                    child: InnerShadow(
                      color: getmaincard(pokemonType1.toString()),
                      child: Card(
                        color: Colors.black26,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 25.0),
                              child: const Text(
                                'Base Experience',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 25.0),
                              child: Text(
                                result['base_experience'].toString(),
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      color: Colors.white24,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            'Base Stat',
                            style: TextStyle(
                              fontSize: 32,
                              color: getmaincard(pokemonType1.toString()),
                            ),
                          ),
                          const SizedBox(height: 10),
                          PokemonStat(
                            category: 'HP ',
                            val: double.parse(
                              result['stats'][0]['base_stat'].toString(),
                            ),
                            color: Colors.red,
                          ),
                          const SizedBox(height: 10),
                          PokemonStat(
                            category: 'ATK',
                            val: double.parse(
                              result['stats'][1]['base_stat'].toString(),
                            ),
                            color: Colors.yellow,
                          ),
                          const SizedBox(height: 10),
                          PokemonStat(
                            category: 'DEF',
                            val: double.parse(
                              result['stats'][2]['base_stat'].toString(),
                            ),
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 10),
                          PokemonStat(
                            category: 'SLA',
                            val: double.parse(
                              result['stats'][3]['base_stat'].toString(),
                            ),
                            color: Colors.redAccent.shade400,
                          ),
                          const SizedBox(height: 10),
                          PokemonStat(
                            category: 'SLD',
                            val: double.parse(
                              result['stats'][4]['base_stat'].toString(),
                            ),
                            color: Colors.blueAccent.shade400,
                          ),
                          const SizedBox(height: 10),
                          PokemonStat(
                            category: 'SPD',
                            val: double.parse(
                              result['stats'][5]['base_stat'].toString(),
                            ),
                            color: Colors.lightBlueAccent,
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
