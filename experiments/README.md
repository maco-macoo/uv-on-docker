# Experiments Directory

各実験はここに独立したディレクトリとして配置されます。

## 実験の構成

各実験ディレクトリには以下が含まれます：

```
expN/
├── pyproject.toml      # 実験専用の依存関係定義
├── uv.lock            # 依存関係のロックファイル
└── src/
    └── exp/
        ├── __init__.py
        └── main.py    # メインスクリプト
```

## 利用可能な実験

- **exp1**: データ分析実験（numpy, pandas使用）
- **exp2**: NLP実験（torch, transformers使用）

## 新しい実験の作成

ルートディレクトリのREADMEを参照してください。