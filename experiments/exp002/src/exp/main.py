"""Experiment 2: NLP example."""
import torch
from transformers import AutoTokenizer


def main():
    print("Running Experiment 2")
    print(f"PyTorch version: {torch.__version__}")
    
    # Simple tokenizer example
    tokenizer = AutoTokenizer.from_pretrained("bert-base-uncased")
    text = "Hello, this is experiment 2!"
    tokens = tokenizer.encode(text)
    print(f"Tokenized: {tokens}")


if __name__ == "__main__":
    main()