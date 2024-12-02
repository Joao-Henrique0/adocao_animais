import 'package:adocao_animais/utils/auth.dart';
import 'package:flutter/material.dart';
import 'package:adocao_animais/models/animal.dart';
import 'package:provider/provider.dart';

class AnimalDetailsScreen extends StatelessWidget {
  const AnimalDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Animal animal = ModalRoute.of(context)?.settings.arguments as Animal;
    final Color color = Theme.of(context).colorScheme.tertiary;
    final auth = Provider.of<Auth>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(animal.name), // Exibe o nome do animal na AppBar
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do animal
            ClipRRect(
              child: Image.network(
                animal.imageUrl,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (auth.isSignedIn)
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Contate para adoção'),
                              content: Text(
                                  'Número de contato: ${animal.ownerContact}'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Fechar'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text('Adotar'),
                      ),
                    ),
                  // Nome do animal
                  Text(
                    animal.name,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Tipo do animal
                  Text(
                    'Tipo: ${animal.type}',
                    style: TextStyle(
                      fontSize: 18,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Raça do animal
                  Text(
                    'Raça: ${animal.breed}',
                    style: TextStyle(
                      fontSize: 18,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Idade do animal
                  Text(
                    'Idade: ${animal.age} Anos',
                    style: TextStyle(
                      fontSize: 18,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Tamanho do animal
                  Text(
                    'Tamanho: ${animal.size}',
                    style: TextStyle(
                      fontSize: 18,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Localização do animal
                  Text(
                    'Localização: ${animal.location}',
                    style: TextStyle(
                      fontSize: 18,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Comportamento do animal
                  Text(
                    'Comportamento: ${animal.behavior}',
                    style: TextStyle(
                      fontSize: 18,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Saúde do animal
                  Text(
                    'Saúde: ${animal.health}',
                    style: TextStyle(
                      fontSize: 18,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Necessidades especiais do animal
                  Text(
                    'Necessidades Especiais: ${animal.specialNeeds.isNotEmpty ? animal.specialNeeds : 'Nenhuma'}',
                    style: TextStyle(
                      fontSize: 18,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Descrição do animal
                  const Text(
                    'Descrição:',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    animal.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
