from flask import Flask, jsonify, request
from flask_cors import CORS
from pymongo import MongoClient

app = Flask(__name__)
CORS(app)

# Configuração do MongoDB
client = MongoClient("mongodb://mongo:27017/")
db = client['adocao_animais']
animals_collection = db['animals']

@app.route('/animals', methods=['GET'])
def get_animals():
    try:
        page = int(request.args.get('page', 0))  
        items_per_page = int(request.args.get('itemsPerPage', 6))  
        skip = page * items_per_page
        limit = items_per_page

        animals = list(animals_collection.find().skip(skip).limit(limit))

        for animal in animals:
            animal['_id'] = str(animal['_id'])

        return jsonify(animals), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/animals', methods=['POST'])
def add_animals():
    try:
        data = request.json  # Obtém os dados do corpo da requisição

        if not isinstance(data, list):  # Verifica se é uma lista
            return jsonify({"error": "O corpo da requisição deve ser uma lista de animais."}), 400

        required_fields = ["name", "type", "breed", "age", "imageUrl", "description", 
                           "size", "location", "behavior", "health", "ownerContact"]

        for animal in data:
            if not all(field in animal for field in required_fields):
                return jsonify({"error": "Todos os campos obrigatórios devem ser fornecidos para cada animal."}), 400

        result = animals_collection.insert_many(data)  # Insere a lista de animais no MongoDB

        return jsonify({
            "message": "Animais adicionados com sucesso!",
            "ids": [str(id) for id in result.inserted_ids]
        }), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
