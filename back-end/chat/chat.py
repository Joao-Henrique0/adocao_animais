from flask import Flask, request, jsonify
from flask_cors import CORS
from flask_socketio import SocketIO, join_room, leave_room
from pymongo import MongoClient
from datetime import datetime
import eventlet
import eventlet.wsgi

# Configuração do Flask
app = Flask(__name__)
CORS(app)
socketio = SocketIO(app, cors_allowed_origins="*")

# Configuração do MongoDB
client = MongoClient("mongodb://mongo:27017/")
db = client['adocao_animais']
messages_collection = db['messages']
connected_clients = {}  # Mantém controle de clientes conectados por chat

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

# Rota para enviar mensagem via HTTP
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

        # Envia mensagem para os clientes conectados ao chat
        socketio.emit('new_message', message, room=data['chatId'])

        return jsonify(message), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Evento para um usuário entrar no chat
@socketio.on('join_chat')
def handle_join_chat(data):
    chat_id = data.get('chatId')
    user_id = data.get('userId')

    if not chat_id or not user_id:
        return

    if chat_id not in connected_clients:
        connected_clients[chat_id] = set()

    if user_id not in connected_clients[chat_id]:
        join_room(chat_id)
        connected_clients[chat_id].add(user_id)
        print(f"Usuário {user_id} entrou no chat {chat_id}")

    # Notifica outros usuários do chat
    socketio.emit('user_joined', {'chatId': chat_id, 'userId': user_id}, room=chat_id)

# Evento para um usuário sair do chat
@socketio.on('leave_chat')
def handle_leave_chat(data):
    chat_id = data.get('chatId')
    user_id = data.get('userId')

    if not chat_id or not user_id:
        return

    leave_room(chat_id)
    if chat_id in connected_clients and user_id in connected_clients[chat_id]:
        connected_clients[chat_id].remove(user_id)
        print(f"Usuário {user_id} saiu do chat {chat_id}")
        socketio.emit('user_left', {'chatId': chat_id, 'userId': user_id}, room=chat_id)

    if chat_id in connected_clients and not connected_clients[chat_id]:
        del connected_clients[chat_id]

# Inicia o servidor Flask com WebSockets
if __name__ == '__main__':
    socketio.run(app, debug=True, host='0.0.0.0')
