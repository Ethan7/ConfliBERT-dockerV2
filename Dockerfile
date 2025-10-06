# Use an NVIDIA CUDA runtime image that includes the CUDA libraries
FROM nvidia/cuda:12.6.0-runtime-ubuntu22.04
ENV DEBIAN_FRONTEND=noninteractive

# Install Python 3.10 and pip
RUN apt-get update && \
    apt-get install -y python3.10 python3.10-dev python3-pip && \
    ln -sf /usr/bin/python3.10 /usr/bin/python3 && \
    ln -sf /usr/bin/pip3 /usr/bin/pip && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY . .

RUN pip3 install --upgrade pip setuptools && \
    pip3 install --no-cache-dir \
        torch==2.5.1 torchvision==0.20.1 torchaudio==2.5.1 --index-url https://download.pytorch.org/whl/cu124 && \
    pip3 install --no-cache-dir \
        transformers==4.31.0 simpletransformers

# Optional: Set NVIDIA-specific environment variables
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility

# Set the default command (adjust as needed)
CMD ["/bin/bash"]
