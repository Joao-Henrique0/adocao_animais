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
                "id": "1234",
                "name": "Marlon",
                "type": "Cachorro",
                "breed": "Labrador",
                "age": 3,
                "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/2/26/YellowLabradorLooking_new.jpg/640px-YellowLabradorLooking_new.jpg",
                "description": "Um Labrador amigável",
                "size": "Grande",
                "location": "São Paulo",
                "behavior": "Brincalhão",
                "health": "Saudável",
                "specialNeeds": "",
                "ownerContact": "1234-5678"
            }
        ]
        response = requests.post(f"{BASE_URL}/animals", json=new_animals)
        self.assertEqual(response.status_code, 201)
        self.assertIn("message", response.json())