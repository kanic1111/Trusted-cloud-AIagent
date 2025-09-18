# Trusted-cloud-AIagent

## Overview
This repository contains the Trusted Cloud AI Agent deployment configurations for Kubernetes environments.

## Repository Structure

### trusted-cloud-agent/
Contains the core agent deployment configurations:
- `kubernetes/` - Kubernetes YAML manifests for agent deployment
  - `agent/` - Agent service configurations including config.yaml, agent.yaml, ollama.yaml, and qdrant.yaml
  - `cert-manager/` - Certificate management configurations

### deploy-llm/
Contains LLM (Large Language Model) deployment configurations:
- `kubernetes/` - Kubernetes manifests for LLM services
  - `llama-factory/` - LlamaFactory deployment configurations
  - `vllm/` - vLLM deployment configurations  
  - `ollama/` - Ollama service configurations

## Getting Started

1. Review the Kubernetes manifests in the respective directories
2. Customize the configurations according to your environment
3. Deploy using kubectl or your preferred Kubernetes deployment method

## Components

- **Agent Service**: Core AI agent functionality
- **LlamaFactory**: Model training and fine-tuning service
- **vLLM**: High-performance LLM inference engine
- **Ollama**: Local LLM deployment service
- **Qdrant**: Vector database for embeddings

## Prerequisites

- Kubernetes cluster
- Appropriate resource allocations for AI workloads (if need to deploy LLM check requirement below)
- ingress-nginx controller (if wants to use ingress)
- cert-manager (if not using own TLS Cert)

## GPU Resource Requirements

| Component | Model Size | GPU Memory | Recommended GPU | Notes |
|-----------|------------|------------|-----------------|-------|
| **vLLM** | 7B | 16GB | RTX 4090, A100 40GB | High-performance inference |
| | 13B | 24GB | RTX 4090 (2x), A100 40GB | Requires tensor parallelism |
| | 30B+ | 48GB+ | A100 80GB, H100 | Large model deployment |
| **LlamaFactory** | 7B Training | 24GB | RTX 4090, A100 40GB | Fine-tuning workloads |
| | 13B Training | 40GB+ | A100 40GB/80GB | Memory-intensive training |
| **Ollama** | 7B | 8GB | RTX 3080, RTX 4070 | Lightweight deployment |
| | 13B | 16GB | RTX 4090, A100 40GB | Standard deployment |
| **Agent Service** | N/A | 2GB | Any modern GPU | Embedding/processing |
| **Qdrant** | N/A | N/A | CPU only | Vector database |

**Note**: These are approximate requirements. Actual usage may vary based on batch size, sequence length, and specific model configurations.