import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../theme/app_theme.dart';
import 'pokemons_store.dart';
import 'Detalhes.dart';

class ListaPokemons extends StatelessWidget {
  final PokemonsStore loja = PokemonsStore();
  final TextEditingController controladorBusca = TextEditingController();

  ListaPokemons({super.key}) {
    loja.fetchPokemons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).primaryColor,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Pokédex',
                          style: null,
            ),
            const SizedBox(width: 8),
            Image.asset(
              'lib/assets/pokebola.png',
              height: 36,
              width: 36,
              errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(Icons.search, color: Colors.grey),
                    ),
                    Expanded(
                      child: TextField(
                        controller: controladorBusca,
                        onSubmitted: (valor) {
                          loja.definirBusca(valor);
                        },
                        decoration: const InputDecoration(
                          hintText: 'Buscar',
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                      loja.hasMore && !loja.isLoading && loja.searchQuery.isEmpty) {
                    loja.fetchPokemonsImpl(true);
                  }
                  return false;
                },
                child: Observer(
                  builder: (_) {
                    if (loja.isLoading && loja.listaPokemons.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (loja.errorMessage != null && loja.listaPokemons.isEmpty) {
                      return Center(child: Text(loja.errorMessage!));
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: loja.listaPokemons.length,
                      itemBuilder: (context, indice) {
                        final pokemon = loja.listaPokemons[indice];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Detalhes(pokemon: pokemon),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Image.network(
                                      pokemon['imagem'],
                                      height: 90,
                                      width: 90,
                                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.catching_pokemon, size: 60, color: Colors.grey),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '#${pokemon['id'] != null ? pokemon['id'].toString().padLeft(3, '0') : ''}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    _capitalizar(pokemon['nome'] ?? pokemon['name'] ?? ''),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            if (loja.isLoading && loja.listaPokemons.isNotEmpty)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  String _capitalizar(String texto) {
    if (texto.isEmpty) return texto;
    return texto[0].toUpperCase() + texto.substring(1);
  }
}
