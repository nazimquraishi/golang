# Go Docker Development Environment

This guide provides a complete setup for a Go development environment using Docker, with a focus on creating a high-capacity web server that you can deploy on a Virtual Private Server (VPS).

## Understanding the Approach

We use a multi-stage Docker build, which is a best practice for creating small, optimized production images.

*   **Build Stage:** This stage includes the Go compiler and all necessary tools to build the application. We copy the source code, download dependencies, and compile the application.
*   **Final Stage:** This is a minimal `alpine` image. We copy only the compiled application from the build stage into this lightweight image. This results in a much smaller and more secure production container.

## Web Framework: Gin

For a high-capacity web server, a fast framework with a low memory footprint is ideal. We are using **Gin** for its popularity, performance, and extensive documentation.

## Project Files

--- a/c:\Users\nazim\source\golang\Dockerfile
+++ b/c:\Users\nazim\source\golang\Dockerfile
@@ -1,28 +1,38 @@
 # ---- Build Stage ----
-# Use the official Go image, with an Alpine base for a smaller size.
-# 'AS builder' names this stage, so we can refer to it later.
-FROM golang:1.22-alpine AS builder
+# Use the official Go image. 'AS builder' names this stage.
+FROM golang:1.22-alpine AS builder
 
 # Set the working directory inside the container
 WORKDIR /app
 
-# Copy go.mod and go.sum files to download dependencies.
-# This is done as a separate step to leverage Docker's layer caching.
-# Dependencies will only be re-downloaded if go.mod or go.sum change.
+# Install air for live reloading in development
+RUN go install github.com/cosmtrek/air@latest
+
+# Copy go.mod and go.sum files to download dependencies
 COPY go.mod go.sum ./
 RUN go mod download
 
-# Copy the rest of the application source code
-COPY . .
+# Copy the source code from the src directory
+COPY ./src ./src
 
 # Build the Go application.
-# -o /app/main specifies the output file name and location.
-# CGO_ENABLED=0 disables Cgo, creating a static binary which is needed for a minimal 'scratch' or 'alpine' final image.
-# GOOS=linux ensures the binary is built for a Linux environment.
-RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /app/main .
+# The output binary is named 'main'
+RUN CGO_ENABLED=0 GOOS=linux go build -o /app/main ./src/main.go
 
 # ---- Final Stage ----
-# Use a minimal base image for the final container.
-# Alpine is a good choice as it's very small and secure.
+# Use a minimal alpine image for the final container.
 FROM alpine:latest
 
+# Set the working directory
 WORKDIR /app
 
-# Copy only the compiled application binary from the 'builder' stage.
-# This keeps the final image small and free of build tools and source code.
+# Copy the built application binary from the 'builder' stage
 COPY --from=builder /app/main .
 
-# Expose port 8080 to allow traffic to the container.
+# Also copy the 'air' binary for development
+COPY --from=builder /go/bin/air /usr/local/bin/air
+
+# Expose port 8080
 EXPOSE 8080
 
-# Command to run the executable when the container starts.
-CMD ["/app/main"]
+# The default command is to run the compiled binary for production.
+# For development, 'air' will be used via docker-compose to watch for changes.
+CMD ["/app/main"]

--- a/c:\Users\nazim\source\golang\Dockerfile
+++ b/c:\Users\nazim\source\golang\Dockerfile
@@ -1,28 +1,38 @@
 # ---- Build Stage ----
-# Use the official Go image, with an Alpine base for a smaller size.
-# 'AS builder' names this stage, so we can refer to it later.
-FROM golang:1.22-alpine AS builder
+# Use the official Go image. 'AS builder' names this stage.
+FROM golang:1.22-alpine AS builder
 
 # Set the working directory inside the container
 WORKDIR /app
 
-# Copy go.mod and go.sum files to download dependencies.
-# This is done as a separate step to leverage Docker's layer caching.
-# Dependencies will only be re-downloaded if go.mod or go.sum change.
+# Install air for live reloading in development
+RUN go install github.com/cosmtrek/air@latest
+
+# Copy go.mod and go.sum files to download dependencies
 COPY go.mod go.sum ./
 RUN go mod download
 
-# Copy the rest of the application source code
-COPY . .
+# Copy the source code from the src directory
+COPY ./src ./src
 
 # Build the Go application.
-# -o /app/main specifies the output file name and location.
-# CGO_ENABLED=0 disables Cgo, creating a static binary which is needed for a minimal 'scratch' or 'alpine' final image.
-# GOOS=linux ensures the binary is built for a Linux environment.
-RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /app/main .
+# The output binary is named 'main'
+RUN CGO_ENABLED=0 GOOS=linux go build -o /app/main ./src/main.go
 
 # ---- Final Stage ----
