import 'package:adocao_animais/utils/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Certifique-se de ajustar o caminho para onde está a classe Auth

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);

    return IconButton(
      onPressed: () async {
        if (auth.isSignedIn) {
          await auth.handleSignOut();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Você saiu com sucesso.'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          try {
            await auth.handleSignIn();
            if (auth.isSignedIn) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Bem-vindo, ${auth.currentUser?.displayName ?? 'Usuário'}!'),
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          } catch (e) {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Erro de Login'),
                content: Text('Ocorreu um erro ao fazer login: $e'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        }
      },
      icon: auth.isSignedIn
          ? const Icon(Icons.logout) // Mostra o botão de logout
          : const Icon(Icons.login), // Mostra o botão de login
    );
  }
}
