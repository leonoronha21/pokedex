import 'package:mobx/mobx.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

part 'pokemons_store.g.dart';

class PokemonsStore = _PokemonsStore with _$PokemonsStore;

abstract class _PokemonsStore with Store {
  @observable
  ObservableList<Map<String, dynamic>> pokemons = ObservableList.of([]); 

  @observable
  bool isLoading = false; 

  @observable
  String? errorMessage; 

  @observable
  int deslocamento = 0;

  @observable
  bool hasMore = true; 

  @observable
  String searchQuery = '';

  @observable
  int paginaAtual = 1;
  @observable
  int totalPaginas = 1;
  final int tamanhoPagina = 20;

  @action
  Future<void> fetchPokemons() async {
    return buscarPokemons();
  }

  @action
  Future<void> fetchPokemonsImpl(bool loadMore) async {
    return buscarPokemonsImpl(loadMore);
  }

  @action
  Future<void> buscarPokemons() async {
    return buscarPokemonsImpl(false);
  }

  @action
  Future<void> buscarPokemonsImpl(bool carregarMais) async {
    if (isLoading) return;
    isLoading = true;
    errorMessage = null;
    try {
      if (!carregarMais) {
        pokemons.clear();
      }
      final url = searchQuery.isEmpty
          ? Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=$tamanhoPagina&offset=${(paginaAtual - 1) * tamanhoPagina}')
          : Uri.parse('https://pokeapi.co/api/v2/pokemon/${searchQuery.toLowerCase()}');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        if (searchQuery.isEmpty) {
          final data = json.decode(response.body);
          final List resultados = data['results'];
          totalPaginas = (data['count'] / tamanhoPagina).ceil();
          pokemons.clear();
          for (var resultado in resultados) {
            final detalhesPokemon = await buscarDetalhesPokemon(resultado['url']);
            pokemons.add(detalhesPokemon);
          }
        } else {
          final detalhesPokemon = await buscarDetalhesPokemon('https://pokeapi.co/api/v2/pokemon/${searchQuery.toLowerCase()}');
          pokemons.clear();
          pokemons.add(detalhesPokemon);
          totalPaginas = 1;
        }
      } else {
        if (searchQuery.isNotEmpty) {
          pokemons.clear();
          totalPaginas = 1;
        }
        errorMessage = 'Pokémon não encontrado';
      }
    } catch (e) {
      errorMessage = 'Erro ao buscar Pokémons: $e';
    } finally {
      isLoading = false;
    }
  }

  Future<Map<String, dynamic>> buscarDetalhesPokemon(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'nome': data['name'],
        'imagem': data['sprites']['front_default'],
        'tipo': (data['types'] as List)
            .map((typeInfo) => typeInfo['type']['name'])
            .toList(),
      };
    } else {
      throw Exception('Erro ao carregar detalhes do Pokémon');
    }
  }

  Future<Map<String, dynamic>> buscarDetalhesCompletosPokemon(String nome) async {
    final pokeResponse = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$nome'));
    final speciesResponse = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon-species/$nome'));
    if (pokeResponse.statusCode == 200 && speciesResponse.statusCode == 200) {
      final pokeData = json.decode(pokeResponse.body);
      final speciesData = json.decode(speciesResponse.body);
      return {
        'id': pokeData['id'],
        'nome': pokeData['name'],
        'imagem': pokeData['sprites']['other']['official-artwork']['front_default'] ?? pokeData['sprites']['front_default'],
        'tipo': (pokeData['types'] as List).map((t) => t['type']['name']).toList(),
        'altura': pokeData['height'],
        'peso': pokeData['weight'],
        'habilidades': (pokeData['abilities'] as List).map((a) => a['ability']['name']).toList(),
        'status': { for (var s in pokeData['stats']) s['stat']['name']: s['base_stat'] },
        'especie': speciesData['genera']?.firstWhere((g) => g['language']['name'] == 'pt', orElse: () => null)?['genus'] ?? '',
        'grupos_ovo': (speciesData['egg_groups'] as List).map((e) => e['name']).toList(),
        'taxa_genero': speciesData['gender_rate'],
        'texto_sabor': (speciesData['flavor_text_entries'] as List?)?.firstWhere((f) => f['language']['name'] == 'pt', orElse: () => null)?['flavor_text'] ?? '',
        'url_cadeia_evolucao': speciesData['evolution_chain']['url'],
      };
    } else {
      throw Exception('Erro ao carregar detalhes do Pokémon');
    }
  }

  @action
  void definirBusca(String busca) {
    searchQuery = busca;
    buscarPokemons();
  }

  @action
  void definirPagina(int pagina) {
    paginaAtual = pagina;
    buscarPokemons();
  }

  @action
  void setSearchQuery(String query) {
    definirBusca(query);
  }

  @action
  void setPage(int page) {
    definirPagina(page);
  }


  bool get temMais => hasMore;

  String get termoBusca => searchQuery;

  String? get mensagemErro => errorMessage;

  ObservableList<Map<String, dynamic>> get listaPokemons => pokemons;
}
