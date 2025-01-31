import 'dart:async';
import 'dart:convert';
import 'package:adocao_animais/core/models/chat_message.dart';
import 'package:adocao_animais/utils/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:intl/intl.dart';

class ChatWebSocketService {
  final String baseUrl = 'http://10.0.0.122:5002/messages';
  final String socketUrl = 'http://10.0.0.122:5002';
  final user = Auth().firebaseUser;

  List<ChatMessage> _messages = [];
  io.Socket? _socket;

  final StreamController<List<ChatMessage>> _controller =
      StreamController<List<ChatMessage>>.broadcast();

  // Inicia o WebSocket e começa a emitir mensagens
  void connect(String chatId) {
    if (_socket?.connected ?? false) {
      print('Já está conectado ao WebSocket');
      return; // Impede que o WebSocket se reconecte
    }

    _socket = io.io(socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket?.connect();

    _socket?.emit('join_chat', {'chatId': chatId, 'userId': user?.uid});

    // Escuta por novas mensagens
    _socket?.on('new_message', (data) {
      final newMessage = ChatMessage(
        id: data['_id'],
        text: data['text'],
        createdAt: DateFormat("yyyy-MM-ddTHH:mm:ss.SSS")
            .parse(data['createdAt'], true),
        userId: data['userId'],
        userName: data['userName'],
        userImageUrl: data['userImageUrl'],
      );

      // Verifica se a mensagem já não existe para evitar duplicação
      if (!_messages.any((msg) => msg.id == newMessage.id)) {
        _messages.insert(0, newMessage); // Adiciona a nova mensagem
        _controller.add(_messages); // Emite a lista de mensagens
      }
    });
  }

  // Desconecta o WebSocket
  // Desconecta o WebSocket corretamente
  Future<void> disconnect(String chatId) async {
    if (_socket?.connected ?? false) {
      print('Enviando evento leave_chat para chatId: $chatId');
      _socket?.emit('leave_chat', {
        'chatId': chatId,
        'userId': user?.uid
      }); // Espera 0.5s para garantir envio
      _socket?.disconnect();
      print('WebSocket desconectado');
    }
  }

  // Função que carrega as mensagens do backend
  Stream<List<ChatMessage>> messagesStream(String chatId) {
    _loadMessagesFromBackend(chatId).then((messages) {
      _messages = messages;
      _controller.add(_messages); // Emite as mensagens carregadas do backend
    });

    // Inicia a conexão WebSocket
    connect(chatId);

    return _controller.stream; // Retorna o stream de mensagens
  }

  // Função para carregar mensagens do backend
  Future<List<ChatMessage>> _loadMessagesFromBackend(String chatId) async {
    final url = Uri.parse('$baseUrl/$chatId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((msg) {
        return ChatMessage(
          id: msg['_id'],
          text: msg['text'],
          createdAt: DateFormat("yyyy-MM-ddTHH:mm:ss.SSS")
              .parse(msg['createdAt'], true),
          userId: msg['userId'],
          userName: msg['userName'],
          userImageUrl: msg['userImageUrl'],
        );
      }).toList();
    } else {
      throw Exception('Falha ao carregar mensagens');
    }
  }

  // Função para salvar a mensagem no backend
  Future<ChatMessage?> save(String chatId, String text, User user) async {
    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'text': text,
        'userId': user.uid,
        'userName': user.displayName ?? 'Usuário desconhecido',
        'userImageUrl': user.photoURL ?? '',
        'chatId': chatId,
      }),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return ChatMessage(
        id: data['_id'],
        text: data['text'],
        createdAt: DateTime.now(),
        userId: data['userId'],
        userName: data['userName'],
        userImageUrl: data['userImageUrl'],
      );
    } else {
      throw Exception('Falha ao salvar mensagem');
    }
  }

  Future<void> disconnectChat(String chatId) async {
    final url = Uri.parse('$socketUrl/disconnect_chat');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'chatId': chatId, 'userId': user?.uid}),
      );

      if (response.statusCode == 200) {
        print('Desconectado do chat com sucesso');
        disconnect(
            chatId); // Garante que o WebSocket é desconectado após a resposta
      } else {
        print('Falha ao desconectar do chat: ${response.body}');
      }
    } catch (e) {
      print('Erro ao desconectar do chat: $e');
    }
  }
}
