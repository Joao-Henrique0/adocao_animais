import 'package:adocao_animais/models/animal.dart';
import 'package:adocao_animais/utils/app_routes.dart';
import 'package:flutter/material.dart';

class AnimalCard extends StatelessWidget {
  final Animal animal;

  const AnimalCard({super.key, required this.animal});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navegar para a página de detalhes
        Navigator.of(context).pushNamed(AppRoutes.details, arguments: animal);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 1),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 250,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    animal.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      color: Colors.black.withOpacity(0.6),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          animal.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Idade: ${animal.age} anos', // Exibe a idade do animal
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Tipo: ${animal.type}', // Exibe o tipo de animal
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
