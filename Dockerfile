FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    bash \
    libstdc++6 \
    libgcc-s1 \
  && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://lmstudio.ai/install.sh | bash

ENV PATH="/root/.local/bin:/root/.lmstudio/bin:/opt/lmstudio/bin:${PATH}"

EXPOSE 1234

CMD ["lms", "server", "start", "--host", "0.0.0.0", "--port", "1234"]