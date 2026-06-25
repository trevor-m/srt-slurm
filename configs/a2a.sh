#!/bin/bash
# SPDX-FileCopyrightText: Copyright (c) 2025 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0"
BRANCH="a2a-trtllm-routed"
cd /sgl-workspace/sglang
git remote remove origin
git remote add origin https://github.com/trevor-m/sglang.git
git fetch origin
git checkout origin/${BRANCH}
git cherry-pick a7dd0a2bea211af8ffd7d7560f806f98bd603c73
