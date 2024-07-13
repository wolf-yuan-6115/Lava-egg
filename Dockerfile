# Use an official Debian as a parent image
FROM debian:stable-slim

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Define build arguments
ARG PYTHON_VERSION
ARG OPENJDK_VERSION

# Install dependencies and specified Python and OpenJDK versions
RUN apt-get update && apt-get install -y \
    software-properties-common \
    wget \
    gnupg \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update && apt-get install -y \
    python${PYTHON_VERSION} \
    python3-pip \
    python${PYTHON_VERSION}-venv \
    && wget -O- https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - \
    && add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ \
    && apt-get update && apt-get install -y \
    adoptopenjdk-${OPENJDK_VERSION}-hotspot \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Verify installations
RUN python${PYTHON_VERSION} --version \
    && java -version

# Default command
CMD ["python${PYTHON_VERSION}", "--version"]
