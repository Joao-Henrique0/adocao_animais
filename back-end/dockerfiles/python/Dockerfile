# Usar uma imagem oficial do Python
FROM python:3.11-slim

# Setar o diretório de trabalho
WORKDIR /app

# Copiar o código para o diretório de trabalho
COPY . /app

# Instalar as dependências do Flask e outras bibliotecas
RUN pip install --no-cache-dir -r requirements.txt

# Expor a porta que o Flask vai rodar
EXPOSE 5000

# Comando para rodar o Flask
CMD ["python", "app.py"]