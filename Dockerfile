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
    sentencepiece \
    gradio

# Клонування репозиторію та підмодулів
WORKDIR /app
RUN git clone https://github.com/kroschu/Llama-2-Onnx.git .
RUN git submodule init llama-2-onnx-float16
RUN git submodule update llama-2-onnx-float16

# Копіювання конфігураційних файлів та ONNX моделі
COPY llama-2-onnx-float16/ONNX/LlamaV2_float16.onnx ONNX/LlamaV2_float16.onnx
COPY llama-2-onnx-float16/embeddings.pth embeddings.pth
COPY llama-2-onnx-float16/tokenizer.model tokenizer.model

# Копіювання файлів чат-додатку
COPY ChatApp/ .

# Встановлення PYTHONPATH
ENV PYTHONPATH=/app:$PYTHONPATH

# Експорт порту для доступу до API
EXPOSE 7860

# Запуск сервера чату
CMD ["python", "app.py"]