-# Use a minimal base image for the final container.
-# Alpine is a good choice as it's very small and secure.
+# Use a minimal alpine image for the final container.
 FROM alpine:latest
 
+# Set the working directory
 WORKDIR /app
 
-# Copy only the compiled application binary from the 'builder' stage.
-# This keeps the final image small and free of build tools and source code.
+# Copy the built application binary from the 'builder' stage
 COPY --from=builder /app/main .
 
-# Expose port 8080 to allow traffic to the container.
+# Also copy the 'air' binary for development
+COPY --from=builder /go/bin/air /usr/local/bin/air
+
+# Expose port 8080
 EXPOSE 8080
 
-# Command to run the executable when the container starts.
-CMD ["/app/main"]
+# The default command is to run the compiled binary for production.
+# For development, 'air' will be used via docker-compose to watch for changes.
+CMD ["/app/main"]

--- a/c:\Users\nazim\source\golang\Dockerfile
+++ b/c:\Users\nazim\source\golang\Dockerfile
@@ -1,28 +1,38 @@
 # ---- Build Stage ----
-# Use the official Go image, with an Alpine base for a smaller size.
-# 'AS builder' names this stage, so we can refer to it later.
-FROM golang:1.22-alpine AS builder
+# Use the official Go image. 'AS builder' names this stage.
+FROM golang:1.22-alpine AS builder
 
 # Set the working directory inside the container
 WORKDIR /app
 
-# Copy go.mod and go.sum files to download dependencies.
-# This is done as a separate step to leverage Docker's layer caching.
-# Dependencies will only be re-downloaded if go.mod or go.sum change.
+# Install air for live reloading in development
+RUN go install github.com/cosmtrek/air@latest
+
+# Copy go.mod and go.sum files to download dependencies
 COPY go.mod go.sum ./
 RUN go mod download
 
-# Copy the rest of the application source code
-COPY . .
+# Copy the source code from the src directory
+COPY ./src ./src
 
 # Build the Go application.
-# -o /app/main specifies the output file name and location.
-# CGO_ENABLED=0 disables Cgo, creating a static binary which is needed for a minimal 'scratch' or 'alpine' final image.
-# GOOS=linux ensures the binary is built for a Linux environment.
-RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /app/main .
+# The output binary is named 'main'
+RUN CGO_ENABLED=0 GOOS=linux go build -o /app/main ./src/main.go
 
 # ---- Final Stage ----
-# Use a minimal base image for the final container.
-# Alpine is a good choice as it's very small and secure.
+# Use a minimal alpine image for the final container.
 FROM alpine:latest
 
+# Set the working directory
 WORKDIR /app
 
-# Copy only the compiled application binary from the 'builder' stage.
-# This keeps the final image small and free of build tools and source code.
+# Copy the built application binary from the 'builder' stage
 COPY --from=builder /app/main .
 
-# Expose port 8080 to allow traffic to the container.
+# Also copy the 'air' binary for development
+COPY --from=builder /go/bin/air /usr/local/bin/air
+
+# Expose port 8080
 EXPOSE 8080
 
-# Command to run the executable when the container starts.
-CMD ["/app/main"]
+# The default command is to run the compiled binary for production.
+# For development, 'air' will be used via docker-compose to watch for changes.
+CMD ["/app/main"]

--- a/c:\Users\nazim\source\golang\Dockerfile
+++ b/c:\Users\nazim\source\golang\Dockerfile
@@ -1,28 +1,38 @@
 # ---- Build Stage ----
-# Use the official Go image, with an Alpine base for a smaller size.
-# 'AS builder' names this stage, so we can refer to it later.
-FROM golang:1.22-alpine AS builder
+# Use the official Go image. 'AS builder' names this stage.
+FROM golang:1.22-alpine AS builder
 
 # Set the working directory inside the container
 WORKDIR /app
 
-# Copy go.mod and go.sum files to download dependencies.
-# This is done as a separate step to leverage Docker's layer caching.
-# Dependencies will only be re-downloaded if go.mod or go.sum change.
+# Install air for live reloading in development
+RUN go install github.com/cosmtrek/air@latest
+
+# Copy go.mod and go.sum files to download dependencies
 COPY go.mod go.sum ./
 RUN go mod download
 
