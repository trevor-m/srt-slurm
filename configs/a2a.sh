#!/bin/bash
BRANCH="a2a-trtllm-routed"

cd /sgl-workspace/sglang
git remote add trevor https://github.com/trevor-m/sglang.git
git fetch trevor
git checkout trevor/${BRANCH}
