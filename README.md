# UV Docker Template

Python実験環境をuvとDockerで構築するテンプレートプロジェクト

## 📁 プロジェクト構成

```
uv-on-docker/
├── Dockerfile              # Docker設定
├── docker-compose.yaml     # Docker Compose設定
├── dev.sh                 # 開発用スクリプト（対話実行）
├── run_experiment.sh      # 本番用スクリプト（ログ付き実行）
└── experiments/           # 実験ディレクトリ
    ├── exp001/              # 実験1（データ分析）
    │   ├── pyproject.toml # exp1専用依存関係
    │   ├── uv.lock       # 依存関係ロックファイル
    │   └── src/exp/main.py
    └── exp002/              # 実験2（NLP）
        ├── pyproject.toml # exp2専用依存関係
        ├── uv.lock       # 依存関係ロックファイル
        └── src/exp/main.py
```

## 🚀 クイックスタート

### 1. 環境の準備

```bash
# リポジトリをクローン
git clone <repository-url>
cd uv-on-docker

# Dockerイメージをビルド
docker compose build
```

### 2. 実験の実行

#### 開発・デバッグモード（対話的）

```bash
# bashに入って対話的に実行
./dev.sh

# コンテナ内で実験を実行
cd experiments/exp1
uv sync                          # 依存関係インストール
uv run python -m src.exp.main   # 実験実行
```

#### 本番実行モード（ログ付き）

```bash
# exp1を実行（データ分析）
./run_experiment.sh exp001

# exp2を実行（NLP）
./run_experiment.sh exp002
```

## 💡 使用方法

### 開発・デバッグ時

**特徴：**
- 対話的な実行環境
- エラー時の即座デバッグ
- Jupyter Notebook対応
- 試行錯誤に最適

```bash
./dev.sh

# コンテナ内で:
cd experiments/exp1
uv add matplotlib seaborn      # 依存関係追加
uv run jupyter lab --ip=0.0.0.0 --allow-root  # Jupyter起動
```

### 本番実行時

**特徴：**
- バックグラウンド実行
- 完全なログ記録
- 複数実験の並列実行
- 自動リソース管理

```bash
# 単一実験実行
./run_experiment.sh exp001

# 複数実験の並列実行
./run_experiment.sh exp001 &
./run_experiment.sh exp002 &
```

### ログの確認

```bash
# 実行中のログをリアルタイム表示
docker logs -f <コンテナ名>

# 完了後のログ確認
docker logs <コンテナ名>

# 過去の実験コンテナ一覧
docker ps -a --filter "name=exp"
```

### コンテナの管理・削除

```bash
# 実行中のコンテナ確認
docker ps

# 全てのコンテナ確認（停止済み含む）
docker ps -a

# 特定のコンテナを停止
docker stop <コンテナ名>

# 特定のコンテナを削除
docker rm <コンテナ名>

# 実験コンテナを一括削除
docker rm $(docker ps -a --filter "name=exp-" -q)

# 停止中のコンテナを一括削除
docker container prune

# 孤立したコンテナをクリーンアップ
docker compose down --remove-orphans

# 未使用のイメージ・ボリューム・ネットワークを削除
docker system prune -a

# ディスク使用量の確認
docker system df
```

## 🧪 新しい実験の作成

```bash
# 新実験ディレクトリ作成
mkdir -p experiments/exp003/src/exp

# pyproject.toml作成
cat > experiments/exp003/pyproject.toml << EOF
[project]
name = "exp003"
version = "0.1.0"
requires-python = ">=3.12"
dependencies = [
    "scikit-learn",
    "matplotlib",
]

[tool.uv]
dev-dependencies = [
    "pytest",
    "jupyter",
]
EOF

# メインスクリプト作成
cat > experiments/exp003/src/exp/main.py << EOF
"""Experiment 3: Machine Learning example."""
from sklearn.datasets import make_classification
from sklearn.ensemble import RandomForestClassifier

def main():
    print("Running Experiment 3: Machine Learning")
    X, y = make_classification(n_samples=1000, n_features=20, random_state=42)
    clf = RandomForestClassifier(random_state=42)
    clf.fit(X, y)
    print(f"Model accuracy: {clf.score(X, y):.3f}")

if __name__ == "__main__":
    main()
EOF

# __init__.pyファイル作成
touch experiments/exp003/src/__init__.py
touch experiments/exp003/src/exp/__init__.py

# ロックファイル生成
docker compose run --rm app bash -lc "cd experiments/exp003 && uv lock"

# 実験実行
./run_experiment.sh exp003
```

## 📊 利用可能な実験例

