import 'dart:convert' show jsonDecode;
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/pokemon_stat_page.dart';

class PokemonListPage extends StatefulWidget {
  const PokemonListPage({super.key});

  @override
  State<PokemonListPage> createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  late Future<Map<String, dynamic>> pokemon;

  Future<Map<String, dynamic>> getpokemon() async {
    try {
      final res = await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=1302'),
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
    pokemon = getpokemon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade600,
        title: const Text(
          'Pokedex',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(onPressed: (){
              setState(() {
                pokemon = getpokemon();
              });
            }, icon: const Icon(Icons.refresh_sharp, color: Colors.white, size: 20,)),
          )
        ],
      ),
      body: FutureBuilder(
        future: pokemon,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          final data = snapshot.data!;
          final result = data['results'] as List;





          return ListView.builder(
            itemCount: result.length,
            itemBuilder: (context, index) {
              final poke = data['results'][index]['name'];
              


              return TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black26,
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 2,
                      style: BorderStyle.solid,
                      color: Colors.white,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return PokemonStatPage(name: poke.toString());
                      },
                    ),
                  );
                },
                child: Text(
                  poke.toString().substring(0, 1).toUpperCase() +
                      poke.toString().substring(1, poke.toString().length),
                  style: const TextStyle(color: Colors.white),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
