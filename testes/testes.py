import unittest
from teste_animals import *
from teste_chat import *

if __name__ == "__main__":
    carregador = unittest.TestLoader()
    testes = unittest.TestSuite()

    testes.addTest(carregador.loadTestsFromTestCase(TestAnimals))
    testes.addTest(carregador.loadTestsFromTestCase(TestChat))

    executor = unittest.TextTestRunner()
    executor.run(testes)