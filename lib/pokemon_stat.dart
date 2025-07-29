import 'package:flutter/material.dart';

class PokemonStat extends StatelessWidget {
  final double val;
  final String category;
  final Color color;
  const PokemonStat({super.key, required this.category, required this.val, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(category, style: TextStyle(fontSize: 16, color: Colors.white)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 300,
              height: 20,
              color: const Color.fromRGBO(255, 255, 255, 1),
              child: Row(
                children: [
                  ClipRRect(borderRadius: BorderRadius.circular(10), child: Container(width: val, height: 20, color: color,)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
