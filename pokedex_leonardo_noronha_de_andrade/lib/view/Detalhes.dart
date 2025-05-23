import 'package:flutter/material.dart';
import '../controller/DetalhesController.dart';
import '../theme/app_theme.dart';

class Detalhes extends StatefulWidget {
  final Map<String, dynamic> pokemon;
  const Detalhes({super.key, required this.pokemon});

  @override
  State<Detalhes> createState() => _DetalhesState();
}

class _DetalhesState extends State<Detalhes> {
  Map<String, dynamic>? fullDetails;
  bool isLoading = true;
  String? error;
  final DetalhesController controller = DetalhesController();

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    setState(() { isLoading = true; error = null; });
    final nome = widget.pokemon['name'] ?? widget.pokemon['nome'];
    final detalhes = await controller.buscarDetalhes(nome);
    if (detalhes != null) {
      setState(() {
        fullDetails = detalhes;
        isLoading = false;
      });
    } else {
      setState(() { error = 'Erro ao buscar detalhes.'; isLoading = false; });
    }
  }

  Future<List<Map<String, dynamic>>> fetchEvolutionChain(String url) async {
    return await controller.buscarEvolucao(url);
  }

  Color getTypeColor(String type) {
    switch (type) {
      case 'grass': return Colors.green;
      case 'poison': return Colors.purple;
      case 'fire': return Colors.red;
      case 'water': return Colors.blue;
      case 'bug': return Colors.lightGreen;
      case 'flying': return Colors.indigoAccent;
      case 'normal': return Colors.brown;
      case 'electric': return Colors.amber;
      case 'ground': return Colors.orange;
      case 'fairy': return Colors.pinkAccent;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = fullDetails != null && fullDetails!['type'] != null && fullDetails!['type'].isNotEmpty
        ? getTypeColor(fullDetails!['type'][0])
        : Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: themeColor,
        elevation: 0,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        title: Text(
          fullDetails?['name']?.toString().toUpperCase() ?? widget.pokemon['name'].toString().toUpperCase(),
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: Image.network(
                          fullDetails!['image'],
                          height: 140,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '#${fullDetails!['id'].toString().padLeft(3, '0')}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        fullDetails!['name'].toString().toUpperCase(),
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...fullDetails!['type'].map<Widget>((type) => Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: getTypeColor(type),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  type.toString().toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ))
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32),
                          ),
                        ),
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('About', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                  Flexible(
                                    child: Text(
                                      fullDetails!['species'] ?? '',
                                      style: const TextStyle(color: Colors.grey),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Height: ${(fullDetails!['height'] / 10).toStringAsFixed(2)} m'),
                                        Text('Weight: ${(fullDetails!['weight'] / 10).toStringAsFixed(2)} kg'),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Abilities: ${(fullDetails!['abilities'] as List).join(', ')}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Egg Groups: ${(fullDetails!['egg_groups'] as List).join(', ')}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      'Gender Rate: 	${fullDetails!['gender_rate']}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              if (fullDetails!['flavor_text'] != null)
                                Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Text(
                                    fullDetails!['flavor_text'].replaceAll('\n', ' '),
                                    style: const TextStyle(color: Colors.black54),
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 4,
                                  ),
                                ),
                              const SizedBox(height: 24),
                              DefaultTabController(
                                length: 2,
                                child: Column(
                                  children: [
                                    TabBar(
                                      labelColor: themeColor,
                                      unselectedLabelColor: Colors.black54,
                                      indicatorColor: themeColor,
                                      tabs: const [
                                        Tab(text: 'Base Stats'),
                                        Tab(text: 'Evolution'),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 260,
                                      child: TabBarView(
                                        children: [
                                          // Base Stats Tab
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ...fullDetails!['stats'].entries.map<Widget>((entry) => Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(width: 80, child: Text(entry.key.toString().toUpperCase())),
                                                        SizedBox(
                                                          width: 160,
                                                          child: LinearProgressIndicator(
                                                            value: (entry.value as int) / 150.0,
                                                            backgroundColor: Colors.grey[200],
                                                            color: themeColor,
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8),
                                                        Text(entry.value.toString()),
                                                      ],
                                                    ),
                                                  )),
                                            ],
                                          ),
                                          // Evolution Tab
                                          FutureBuilder<List<Map<String, dynamic>>>(
                                            future: fetchEvolutionChain(fullDetails!['evolution_chain_url']),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return const Center(child: CircularProgressIndicator());
                                              }
                                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                                return const Center(child: Text('No evolution data.'));
                                              }
                                              final chain = snapshot.data!;
                                              return SizedBox(
                                                width: MediaQuery.of(context).size.width - 48,
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      for (int i = 0; i < chain.length; i++)
                                                        Row(
                                                          children: [
                                                            Column(
                                                              children: [
                                                                Image.network(chain[i]['image'], height: 60),
                                                                const SizedBox(height: 4),
                                                                SizedBox(
                                                                  width: 80,
                                                                  child: Text(
                                                                    chain[i]['name'].toString().toUpperCase(),
                                                                    overflow: TextOverflow.ellipsis,
                                                                    textAlign: TextAlign.center,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            if (i < chain.length - 1)
                                                              const Padding(
                                                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                                                child: Icon(Icons.arrow_forward, color: Colors.grey),
                                                              ),
                                                          ],
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
