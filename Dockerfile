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

CMD ["sh", "-c", "lms server start --port 1234 && exec tail -f /dev/null"]