### exp1: データ分析実験
- **依存関係**: numpy, pandas
- **用途**: データ処理、統計分析
- **実行**: `./run_experiment.sh exp1`

### exp2: NLP実験
- **依存関係**: torch, transformers
- **用途**: 自然言語処理、機械学習
- **実行**: `./run_experiment.sh exp2`

## 🔧 高度な使用法

### Jupyter Notebook開発

```bash
./dev.sh
# コンテナ内で:
cd experiments/exp1
uv add jupyter
uv run jupyter lab --ip=0.0.0.0 --port=8888 --allow-root --no-browser
# ブラウザで http://localhost:8888 にアクセス
```

### GPU利用（CUDA対応）

```yaml
# docker-compose.yamlに追加
services:
  app:
    # ... 既存設定
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
```

### VSCode Dev Container

```json
// .devcontainer/devcontainer.jsonを作成
{
    "name": "UV Python Environment",
    "dockerComposeFile": "../docker-compose.yaml",
    "service": "app",
    "workspaceFolder": "/workspace",
    "extensions": [
        "ms-python.python",
        "ms-python.black-formatter"
    ]
}
```

## 🛠️ トラブルシューティング

### よくある問題

**lockファイルが見つからない:**
```bash
docker compose run --rm app bash -lc "cd experiments/exp001 && uv lock"
```

**孤立コンテナの警告:**
```bash
docker compose down --remove-orphans
```

**依存関係の競合:**
```bash
# 実験ディレクトリで
rm uv.lock
uv lock --upgrade
```

**メモリ不足:**
```bash
# Docker設定でメモリ上限を調整
docker system prune -a  # 不要なイメージ・コンテナ削除
docker volume prune     # 未使用ボリューム削除
```

**大量の実験コンテナが蓄積:**
```bash
# 実験コンテナのみ削除
docker rm $(docker ps -a --filter "name=exp-" -q)

# 24時間以上前のコンテナを削除
docker container prune --filter "until=24h"
```

**ディスク容量不足:**
```bash
# 現在の使用量確認
docker system df

# 全体的なクリーンアップ
docker system prune -a --volumes

# 特定期間より古いイメージを削除
docker image prune --filter "until=168h"  # 1週間前
```

### デバッグのヒント

1. **コンテナ内での直接実行**
   ```bash
   docker compose run --rm app bash
   cd experiments/exp1
   uv run python -c "import sys; print(sys.path)"
   ```

2. **依存関係の確認**
   ```bash
   uv pip list
   uv pip show <package-name>
   ```

3. **パフォーマンス分析**
   ```bash
   uv run python -m cProfile -o profile.stats src/exp/main.py
   ```

## 🔄 ベストプラクティス

### 1. 実験の命名規則
```bash
# 日付ベース
experiments/2024-01-15-sentiment-analysis/
# 機能ベース  
experiments/bert-fine-tuning/
# バージョンベース
experiments/model-v1.2/
```

### 2. 依存関係管理
```toml
# pyproject.tomlで具体的なバージョン指定
dependencies = [
    "torch==2.1.0",
    "transformers>=4.30.0,<5.0.0",
]
```

### 3. ログの整理
```bash
# ログディレクトリ作成
mkdir -p logs/experiments
# 実験ログを保存
./run_experiment.sh exp1 2>&1 | tee logs/experiments/exp1-$(date +%Y%m%d).log
```

### 4. リソース管理
```bash
# 定期的なクリーンアップスクリプト
cat > cleanup.sh << 'EOF'
#!/bin/bash
echo "=== Docker リソース使用量 ==="
docker system df

echo "=== 停止中のコンテナ削除 ==="
docker container prune -f

echo "=== 実験コンテナ（7日以上前）削除 ==="
docker container prune --filter "until=168h" -f

echo "=== 未使用イメージ削除 ==="
docker image prune -f

echo "=== クリーンアップ完了 ==="
docker system df
EOF

chmod +x cleanup.sh
# 週次実行: crontab -e で "0 2 * * 0 /path/to/cleanup.sh" を追加
```

## 📝 必要環境

- **Docker**: 20.10以上
- **Docker Compose**: 2.0以上
- **システム要件**: 
  - メモリ: 最小4GB、推奨8GB以上
  - ストレージ: 10GB以上の空き容量

## 🤝 貢献

1. このリポジトリをフォーク
2. 新機能ブランチを作成 (`git checkout -b feature/amazing-feature`)
3. 変更をコミット (`git commit -m 'Add amazing feature'`)
4. ブランチにプッシュ (`git push origin feature/amazing-feature`)
5. Pull Requestを作成

## 📄 ライセンス

このプロジェクトはMITライセンスの下で公開されています。詳細は`LICENSE`ファイルを参照してください。