import 'dart:convert';
import 'package:http/http.dart' as http;

class DetalhesController {
  Future<Map<String, dynamic>?> buscarDetalhes(String nome) async {
    try {
      final pokeResponse = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$nome'));
      final speciesResponse = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon-species/$nome'));
      if (pokeResponse.statusCode == 200 && speciesResponse.statusCode == 200) {
        final pokeData = json.decode(pokeResponse.body);
        final speciesData = json.decode(speciesResponse.body);
        return {
          'id': pokeData['id'],
          'name': pokeData['name'],
          'image': pokeData['sprites']['other']['official-artwork']['front_default'] ?? pokeData['sprites']['front_default'],
          'type': (pokeData['types'] as List).map((t) => t['type']['name']).toList(),
          'height': pokeData['height'],
          'weight': pokeData['weight'],
          'abilities': (pokeData['abilities'] as List).map((a) => a['ability']['name']).toList(),
          'stats': { for (var s in pokeData['stats']) s['stat']['name']: s['base_stat'] },
          'species': speciesData['genera']?.firstWhere((g) => g['language']['name'] == 'en', orElse: () => null)?['genus'] ?? '',
          'egg_groups': (speciesData['egg_groups'] as List).map((e) => e['name']).toList(),
          'gender_rate': speciesData['gender_rate'],
          'flavor_text': (speciesData['flavor_text_entries'] as List?)?.firstWhere((f) => f['language']['name'] == 'pt', orElse: () => null)?['flavor_text'] ?? '',
          'evolution_chain_url': speciesData['evolution_chain']['url'],
        };
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> buscarEvolucao(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Map<String, dynamic>> chain = [];
      var evo = data['chain'];
      while (evo != null) {
        final name = evo['species']['name'];
        final pokeResp = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$name'));
        String image = '';
        if (pokeResp.statusCode == 200) {
          final pokeData = json.decode(pokeResp.body);
          image = pokeData['sprites']['other']['official-artwork']['front_default'] ?? pokeData['sprites']['front_default'] ?? '';
        }
        chain.add({'name': name, 'image': image});
        if (evo['evolves_to'] != null && (evo['evolves_to'] as List).isNotEmpty) {
          evo = evo['evolves_to'][0];
        } else {
          evo = null;
        }
      }
      return chain;
    } else {
      return [];
    }
  }
}
