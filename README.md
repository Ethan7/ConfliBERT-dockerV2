# ConfliBERT Docker Setup

This repository provides a Dockerized environment for fine-tuning the ConfliBERT model for text classification and NER tasks. (Note: This setup is specifically for ConfliBERT, not for other BERT models.)

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/shreyasmeher/ConfliBERT-docker.git
cd ConfliBERT-docker
```

### 2. Prepare Your Data and Configs
- Place your datasets in the `data/` directory.
- Place your configuration files in the `configs/` directory.

---

## Docker Build Instructions

### 1. Build the Docker Image

**For CPU-only (Mac/PC without NVIDIA GPU):**
```bash
docker build --build-arg DEVICE=cpu -t confli-bert-runner:cpu .
```

**For GPU (PC with NVIDIA GPU):**
```bash
docker build --build-arg DEVICE=gpu -t confli-bert-runner:gpu .
```

---

## Running Experiments

**Run on CPU:**
```bash
docker run --rm -it \
  -v "$(pwd)/data:/app/data" \
  -v "$(pwd)/configs:/app/configs" \
  -v "$(pwd)/../outputs:/app/outputs" \
  -v "$(pwd)/../logs:/app/logs" \
  confli-bert-runner:cpu \
  python3 finetune_data_cpu.py --dataset <your-dataset-name>
```

**Run on GPU:**
```bash
docker run --gpus all --rm -it \
  -v "$(pwd)/data:/app/data" \
  -v "$(pwd)/configs:/app/configs" \
  -v "$(pwd)/../outputs:/app/outputs" \
  -v "$(pwd)/../logs:/app/logs" \
  confli-bert-runner:gpu \
  python3 finetune_data.py --dataset <your-dataset-name>
```

---

## Pushing Docker Images to Docker Hub

1. **Login to Docker Hub:**
   ```bash
   docker login
   ```
2. **Tag your image:**
   ```bash
   docker tag confli-bert-runner:cpu <your-dockerhub-username>/confli-bert-runner:cpu
   docker tag confli-bert-runner:gpu <your-dockerhub-username>/confli-bert-runner:gpu
   ```
3. **Push your image:**
   ```bash
   docker push <your-dockerhub-username>/confli-bert-runner:cpu
   docker push <your-dockerhub-username>/confli-bert-runner:gpu
   ```

---

## Notes
- Place your datasets in the `data/` directory and configs in `configs/`.
- Outputs and logs will be saved in `outputs/` and `logs/`.
- No ENTRYPOINT is set; you can run any script inside the container.
- **Resource Allocation:** For best performance, you may need to increase the number of CPUs and memory allocated to Docker Desktop. Go to Docker Desktop > Settings > Resources and adjust the sliders as needed, especially for large models or datasets.

---

For troubleshooting or advanced usage, see the Dockerfile and scripts in this repository.
