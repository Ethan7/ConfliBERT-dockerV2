# ConfliBERT Fine-Tuning and Experimentation Framework

This repository provides a complete, containerized environment for fine-tuning Transformer models (such as ConfliBERT, BERT, etc.) on various text classification and Named Entity Recognition (NER) tasks. The entire workflow is managed with Docker, ensuring a reproducible and easy-to-use setup across different machines (Mac, Windows, or Linux).

## Prerequisites

Before you begin, ensure you have the following installed on your system:

1.  **Git:** To clone the repository.
2.  **Docker Desktop:** To build and run the containerized application. Download it from the [official Docker website](https://www.docker.com/products/docker-desktop/).
    * **For GPU support on Windows/Linux:** You must also have the [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) installed.

## Project Setup

1.  **Clone the Repository**
    ```bash
    git clone <your-repository-url>
    cd ConfliBERT
    ```

2.  **Prepare Data and Configurations**
    This project is structured to read from `/data` and `/configs` directories.
    * **`/data`:** Place your dataset folders inside this directory (e.g., `/data/insightCrime/`). This directory is intentionally not tracked by Git.
    * **`/configs`:** Place your corresponding `.json` configuration files here.

## Docker-Based Workflow

This project uses a universal `Dockerfile` that can build an image for either CPU-only or GPU-accelerated environments.

### 1. Build the Docker Image

You only need to build the image once. Choose the command that matches your hardware.

**A) For Mac or PC without an NVIDIA GPU (CPU Version)**
Run this command from the `ConfliBERT` directory:
```bash
docker build --build-arg DEVICE=cpu -t confli-bert-runner:cpu .
```

**B) For PC with an NVIDIA GPU (GPU Version)**
Run this command from the `ConfliBERT` directory:

```bash
docker build --build-arg DEVICE=gpu -t confli-bert-runner:gpu .
```

### 2. Run an Experiment

Once the image is built, you can run any experiment. The command will mount your local `data`, `configs`, `outputs`, and `logs` directories into the container.

**A) To Run on CPU (Mac or PC without GPU)**
Use the `confli-bert-runner:cpu` image.

```bash
# On Mac or Linux
docker run --rm -it \
  -v "$(pwd)/data:/app/data" \
  -v "$(pwd)/configs:/app/configs" \
  -v "$(pwd)/../outputs:/app/outputs" \
  -v "$(pwd)/../logs:/app/logs" \
  confli-bert-runner:cpu \
  python3 finetune_data_cpu.py --dataset <your-dataset-name>

# On Windows (PowerShell)
docker run --rm -it \
  -v "${PWD}/data:/app/data" \
  -v "${PWD}/configs:/app/configs" \
  -v "${PWD}/../outputs:/app/outputs" \
  -v "${PWD}/../logs:/app/logs" \
  confli-bert-runner:cpu \
  python3 finetune_data_cpu.py --dataset <your-dataset-name>
```

**B) To Run on GPU (PC with NVIDIA GPU)**
Use the `confli-bert-runner:gpu` image and the `--gpus all` flag.

```bash
# On Linux or Windows (with NVIDIA Container Toolkit)
docker run --gpus all --rm -it \
  -v "$(pwd)/data:/app/data" \
  -v "$(pwd)/configs:/app/configs" \
  -v "$(pwd)/../outputs:/app/outputs" \
  -v "$(pwd)/../logs:/app/logs" \
  confli-bert-runner:gpu \
  python3 finetune_data.py --dataset <your-dataset-name>
```

*Note: The GPU version runs the original `finetune_data.py` script, while the CPU command runs the optimized `finetune_data_cpu.py`.*

### How It Works

  * **`Dockerfile`:** Contains all instructions to build a consistent Python environment with all libraries. It can build a CPU or GPU version based on a build argument.
  * **`finetune_data_cpu.py`:** The main script for running experiments, specifically optimized for CPU execution.
  * **`/configs`:** This directory holds `.json` files that define the parameters for each experiment, including the model to use, batch size, epochs, etc.
  * **`/data`:** This directory holds the training, validation, and test datasets.
  * **`/outputs` & `/logs`:** These directories are created outside the main project folder to store the results, saved models, and log files from your experiments.

After an experiment completes, your results will be available in the `outputs` and `logs` directories on your local machine.

---

## .gitignore

Create a file named `.gitignore` inside your `ConfliBERT` directory with the following content:

```
# Python
__pycache__/
*.pyc
.venv/
venv/

# Data, logs, and outputs - These should not be in the repository
/data/
/outputs/
/logs/

# OS-specific files
.DS_Store
Thumbs.db
```

*Note: `/data/` is ignored because datasets can be huge. Your README will instruct users to add their own data.*

---

## Citation
If you use this code, please cite the original ConfliBERT paper and repository.

---
For questions or issues, please open an issue in this repository.

---
Good evening from Rotterdam!

That is fantastic news! I'm thrilled that everything is working. Getting from a set of scripts to a fully containerized, debugged, and running machine learning workflow is a huge accomplishment. Congratulations!
