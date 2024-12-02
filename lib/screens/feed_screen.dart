import 'package:adocao_animais/componentes/animal_card.dart';
import 'package:adocao_animais/componentes/login_button.dart';
import 'package:adocao_animais/componentes/theme_button.dart';
import 'package:adocao_animais/models/animals_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final TextEditingController _searchController = TextEditingController();
  List filteredAnimals = [];
  bool isSearching = false;

  // Filtros adicionais
  String selectedSize = 'Tamanho';
  String selectedAge = 'Idade';
  String selectedLocation = 'Local';

  // Scroll controller para detectar quando o usuário chega ao final
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _scrollController.removeListener(_scrollListener);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      isSearching = _searchController.text.isNotEmpty;
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Carregar mais animais quando o usuário chega no final da lista
      Provider.of<AnimalsList>(context, listen: false).loadMore();
    }
  }

  // Método de filtro que agora considera nome, tipo, raça, tamanho, idade e localização
  List _filterAnimals(String query, List allAnimals) {
    return allAnimals.where((animal) {
      bool matchesQuery =
          animal.name.toLowerCase().contains(query.toLowerCase()) ||
              animal.type.toLowerCase().contains(query.toLowerCase());

      // Filtro por tamanho
      if (selectedSize != 'Tamanho' && animal.size != selectedSize) {
        matchesQuery = false;
      }

      // Filtro por idade
      if (selectedAge != 'Idade') {
        if (selectedAge == '5+') {
          if (animal.age < 5) {
            matchesQuery = false;
          }
        } else if (animal.age != int.parse(selectedAge)) {
          matchesQuery = false;
        }
      }

      // Filtro por localização
      if (selectedLocation != 'Local' && animal.location != selectedLocation) {
        matchesQuery = false;
      }

      return matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Adote Seu Pet'),
        actions: [ThemeButton(), LoginButton()],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Campo de busca
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar por nome ou tipo',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),

          // Filtros (Dropdowns)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: selectedSize,
                  items: ['Tamanho', 'Pequeno', 'Médio', 'Grande']
                      .map((String size) {
                    return DropdownMenuItem<String>(
                      value: size,
                      child: Text(size),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedSize = newValue!;
                    });
                  },
                ),
                DropdownButton<String>(
                  value: selectedAge,
                  items: ['Idade', '1', '2', '3', '4', '5+'].map((String age) {
                    return DropdownMenuItem<String>(
                      value: age,
                      child: Text(age),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedAge = newValue!;
                    });
                  },
                ),
                DropdownButton<String>(
                  value: selectedLocation,
                  items: [
                    "Local",
                    "São Paulo",
                    "Rio de Janeiro",
                    "Belo Horizonte",
                    "Curitiba",
                    "Porto Alegre",
                    "Campinas",
                    "Fortaleza",
                    "Salvador",
                    "Brasília",
                    "Recife",
                    "Manaus",
                    "Goiânia"
                  ].map((String location) {
                    return DropdownMenuItem<String>(
                      value: location,
                      child: Text(location),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedLocation = newValue!;
                    });
                  },
                ),
              ],
            ),
          ),

          // Lista de animais filtrados
          Expanded(
            child: FutureBuilder(
              future: Provider.of<AnimalsList>(context, listen: false)
                  .loadAnimals(),
              builder: (ctx, snapshot) => snapshot.connectionState ==
                      ConnectionState.waiting
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.all(8),
                      child:
                          Consumer<AnimalsList>(builder: (ctx, animalsList, _) {
                        final allAnimals = animalsList.animals;
                        final filtered =
                            _filterAnimals(_searchController.text, allAnimals);

                        return filtered.isEmpty
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Nenhum animal encontrado'),
                                  SizedBox(height: 20),
                                  SizedBox(
                                      width: double.infinity,
                                      child: Icon(
                                        Icons.pets,
                                        size: 78,
                                      ))
                                ],
                              )
                            : GridView.builder(
                                controller: _scrollController,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                itemCount: filtered.length,
                                itemBuilder: (ctx, i) =>
                                    AnimalCard(animal: filtered[i]),
                              );
                      }),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
