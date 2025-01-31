import 'package:adocao_animais/core/services/chat/chat_http_service.dart';
import 'package:adocao_animais/utils/auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  final String chatId;

  const NewMessage({super.key, required this.chatId});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final ChatWebSocketService _chatService = ChatWebSocketService();
  final TextEditingController _messageController = TextEditingController();
  String _message = '';

  Future<void> _sendMessage() async {
    final user = Auth().firebaseUser;

    if (user != null && _message.trim().isNotEmpty) {
      await _chatService.save(widget.chatId, _message.trim(), user);
      _messageController.clear();
      setState(() => _message = ''); // Atualiza UI após enviar a mensagem
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _messageController,
              onChanged: (msg) => setState(() => _message = msg),
              decoration: const InputDecoration(
                labelText: 'Enviar mensagem...',
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: _message.trim().isEmpty ? null : _sendMessage,
        ),
      ],
    );
  }
}
