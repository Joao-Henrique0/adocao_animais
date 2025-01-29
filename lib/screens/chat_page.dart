import 'package:adocao_animais/componentes/messages.dart';
import 'package:adocao_animais/componentes/new_message.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map?;
    final ownerContact = arguments?['ownerContact'] ?? '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animal Chat'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: Messages(chatId: ownerContact)),
            NewMessage(chatId: ownerContact),
          ],
        ),
      ),
    );
  }
}
