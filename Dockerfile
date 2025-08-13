# Use a build-time argument to select the target device. Default to 'cpu'.
ARG DEVICE=cpu

# --- GPU Stage ---
# This stage builds the GPU-enabled environment.
FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04 AS gpu-base
ENV APP_HOME /app
WORKDIR $APP_HOME

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.10 \
    python3-pip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install the specific GPU version of PyTorch first
RUN pip3 install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Copy and install the rest of the GPU requirements
COPY requirements-gpu.txt .
RUN pip3 install --no-cache-dir -r requirements-gpu.txt

# --- CPU Stage ---
# This stage builds the CPU-only environment for Mac/non-GPU PCs.
FROM python:3.10-slim-bullseye AS cpu-base
ENV APP_HOME /app
WORKDIR $APP_HOME

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy and install the CPU requirements
COPY requirements-cpu.txt .
RUN pip3 install --no-cache-dir -r requirements-cpu.txt


# --- Final Stage ---
# Select which base to use depending on the build-time ARG
FROM ${DEVICE}-base
WORKDIR $APP_HOME

# Copy the application code into the final image
COPY . .

# No ENTRYPOINT is set, to maintain flexibility for running either
# finetune_data.py or run_mlm.py from the `docker run` command.
