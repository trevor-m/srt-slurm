#!/bin/bash
# SPDX-FileCopyrightText: Copyright (c) 2025 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

# GPQA accuracy evaluation via NVIDIA NeMo Skills (ns).
# Follows https://github.com/sgl-project/sglang/blob/deepseek_v4/scripts/bench_gpqa_aime25.py
# Expects: endpoint [num_examples] [max_tokens] [repeat] [num_threads] [result_dir]

set -e

ENDPOINT=$1
NUM_EXAMPLES=${2:-198}
MAX_TOKENS=${3:-400000}
REPEAT=${4:-8}
NUM_THREADS=${5:-512}
RESULT_DIR=${6:-/logs/accuracy}
STARTING_SEED=${STARTING_SEED:-7023}

# Auto-detect model name from /v1/models endpoint; fall back to default
MODEL_NAME=$(curl -s "${ENDPOINT}/v1/models" 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin)['data'][0]['id'])" 2>/dev/null || echo "")
if [ -z "${MODEL_NAME}" ]; then
    MODEL_NAME="deepseek-ai/DeepSeek-V4-Pro"
    echo "Warning: Could not auto-detect model name, using default: ${MODEL_NAME}"
fi

if [ -z "${HF_TOKEN}" ]; then
    echo "ERROR: HF_TOKEN is not set." >&2
    exit 1
fi

echo "GPQA Config: endpoint=${ENDPOINT}; model=${MODEL_NAME}; num_examples=${NUM_EXAMPLES}; max_tokens=${MAX_TOKENS}; repeat=${REPEAT}; num_threads=${NUM_THREADS}; result_dir=${RESULT_DIR}; seed=${STARTING_SEED}"

# Create results directory
mkdir -p "${RESULT_DIR}"

uv venv /sgl-workspace/ns-venv
source /sgl-workspace/ns-venv/bin/activate

uv pip install git+https://github.com/NVIDIA-NeMo/Skills.git@d77caab 'tree_sitter_language_pack<1.0' --reinstall-package blinker
ns prepare_data gpqa --split diamond
ns eval \
  --server_type=openai \
  --model=${MODEL_NAME} \
  --server_address=${ENDPOINT}/v1 \
  --benchmarks=gpqa:${REPEAT} \
  --output_dir=${RESULT_DIR} \
  ++inference.tokens_to_generate=${MAX_TOKENS} \
  ++max_concurrent_requests=${NUM_THREADS} \
  ++inference.temperature=1.0 \
  ++inference.top_p=1.0 \
  ++inference.timeout=25000000 \
  --starting_seed ${STARTING_SEED}

echo "GPQA evaluation complete; results in ${RESULT_DIR}"
