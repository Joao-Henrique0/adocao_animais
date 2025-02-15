import unittest
import requests

BASE_URL = "http://localhost:5001"

class TestAnimals(unittest.TestCase):
    
    def test_01_get_animals(self):
        response = requests.get(f"{BASE_URL}/animals?page=0&itemsPerPage=3")
        self.assertEqual(response.status_code, 200)
        animals = response.json()
        self.assertIsInstance(animals, list)
        
    def test_02_add_animals(self):
        new_animals = [
            {
                "id": "5678",
                "name": "Leo",
                "type": "Primata",
                "breed": "Mico-leão-dourado",
                "age": 5,
                "imageUrl": "https://static.todamateria.com.br/upload/mi/co/micoleao-cke.jpg",
                "description": "Um mico-leão-dourado ágil e curioso",
                "size": "Pequeno",
                "location": "Curitiba, Brasil",
                "behavior": "Ágil e social",
                "health": "Saudável",
                "specialNeeds": "",
                "ownerContact": "7744-9977"
            }
        ]
        response = requests.post(f"{BASE_URL}/animals", json=new_animals)
        self.assertEqual(response.status_code, 201)
        self.assertIn("message", response.json())