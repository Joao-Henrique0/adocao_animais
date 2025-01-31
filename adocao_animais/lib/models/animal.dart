import 'package:flutter/material.dart';

class Animal with ChangeNotifier {
  final String id;
  final String name;
  final String type;
  final String breed;
  final int age;
  final String imageUrl;
  final String description;
  final String size; // Pequeno, Médio, Grande
  final String location; // Cidade/Estado ou coordenadas
  final String behavior; // Calmo, Agitado, Brincalhão etc.
  final String health; // Saudável, Necessita Vacinação, Tratamento Especial
  final String specialNeeds; // Necessidades Especiais (opcional)
  final String ownerContact; // Informações de contato do responsável pelo animal

  Animal({
    required this.id,
    required this.name,
    required this.type,
    required this.breed,
    required this.age,
    required this.imageUrl,
    required this.description,
    required this.size,
    required this.location,
    required this.behavior,
    required this.health,
    this.specialNeeds = '', // Campo opcional
    required this.ownerContact,
  });
}
