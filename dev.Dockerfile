# Use the full Go image which includes the OS and toolchain.
FROM golang:1.22-bookworm

# Install Delve, the Go debugger, and other common tools.
# Delve is essential for debugging with VS Code.
RUN go install github.com/go-delve/delve/cmd/dlv@latest

# Set the working directory inside the container.
WORKDIR /workspace

# This command keeps the container running indefinitely.
# It allows you to attach VS Code to a running, stable container.
CMD ["tail", "-f", "/dev/null"]