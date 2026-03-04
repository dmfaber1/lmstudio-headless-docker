FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    bash \
    jq \
    libstdc++6 \
    libgcc-s1 \
    libgomp1 \
    gpg \
    wget \
  && rm -rf /var/lib/apt/lists/*

# Add Intel GPU apt repository for Ubuntu 24.04 (noble)
RUN wget -qO - https://repositories.intel.com/gpu/intel-graphics.key \
    | gpg --dearmor --output /usr/share/keyrings/intel-graphics.gpg \
  && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/intel-graphics.gpg] https://repositories.intel.com/gpu/ubuntu noble unified" \
    > /etc/apt/sources.list.d/intel-gpu-noble.list \
  && apt-get update && apt-get install -y --no-install-recommends \
    intel-opencl-icd \
    libze-intel-gpu1 \
    libze1 \
    intel-gsc \
  && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://lmstudio.ai/install.sh | bash

ENV PATH="/root/.local/bin:/root/.lmstudio/bin:/opt/lmstudio/bin:${PATH}"

# Pre-seed settings so LM Studio uses /mnt/models on first run
RUN mkdir -p /root/.lmstudio && \ 
    echo '{"downloadsFolder": "/mnt/models"}' > /root/.lmstudio/settings.json

# Create render and video groups so --group-add render/video works at runtime.
# Use --force so the command succeeds even if either group already exists.
RUN groupadd --force -r render && groupadd --force -r video

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

VOLUME /mnt/models

EXPOSE 1234

CMD ["/entrypoint.sh"]