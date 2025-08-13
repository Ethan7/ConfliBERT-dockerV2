# ConfliBERT CPU-Only Fine-Tuning

This repository contains a CPU-optimized version of the ConfliBERT fine-tuning script for text classification and named entity recognition tasks. It is designed for environments without GPU support and includes all necessary modifications for efficient CPU training.

## Features
- Explicit CPU device usage (no CUDA/GPU required)
- Disabled mixed precision training (fp16)
- CPU-optimized batch sizes and configurations
- Multiprocessing disabled for compatibility
- Supports multilabel, multiclass, binary classification, and NER tasks

## Usage

### 1. Install Requirements
Install dependencies using the provided requirements file:

```bash
pip install -r requirements-cpu.txt
```

### 2. Prepare Data & Configs
- Place your dataset in the `data/` directory (see examples in the repo)
- Place your configuration JSON files in the `configs/` directory

### 3. Run Fine-Tuning
Run the CPU-only script with your desired arguments:

```bash
python finetune_data_cpu.py --dataset <DATASET_NAME> [--report_per_epoch]
```

Example:
```bash
python finetune_data_cpu.py --dataset insightCrime --report_per_epoch
```

### 4. Outputs
- Model checkpoints and logs are saved in the `outputs/` and `logs/` directories
- Results are written to CSV and JSON files with `_cpu` suffix for easy identification

## Notes
- Batch size is automatically capped at 8 for CPU efficiency
- All multiprocessing is disabled for maximum compatibility
- Training will be slower than GPU, but works on any machine

## Repository Structure
- `finetune_data_cpu.py`: Main CPU-only fine-tuning script
- `requirements-cpu.txt`: Python dependencies for CPU
- `configs/`: Example configuration files
- `data/`: Example datasets
- `outputs/`, `logs/`: Output and log directories

## Citation
If you use this code, please cite the original ConfliBERT paper and repository.

---
For questions or issues, please open an issue in this repository.
