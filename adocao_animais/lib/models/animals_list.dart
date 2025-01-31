import 'package:flutter/material.dart';
import 'package:adocao_animais/models/animal.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AnimalsList with ChangeNotifier {
  final List<Animal> _animals = [];
  int _currentPage = 0; // Página atual
  final int _itemsPerPage = 6; // Número de itens por página

  List<Animal> get animals {
    return [..._animals];
  }

  int get itemsCount {
    return _animals.length;
  }

  Future<void> loadAnimals() async {
    final url = Uri.parse('http://10.0.0.122:5001/animals?page=$_currentPage&itemsPerPage=$_itemsPerPage'); // Alterar para a URL do seu backend

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty) {
          // Mapeando os dados para objetos Animal
          final newAnimals = data.map((json) {
            return Animal(
              id: json['_id'] as String,
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

          // Adiciona os novos animais à lista existente
          _animals.addAll(newAnimals);
          _currentPage++;  // Incrementa a página para a próxima requisição

          // Notifica os ouvintes
          notifyListeners();
        }
      } else {
        throw Exception('Falha ao carregar dados dos animais');
      }
    } catch (error) {
      print('Erro ao buscar dados dos animais: $error');
    }
  }

  // Método para chamar quando o usuário rolar para o fim da lista
  void loadMore() {
    loadAnimals();  // Carrega mais animais (nova página)
  }
}
