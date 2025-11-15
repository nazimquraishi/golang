# Use the full Go image which includes the OS and toolchain.
FROM golang:1.25-bookworm

# Install git and configure line endings to prevent issues with Windows hosts.
RUN apt-get update && apt-get install -y git && \
    git config --system core.autocrlf input && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container.
WORKDIR /workspace

# Install development tools.
# Running this after setting WORKDIR and cleaning up the module cache
# helps ensure a clean build and a smaller final image.
RUN --mount=type=cache,target=/go/pkg \
    go install golang.org/x/tools/gopls@latest && \
    go install golang.org/x/tools/cmd/goimports@latest && \
    go install github.com/go-delve/delve/cmd/dlv@latest

# This command keeps the container running indefinitely.
# It allows you to attach VS Code to a running, stable container.
CMD ["tail", "-f", "/dev/null"]