#!/bin/bash
# SPDX-FileCopyrightText: Copyright (c) 2025 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
BRANCH="dsv4-fp4"

cd /sgl-workspace/sglang
git remote remove origin
git remote add origin https://github.com/trevor-m/sglang.git
git fetch origin
git checkout origin/${BRANCH}

git cherry-pick 4efe6675af3a17846cfa8296e8476526372eaefc
