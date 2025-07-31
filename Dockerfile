FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

# Install git
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# uv environment variables for performance
ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy

# Skip global dependency installation since each experiment has its own

# Copy project scripts and experiment structure
COPY . /workspace

# Add virtual environment to PATH for automatic activation
ENV PATH="/workspace/.venv/bin:$PATH"

CMD ["bash"]
