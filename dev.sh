#!/bin/bash
# 開発・デバッグ用の対話的セッション

EXP_NAME=${1:-exp1}
echo "Starting development session for: $EXP_NAME"
echo "Commands to run inside:"
echo "  cd experiments/$EXP_NAME"
echo "  uv sync"
echo "  uv run python -m src.exp.main"
echo ""

docker compose run --rm app bash