import 'package:adocao_animais/componentes/message_bubble.dart';
import 'package:adocao_animais/core/models/chat_message.dart';
import 'package:adocao_animais/core/services/chat/chat_http_service.dart';
import 'package:adocao_animais/utils/auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  final String chatId;

  const Messages({super.key, required this.chatId});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  late ChatWebSocketService _chatService;

  @override
  void initState() {
    super.initState();
    _chatService = ChatWebSocketService();
    _chatService.connect(widget.chatId);
  }

  @override
  void dispose() {
    _chatService.disconnectChat(widget.chatId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ChatMessage>>(
      stream: _chatService.messagesStream(widget.chatId),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Sem dados. Vamos conversar?'));
        } else {
          final msgs = snapshot.data!;
          return ListView.builder(
            reverse: true,
            itemCount: msgs.length,
            itemBuilder: (ctx, i) => MessageBubble(
              key: ValueKey(msgs[i].id),
              message: msgs[i],
              belongsToCurrentUser: Auth().firebaseUser?.uid == msgs[i].userId,
            ),
          );
        }
      },
    );
  }
}
