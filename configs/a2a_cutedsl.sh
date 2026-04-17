#!/bin/bash
BRANCH="a2afix" #feat/enable-fp4cutedslmoe+a2a

cd /sgl-workspace/sglang
git remote add trevor https://github.com/trevor-m/sglang.git #https://github.com/samuellees/sglang.git
git fetch trevor
git checkout trevor/${BRANCH}
