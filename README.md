# ConfliBERT Docker Setup

This repository provides a Dockerized environment for fine-tuning the ConfliBERT model for text classification and NER tasks. (Note: This setup is specifically for ConfliBERT, not for other BERT models.)

## Prerequisites
- **Docker Desktop**: Required for building and running containers. Download from [Docker's official site](https://www.docker.com/products/docker-desktop/).
- **Git (specifically Git, not Github Desktop)**: You can download from their website: https://git-scm.com/book/en/v2/Getting-Started-Installing-Git 
- **Sufficient resources**: For large models/datasets, increase CPU and memory allocation in Docker Desktop (see Notes below).
- **(Optional) NVIDIA GPU**: For GPU acceleration, install the [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html).

## Project Overview
ConfliBERT is a transformer-based model designed for event extraction, text classification, and named entity recognition (NER) in conflict and security-related datasets. This repository provides a reproducible, containerized workflow for training and evaluating ConfliBERT on your own data.

Supported tasks:
- Multi-label text classification
- Multi-class text classification
- Binary classification
- Named Entity Recognition (NER)

## Getting Started

### Clone the Repository

```bash
git clone https://github.com/shreyasmeher/ConfliBERT-docker.git
cd ConfliBERT-docker
```

### Prepare Your Data and Configs
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

## Example Configuration File

A typical config file (`configs/insightCrime.json`) might look like:
```json
{
  "task": "multilabel",
  "models": [
    {
      "architecture": "bert",
      "model_name": "ConfliBERT",
      "model_path": "eventdata/ConfliBERT-base-uncased"
    }
  ],
  "train_batch_size": 8,
  "epochs_per_seed": 3,
  "initial_seed": 42,
  "num_of_seeds": 1
}
```
- `task`: One of `multilabel`, `multiclass`, `binary`, or `ner`.
- `models`: List of model configs (architecture, name, path).
- `train_batch_size`, `epochs_per_seed`, etc.: Training parameters.

---

## Docker Build Instructions

### Build the Docker Image

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

## Advanced Usage

- **Run a different script:**
  ```bash
  docker run --rm -it confli-bert-runner:cpu python3 run_mlm.py --your-args
  ```
- **Override config at runtime:**
  ```bash
  docker run --rm -it confli-bert-runner:cpu python3 finetune_data_cpu.py --dataset insightCrime --train_batch_size 4
  ```
- **Mount additional volumes:**
  Add more `-v` flags to share other folders with the container.
- **Debugging:**
  Add `-it` for interactive mode and use `bash` to open a shell in the container.
  ```bash
  docker run --rm -it confli-bert-runner:cpu bash
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
- **Python Package Issues:**
  - If you see import errors, rebuild the Docker image to ensure all dependencies are installed.
- **GPU Not Detected:**
  - Make sure you have the NVIDIA Container Toolkit installed and use the `--gpus all` flag.

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

**Q: How do I check logs and outputs?**
A: All logs and outputs are saved in the `logs/` and `outputs/` directories, which are mounted to your local machine.

**Q: Can I use this setup for other BERT models?**
A: No, this setup is specifically for ConfliBERT. For other models, you may need to modify the code and Dockerfile.

---

For troubleshooting or advanced usage, see the Dockerfile and scripts in this repository.