-# Copy the rest of the application source code
-COPY . .
+# Copy the source code from the src directory
+COPY ./src ./src
 
 # Build the Go application.
-# -o /app/main specifies the output file name and location.
-# CGO_ENABLED=0 disables Cgo, creating a static binary which is needed for a minimal 'scratch' or 'alpine' final image.
-# GOOS=linux ensures the binary is built for a Linux environment.
-RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /app/main .
+# The output binary is named 'main'
+RUN CGO_ENABLED=0 GOOS=linux go build -o /app/main ./src/main.go
 
 # ---- Final Stage ----
-# Use a minimal base image for the final container.
-# Alpine is a good choice as it's very small and secure.
+# Use a minimal alpine image for the final container.
 FROM alpine:latest
 
+# Set the working directory
 WORKDIR /app
 
-# Copy only the compiled application binary from the 'builder' stage.
-# This keeps the final image small and free of build tools and source code.
+# Copy the built application binary from the 'builder' stage
 COPY --from=builder /app/main .
 
-# Expose port 8080 to allow traffic to the container.
+# Also copy the 'air' binary for development
+COPY --from=builder /go/bin/air /usr/local/bin/air
+
+# Expose port 8080
 EXPOSE 8080
 
-# Command to run the executable when the container starts.
-CMD ["/app/main"]
+# The default command is to run the compiled binary for production.
+# For development, 'air' will be used via docker-compose to watch for changes.
+CMD ["/app/main"]

--- a/c:\Users\nazim\source\golang\Dockerfile
+++ b/c:\Users\nazim\source\golang\Dockerfile
@@ -1,28 +1,38 @@
 # ---- Build Stage ----
-# Use the official Go image, with an Alpine base for a smaller size.
-# 'AS builder' names this stage, so we can refer to it later.
-FROM golang:1.22-alpine AS builder
+# Use the official Go image. 'AS builder' names this stage.
+FROM golang:1.22-alpine AS builder
 
 # Set the working directory inside the container
 WORKDIR /app
 
-# Copy go.mod and go.sum files to download dependencies.
-# This is done as a separate step to leverage Docker's layer caching.
-# Dependencies will only be re-downloaded if go.mod or go.sum change.
+# Install air for live reloading in development
+RUN go install github.com/cosmtrek/air@latest
+
+# Copy go.mod and go.sum files to download dependencies
 COPY go.mod go.sum ./
 RUN go mod download
 
-# Copy the rest of the application source code
-COPY . .
+# Copy the source code from the src directory
+COPY ./src ./src
 
 # Build the Go application.
-# -o /app/main specifies the output file name and location.
-# CGO_ENABLED=0 disables Cgo, creating a static binary which is needed for a minimal 'scratch' or 'alpine' final image.
-# GOOS=linux ensures the binary is built for a Linux environment.
-RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /app/main .
+# The output binary is named 'main'
+RUN CGO_ENABLED=0 GOOS=linux go build -o /app/main ./src/main.go
 
 # ---- Final Stage ----
-# Use a minimal base image for the final container.
-# Alpine is a good choice as it's very small and secure.
+# Use a minimal alpine image for the final container.
 FROM alpine:latest
 
+# Set the working directory
 WORKDIR /app
 
-# Copy only the compiled application binary from the 'builder' stage.
-# This keeps the final image small and free of build tools and source code.
+# Copy the built application binary from the 'builder' stage
 COPY --from=builder /app/main .
 
-# Expose port 8080 to allow traffic to the container.
+# Also copy the 'air' binary for development
+COPY --from=builder /go/bin/air /usr/local/bin/air
+
+# Expose port 8080
 EXPOSE 8080
 
-# Command to run the executable when the container starts.
-CMD ["/app/main"]
+# The default command is to run the compiled binary for production.
+# For development, 'air' will be used via docker-compose to watch for changes.
+CMD ["/app/main"]

--- a/c:\Users\nazim\source\golang\Dockerfile
+++ b/c:\Users\nazim\source\golang\Dockerfile
@@ -1,28 +1,38 @@
 # ---- Build Stage ----
-# Use the official Go image, with an Alpine base for a smaller size.
-# 'AS builder' names this stage, so we can refer to it later.
-FROM golang:1.22-alpine AS builder
+# Use the official Go image. 'AS builder' names this stage.
+FROM golang:1.22-alpine AS builder
 
 # Set the working directory inside the container
 WORKDIR /app
 
