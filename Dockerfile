FROM python:3.9-slim-buster

# Встановлення необхідних пакетів та git-lfs
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    git-lfs \
    libffi-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Встановлення залежностей
RUN pip install --no-cache-dir \
    torch \
    onnxruntime-gpu \
    numpy \
    sentencepiece

# Клонування репозиторію та підмодулів
WORKDIR /app
RUN git clone https://github.com/microsoft/Llama-2-Onnx.git .
RUN git submodule init llama-2-onnx-7B_FT_float16
RUN git submodule update llama-2-onnx-7B_FT_float16

# Копіювання конфігураційних файлів та ONNX моделі
COPY llama-2-onnx-7B_FT_float16/ONNX/LlamaV2_7B_FT_float16.onnx ONNX/LlamaV2_7B_FT_float16.onnx
COPY llama-2-onnx-7B_FT_float16/embeddings.pth embeddings.pth
COPY llama-2-onnx-7B_FT_float16/tokenizer.model tokenizer.model

# Експорт порту для доступу до API
EXPOSE 8000

# Запуск сервера
CMD ["python", "app.py"]
