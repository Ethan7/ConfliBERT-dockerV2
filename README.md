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

## Directory Structure

- `data/` — Place your datasets here. Each dataset should be in its own subfolder (e.g., `data/insightCrime/`).
- `configs/` — Place your experiment configuration JSON files here.
- `outputs/` — Model checkpoints and results will be saved here (created automatically).
- `logs/` — Training and evaluation logs will be saved here (created automatically).
- `Dockerfile` — The container build instructions for CPU/GPU environments.
- `finetune_data_cpu.py` — Main script for CPU-only fine-tuning.
- `finetune_data.py` — Main script for GPU fine-tuning.
- `requirements-cpu.txt` / `requirements-gpu.txt` — Python dependencies for each environment.

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

## Troubleshooting

- **Volume Mounting Issues (Windows):**
  - Use PowerShell and ensure paths are correct. Try using absolute paths if you encounter errors.
- **Memory/CPU Errors:**
  - Increase resource allocation in Docker Desktop (see Notes above).
- **File Permissions:**
  - If you see permission errors, try running Docker with elevated privileges or check your folder permissions.
- **Container Fails to Start:**
  - Check your Docker build logs for missing dependencies or typos in the Dockerfile.
- **Output/Logs Not Appearing:**
  - Ensure the output and log directories exist and are correctly mounted.

---

## FAQ

**Q: Can I use my own dataset?**
A: Yes! Place your dataset in a new subfolder under `data/` and update your config file in `configs/` to point to it.

**Q: How do I change the model or experiment parameters?**
A: Edit the relevant JSON config file in `configs/` to set model architecture, batch size, epochs, etc.

**Q: Can I run other scripts inside the container?**
A: Yes, you can run any Python script included in the repo by specifying it in the `docker run` command.

**Q: What if I run out of memory or get killed containers?**
A: Increase Docker Desktop's resource allocation and/or reduce batch size in your config.

---

For troubleshooting or advanced usage, see the Dockerfile and scripts in this repository.
