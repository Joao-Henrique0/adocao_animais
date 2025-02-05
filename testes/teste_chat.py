import unittest
import requests

BASE_URL = "http://localhost:5002"

class TestChat(unittest.TestCase):
    
    def test_01_get_messages(self):
        chat_id = "9988-7766"
        response = requests.get(f"{BASE_URL}/messages/{chat_id}")
        self.assertEqual(response.status_code, 200)
        messages = response.json()
        self.assertIsInstance(messages, list)
    
    def test_02_send_message(self):
        new_message = {
            "text": "Olá, como você está? as asas",
            "userId": "user321",
            "userName": "Pedro",
            "userImageUrl": "https://s2-techtudo.glbimg.com/L9wb1xt7tjjL-Ocvos-Ju0tVmfc=/0x0:1200x800/984x0/smart/filters:strip_icc()/i.s3.glbimg.com/v1/AUTH_08fbf48bc0524877943fe86e43087e7a/internal_photos/bs/2023/q/l/TIdfl2SA6J16XZAy56Mw/canvaai.png",
            "chatId": "9988-7766"
            }
        response = requests.post(f"{BASE_URL}/messages", json=new_message)
        self.assertEqual(response.status_code, 201)
        self.assertIn("text", response.json())

if __name__ == "__main__":
    unittest.main()
