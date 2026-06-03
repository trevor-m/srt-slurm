# SPDX-FileCopyrightText: Copyright (c) 2025 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

"""GPQA accuracy benchmark runner backed by NVIDIA NeMo Skills (ns)."""

from __future__ import annotations

from typing import TYPE_CHECKING

from srtctl.benchmarks.base import SCRIPTS_DIR, BenchmarkRunner, register_benchmark

if TYPE_CHECKING:
    from srtctl.core.runtime import RuntimeContext
    from srtctl.core.schema import SrtConfig


@register_benchmark("ns-gpqa")
class NSGPQARunner(BenchmarkRunner):
    """GPQA (Graduate-level science QA) accuracy evaluation via NeMo Skills.

    Follows the steps in
    https://github.com/sgl-project/sglang/blob/deepseek_v4/scripts/bench_gpqa_aime25.py:
    installs NeMo Skills, prepares the GPQA diamond split, and runs `ns eval`
    against the OpenAI-compatible endpoint.

    Optional config fields:
        - benchmark.num_examples: Number of examples (default: 198)
        - benchmark.max_tokens: Max tokens to generate per response (default: 400000)
        - benchmark.repeat: Number of repeats per question (default: 8)
        - benchmark.num_threads: Max concurrent requests (default: 512)
        - benchmark.result_dir: Container path for results (default: /logs/accuracy)
    """

    @property
    def name(self) -> str:
        return "NS-GPQA"

    @property
    def script_path(self) -> str:
        return "/srtctl-benchmarks/ns-gpqa/bench.sh"

    @property
    def local_script_dir(self) -> str:
        return str(SCRIPTS_DIR / "ns-gpqa")

    def validate_config(self, config: SrtConfig) -> list[str]:
        # NS-GPQA has sensible defaults
        return []

    def build_command(
        self,
        config: SrtConfig,
        runtime: RuntimeContext,
    ) -> list[str]:
        b = config.benchmark
        endpoint = f"http://localhost:{runtime.frontend_port}"

        return [
            "bash",
            self.script_path,
            endpoint,
            str(b.num_examples or 198),
            str(b.max_tokens or 400000),
            str(b.repeat or 8),
            str(b.num_threads or 512),
            b.result_dir or "/logs/accuracy",
        ]
