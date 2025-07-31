"""Experiment 1: Data analysis example."""
import numpy as np
import pandas as pd


def main():
    print("Running Experiment 1")
    data = np.random.randn(100, 3)
    df = pd.DataFrame(data, columns=['A', 'B', 'C'])
    print(f"Generated data shape: {df.shape}")
    print(df.describe())


if __name__ == "__main__":
    main()