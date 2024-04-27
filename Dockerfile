FROM python:3.9-slim-buster

# Install necessary packages and git-lfs
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    git-lfs \
    libffi-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install dependencies
RUN pip install --no-cache-dir \
    torch \
    onnxruntime-gpu \
    numpy \
    sentencepiece \
    gradio \
    mdtex2html \
    pypinyin \
    tiktoken \
    socksio \
    colorama \
    duckduckgo_search \
    Pygments \
    llama_index \
    langchain \
    markdown2 \
    peft \
    transformers \
    SentencePiece \
    onnxruntime-gpu

# Clone repository and submodules
WORKDIR /app
RUN git clone -b dev https://github.com/camenduru/Llama-2-Onnx.git .
RUN rm -rf /app/Llama-2-Onnx/7B_FT_float16
RUN git clone https://huggingface.co/4bit/7B_FT_float16 /app/Llama-2-Onnx/7B_FT_float16

# Copy configuration files and ONNX model
COPY llama-2-onnx/7B_FT_float16/ONNX/LlamaV2_7B_float16.onnx ONNX/LlamaV2_7B_float16.onnx
COPY llama-2-onnx/7B_FT_float16/embeddings.pth embeddings.pth
COPY llama-2-onnx/7B_FT_float16/tokenizer.model tokenizer.model

# Copy chat app files
COPY ChatApp/ .

# Set PYTHONPATH
ENV PYTHONPATH=/app:$PYTHONPATH

# Expose port for API access
EXPOSE 7860

# Run chat server
CMD ["python", "app.py"]
