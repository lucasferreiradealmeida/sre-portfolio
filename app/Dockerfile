# Usa uma imagem oficial leve do Python
FROM python:3.11-slim

# Define o diretório de trabalho dentro do container
WORKDIR /app

# Copia as dependências e instala
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia o código da aplicação
COPY main.py .

# Expõe a porta que a aplicação vai rodar
EXPOSE 8000

# Comando para iniciar a aplicação
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]