-# Copy go.mod and go.sum files to download dependencies.
-# This is done as a separate step to leverage Docker's layer caching.
-# Dependencies will only be re-downloaded if go.mod or go.sum change.
+# Install air for live reloading in development
+RUN go install github.com/cosmtrek/air@latest
+
+# Copy go.mod and go.sum files to download dependencies
 COPY go.mod go.sum ./
 RUN go mod download
 
-# Copy the rest of the application source code
-COPY . .
+# Copy the source code from the src directory
+COPY ./src ./src
 
 # Build the Go application.
-# -o /app/main specifies the output file name and location.
-# CGO_ENABLED=0 disables Cgo, creating a static binary which is needed for a minimal 'scratch' or 'alpine' final image.
-# GOOS=linux ensures the binary is built for a Linux environment.
-RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /app/main .
+# The output binary is named 'main'
+RUN CGO_ENABLED=0 GOOS=linux go build -o /app/main ./src/main.go
 
 # ---- Final Stage ----
-# Use a minimal base image for the final container.
-# Alpine is a good choice as it's very small and secure.
+# Use a minimal alpine image for the final container.
 FROM alpine:latest
 
+# Set the working directory
 WORKDIR /app
 
-# Copy only the compiled application binary from the 'builder' stage.
-# This keeps the final image small and free of build tools and source code.
+# Copy the built application binary from the 'builder' stage
 COPY --from=builder /app/main .
 
-# Expose port 8080 to allow traffic to the container.
+# Also copy the 'air' binary for development
+COPY --from=builder /go/bin/air /usr/local/bin/air
+
+# Expose port 8080
 EXPOSE 8080
 
-# Command to run the executable when the container starts.
-CMD ["/app/main"]
+# The default command is to run the compiled binary for production.
+# For development, 'air' will be used via docker-compose to watch for changes.
+CMD ["/app/main"]

--- a/c:\Users\nazim\source\golang\Dockerfile
+++ b/c:\Users\nazim\source\golang\Dockerfile
@@ -1,28 +1,38 @@
 # ---- Build Stage ----
-# Use the official Go image, with an Alpine base for a smaller size.
-# 'AS builder' names this stage, so we can refer to it later.
-FROM golang:1.22-alpine AS builder
+# Use the official Go image. 'AS builder' names this stage.
+FROM golang:1.22-alpine AS builder
 
 # Set the working directory inside the container
 WORKDIR /app
 
-# Copy go.mod and go.sum files to download dependencies.
-# This is done as a separate step to leverage Docker's layer caching.
-# Dependencies will only be re-downloaded if go.mod or go.sum change.
+# Install air for live reloading in development
+RUN go install github.com/cosmtrek/air@latest
+
+# Copy go.mod and go.sum files to download dependencies
 COPY go.mod go.sum ./
 RUN go mod download
 
-# Copy the rest of the application source code
-COPY . .
+# Copy the source code from the src directory
+COPY ./src ./src
 
 # Build the Go application.
-# -o /app/main specifies the output file name and location.
-# CGO_ENABLED=0 disables Cgo, creating a static binary which is needed for a minimal 'scratch' or 'alpine' final image.
-# GOOS=linux ensures the binary is built for a Linux environment.
-RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /app/main .
+# The output binary is named 'main'
+RUN CGO_ENABLED=0 GOOS=linux go build -o /app/main ./src/main.go
 
 # ---- Final Stage ----
-# Use a minimal base image for the final container.
-# Alpine is a good choice as it's very small and secure.
+# Use a minimal alpine image for the final container.
 FROM alpine:latest
 
+# Set the working directory
 WORKDIR /app
 
-# Copy only the compiled application binary from the 'builder' stage.
-# This keeps the final image small and free of build tools and source code.
+# Copy the built application binary from the 'builder' stage
 COPY --from=builder /app/main .
 
-# Expose port 8080 to allow traffic to the container.
+# Also copy the 'air' binary for development
+COPY --from=builder /go/bin/air /usr/local/bin/air
+
+# Expose port 8080
 EXPOSE 8080
 
-# Command to run the executable when the container starts.
-CMD ["/app/main"]
+# The default command is to run the compiled binary for production.
+# For development, 'air' will be used via docker-compose to watch for changes.
+CMD ["/app/main"]

--- a/c:\Users\nazim\source\golang\Dockerfile
+++ b/c:\Users\nazim\source\golang\Dockerfile
@@ -1,28 +1,38 @@
 # ---- Build Stage ----
-# Use the official Go image, with an Alpine base for a smaller size.
-# 'AS builder' names this stage, so we can refer to it later.
-FROM golang:1.22-alpine AS builder
+# Use the official Go image. 'AS builder' names this stage.
+FROM golang:1.22-alpine AS builder
 
 # Set the working directory inside the container
 WORKDIR /app
 
