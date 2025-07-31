#!/bin/bash
# 本番実行用（ログ付き、バックグラウンド実行）

if [ $# -eq 0 ]; then
    echo "Usage: $0 <experiment_name>"
    echo "Available experiments:"
    ls experiments/
    exit 1
fi

EXP_NAME=$1
JOB="${EXP_NAME}-$(date +%y%m%d-%H%M%S)"

echo "Starting experiment: $EXP_NAME"
echo "Job name: $JOB"

docker compose run -d --name "$JOB" app \
    bash -lc "cd experiments/${EXP_NAME} && uv sync && uv run python -m src.exp.main"

# Follow logs
echo "Following logs... (Ctrl+C to stop following, container continues)"
docker logs -f "$JOB"