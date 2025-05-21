import 'package:flutter/material.dart';
import 'view/Home.dart'; // Certifique-se de usar o caminho correto para o arquivo Home.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
      ),
      home: Home(), // Define o widget Home como a tela inicial
    );
  }
}
