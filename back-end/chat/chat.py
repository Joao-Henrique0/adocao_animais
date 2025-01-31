from flask import Flask, request, jsonify
from flask_cors import CORS
from flask_socketio import SocketIO, join_room, leave_room
from pymongo import MongoClient
from datetime import datetime

# Configurações do app Flask
app = Flask(__name__)
CORS(app)
socketio = SocketIO(app, cors_allowed_origins="*")  # Adicionando suporte a WebSockets

# Configuração do MongoDB
client = MongoClient("mongodb://mongo:27017/")
db = client['adocao_animais']
messages_collection = db['messages']
connected_clients = {}

# Rota para buscar mensagens de um chat específico
@app.route('/messages/<chat_id>', methods=['GET'])
def get_messages(chat_id):
    try:
        messages = list(messages_collection.find({"chatId": chat_id}).sort("createdAt", -1))
        for message in messages:
            message["_id"] = str(message["_id"])  # Converte ObjectId para string
        return jsonify(messages), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Rota para enviar uma nova mensagem via HTTP
@app.route('/messages', methods=['POST'])
def send_message():
    try:
        data = request.get_json()
        
        required_fields = ['text', 'userId', 'userName', 'userImageUrl', 'chatId']
        if not all(field in data for field in required_fields):
            return jsonify({"error": "Campos obrigatórios estão faltando"}), 400
        
        message = {
            "text": data['text'],
            "userId": data['userId'],
            "userName": data['userName'],
            "userImageUrl": data['userImageUrl'],
            "chatId": data['chatId'],
            "createdAt": datetime.now().isoformat()
        }
        
        result = messages_collection.insert_one(message)
        message["_id"] = str(result.inserted_id)

        # Envia a mensagem para todos os clientes conectados no chat via WebSocket
        socketio.emit('new_message', message, room=data['chatId'])

        return jsonify(message), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Adicione um log quando o WebSocket se conecta e quando alguém sai
@socketio.on('connect')
def handle_connect():
    print("Cliente conectado via WebSocket")

@socketio.on('disconnect')
def handle_disconnect():
    print("Cliente desconectado via WebSocket")

@socketio.on('join_chat')
def handle_join_chat(data):
    chat_id = data.get('chatId')
    user_id = data.get('userId')

    if chat_id:
        # Verifique se o usuário já está no chat
        if chat_id not in connected_clients:
            connected_clients[chat_id] = []

        if user_id not in connected_clients[chat_id]:
            print(f"Cliente {user_id} entrou no chat {chat_id}")
            join_room(chat_id)
            connected_clients[chat_id].append(user_id)
        else:
            print(f"Cliente {user_id} já está no chat {chat_id}")

@socketio.on('leave_chat')
def handle_leave_chat(data):
    chat_id = data.get('chatId')
    user_id = data.get('userId')

    if chat_id and user_id:
        print(f"Cliente {user_id} saiu do chat {chat_id}")
        leave_room(chat_id)

        if chat_id in connected_clients and user_id in connected_clients[chat_id]:
            connected_clients[chat_id].remove(user_id)
            print(f"Cliente {user_id} removido do chat {chat_id}")
            
            # Emite evento para os outros usuários do chat
            socketio.emit('user_left', {'chatId': chat_id, 'userId': user_id}, room=chat_id)
        else:
            print(f"Usuário {user_id} não encontrado no chat {chat_id}")



@app.route('/disconnect_chat', methods=['POST'])
def disconnect_chat():
    try:
        data = request.get_json()
        chat_id = data.get('chatId')

        if not chat_id:
            print("chatId ausente na requisição")
            return jsonify({"error": "chatId é obrigatório"}), 400

        print(f"Desconectando do chat {chat_id}")
        response = jsonify({"message": "Desconectado do chat com sucesso"})
        response.status_code = 200
        return response
    except Exception as e:
        print(f"Erro ao desconectar do chat: {e}")
        return jsonify({"error": str(e)}), 500

# Manipulador de erros global
@app.errorhandler(Exception)
def handle_exception(e):
    print(f"Erro não tratado: {e}")
    return jsonify({"error": "Ocorreu um erro no servidor"}), 500

# Inicia o servidor Flask com WebSockets
if __name__ == '__main__':
    socketio.run(app, debug=True, host='0.0.0.0', allow_unsafe_werkzeug=True)