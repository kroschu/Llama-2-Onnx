FROM python:3.9-slim-buster

# Встановлення необхідних пакетів
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    libffi-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Клонування репозиторію та встановлення залежностей
WORKDIR /app
RUN git clone https://github.com/microsoft/Llama-2-Onnx.git .
RUN pip install --no-cache-dir -r requirements.txt

# Копіювання конфігураційних файлів
COPY config.ini .

# Експорт порту для доступу до API
EXPOSE 8000

# Запуск сервера
CMD ["python", "app.py"]
