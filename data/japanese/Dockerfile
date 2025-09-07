FROM python:3.10-slim

RUN apt-get update && apt-get install -y \
    libgl1 \
    libglib2.0-0 \
    libgomp1 \
    libgcc-s1 \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir \
    paddlepaddle==2.5.2 \
    paddle2onnx==1.2.1 \
    six \
    onnx

WORKDIR /workspace

CMD ["/bin/bash"]