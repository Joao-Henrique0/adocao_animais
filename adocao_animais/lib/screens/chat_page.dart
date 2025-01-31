import 'package:adocao_animais/componentes/chat/messages.dart';
import 'package:adocao_animais/componentes/chat/new_message.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map?;
    final ownerContact = arguments?['ownerContact'] ?? '';
    return Scaffold(
      appBar: AppBar(
        title: Text(ownerContact),
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
