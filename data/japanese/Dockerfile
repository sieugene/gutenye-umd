FROM python:3.10-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libgl1 \
    libglib2.0-0 \
    libgomp1 \
    libgcc-s1 \
    && rm -rf /var/lib/apt/lists/*

# Install compatible packages
RUN pip install --no-cache-dir \
    paddlepaddle==2.6.1 \
    paddle2onnx==1.2.3 \
    six \
    onnxsim \
    onnx

# Working directory
WORKDIR /workspace

# Copy conversion script
COPY convert_models.sh /workspace/convert_models.sh
RUN chmod +x /workspace/convert_models.sh

# Run conversion automatically
CMD ["/workspace/convert_models.sh"]