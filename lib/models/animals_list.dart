import 'package:adocao_animais/models/animal.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class AnimalsList with ChangeNotifier {
  final List<Animal> _animals = [];
  List<Animal> _allAnimals =
      []; // Lista com todos os dados carregados do JSON (não exibidos de imediato)
  int _currentPage = 0; // Página atual
  final int _itemsPerPage = 6; // Número de itens por página

  List<Animal> get animals {
    return [..._animals];
  }

  int get itemsCount {
    return _animals.length;
  }

  Future<void> loadAnimals() async {
    // Lê o arquivo JSON
    final String response =
        await rootBundle.loadString('lib/assets/animals.json');

    // Decodifica o JSON
    final List<dynamic> data = json.decode(response);

    // Armazena todos os dados carregados
    _allAnimals = data.map((json) {
      return Animal(
        id: json['id'] as String,
        name: json['name'] as String,
        type: json['type'] as String,
        breed: json['breed'] as String,
        age: json['age'] as int,
        imageUrl: json['imageUrl'] as String,
        description: json['description'] as String,
        size: json['size'] as String,
        location: json['location'] as String,
        behavior: json['behavior'] as String,
        health: json['health'] as String,
        specialNeeds: json['specialNeeds'] as String? ?? '', 
        ownerContact: json['ownerContact'] as String,
      );
    }).toList();

    // Carrega a primeira página de animais
    _loadNextPage();
  }

  // Carregar a próxima página de dados
  void _loadNextPage() {
    final int startIndex = _currentPage * _itemsPerPage;
    final int endIndex = startIndex + _itemsPerPage;

    // Adiciona os itens da página atual à lista visível
    _animals.addAll(_allAnimals.sublist(startIndex,
        endIndex > _allAnimals.length ? _allAnimals.length : endIndex));
    _currentPage++;

    // Notifica os ouvintes
    notifyListeners();
  }

  // Método para chamar quando o usuário rolar para o fim da lista
  void loadMore() {
    if (_animals.length < _allAnimals.length) {
      _loadNextPage();
    }
  }
}