-# Copy go.mod and go.sum files to download dependencies.
-# This is done as a separate step to leverage Docker's layer caching.
-# Dependencies will only be re-downloaded if go.mod or go.sum change.
+# Install air for live reloading in development
+RUN go install github.com/cosmtrek/air@latest
+
+# Copy go.mod and go.sum files to download dependencies
 COPY go.mod go.sum ./
 RUN go mod download
 
-# Copy the rest of the application source code
-COPY . .
+# Copy the source code from the src directory
+COPY ./src ./src
 
 # Build the Go application.
-# -o /app/main specifies the output file name and location.
-# CGO_ENABLED=0 disables Cgo, creating a static binary which is needed for a minimal 'scratch' or 'alpine' final image.
-# GOOS=linux ensures the binary is built for a Linux environment.
-RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /app/main .
+# The output binary is named 'main'
+RUN CGO_ENABLED=0 GOOS=linux go build -o /app/main ./src/main.go
 
 # ---- Final Stage ----
-# Use a minimal base image for the final container.
-# Alpine is a good choice as it's very small and secure.
+# Use a minimal alpine image for the final container.
 FROM alpine:latest
 
+# Set the working directory
 WORKDIR /app
 
-# Copy only the compiled application binary from the 'builder' stage.
-# This keeps the final image small and free of build tools and source code.
+# Copy the built application binary from the 'builder' stage
 COPY --from=builder /app/main .
 
-# Expose port 8080 to allow traffic to the container.
+# Also copy the 'air' binary for development
+COPY --from=builder /go/bin/air /usr/local/bin/air
+
+# Expose port 8080
 EXPOSE 8080
 
-# Command to run the executable when the container starts.
-CMD ["/app/main"]
+# The default command is to run the compiled binary for production.
+# For development, 'air' will be used via docker-compose to watch for changes.
+CMD ["/app/main"]

1.  `src/main.go`: Your Go application source code.
2.  `go.mod` / `go.sum`: Manages your Go project's dependencies.
3.  `Dockerfile`: Defines the multi-stage Docker build.
4.  `docker-compose.yml`: A simple way to manage your container for development.
5.  `README.md`: This documentation file.

## Building and Running for Development

With `docker-compose`, building and running your development environment is much simpler. The setup now includes **live reloading**, so any changes you make to `main.go` will automatically restart the server.

Open a terminal or command prompt, navigate to `c:\Users\nazim\source\golang\`, and run the following commands.

### 1. Build and Run the Container

This single command will build your Docker image and start the container.

```bash
docker-compose up --build
```

### 2. Build the Docker image

This command builds the image using the `Dockerfile` in the current directory and tags it as `my-go-app`.

```bash
docker build -t my-go-app .
```

### 3. Run the Docker container

This command runs the container and maps port 8080 of your local machine to port 8080 of the container.

```bash
docker run -p 8080:8080 my-go-app
```

You can now access your web server at `http://localhost:8080` in your web browser. You should see a JSON response: `{"message":"Hello, World!"}`.

## Deploying to a VPS

Once you have your Docker image, deploying it to a VPS is straightforward.

1.  **Get a VPS:** Choose a VPS provider (like DigitalOcean, Linode, Vultr) and set up a server.
2.  **Install Docker on the VPS:** Connect to your VPS via SSH and install Docker.
3.  **Push your Docker Image to a Registry:** To get your image onto your VPS, you must use a container registry like Docker Hub, GitHub Container Registry, or others.
    *   **Log in to your registry:** `docker login`
    *   **Tag your image:** `docker tag my-go-app:latest your-registry-username/my-go-app:latest`
    *   **Push the image:** `docker push your-registry-username/my-go-app:latest`
4.  **Pull and Run the Image on your VPS:**
    *   Connect to your VPS via SSH.
    *   Pull the image: `docker pull your-registry-username/my-go-app:latest`
    *   Run the container:
        ```bash
        docker run -d -p 80:8080 --restart unless-stopped your-registry-username/my-go-app:latest
        ```
        *   `-d` runs the container in detached (background) mode.
        *   `-p 80:8080` maps port 80 of the VPS to port 8080 of your container. This allows you to access the app via the VPS's IP address directly.
        *   `--restart unless-stopped` ensures the container restarts automatically if the server reboots.

---

*For more complex applications, consider using **Docker Compose** to manage your services. This is especially useful if your application has multiple containers (e.g., a database).*