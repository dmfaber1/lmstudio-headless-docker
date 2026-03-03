FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \ 
    ca-certificates \ 
    curl \ 
    bash \ 
    jq \ 
    libstdc++6 \ 
    libgcc-s1 \ 
  && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://lmstudio.ai/install.sh | bash

ENV PATH="/root/.local/bin:/root/.lmstudio/bin:/opt/lmstudio/bin:${PATH}"

# Pre-seed settings so LM Studio uses /mnt/models on first run
RUN mkdir -p /root/.lmstudio && \ 
    echo '{"downloadsFolder": "/mnt/models"}' > /root/.lmstudio/settings.json

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

VOLUME /mnt/models

EXPOSE 1234

CMD ["/entrypoint.sh"]