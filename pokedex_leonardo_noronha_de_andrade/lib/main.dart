import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'view/Pokemons.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.themeData,
    home: ListaPokemons(),
  ));
}
