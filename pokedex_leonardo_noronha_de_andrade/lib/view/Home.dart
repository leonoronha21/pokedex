import 'package:flutter/material.dart';
import './Pokemons.dart'; // Certifique-se de criar este arquivo.

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(
        255,
        82,
        82,
        1,
      ), // Cor de fundo estilo Pokémon
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bem vindo à Pokedex',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            // Botão "Continuar" para navegar manualmente para a tela dos Pokémons
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Pokemons()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Cor do botão
                foregroundColor: Colors.redAccent, // Cor do texto
              ),
              child: Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}
