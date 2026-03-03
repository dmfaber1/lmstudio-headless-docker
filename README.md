# LM Studio Headless (Docker)

This builds a basic Docker image that installs LM Studio using:

```bash
curl -fsSL https://lmstudio.ai/install.sh | bash
```

and starts the headless server on `0.0.0.0:1234`.

## Build

```bash
docker build -t lmstudio-headless:latest .
```

## Run (maps host port 1234 -> container port 1234)

```bash
docker run --rm -it -p 1234:1234 lmstudio-headless:latest
```

## Run with NVIDIA GPU (recommended on Linux)

Requires:
- NVIDIA drivers installed on the host
- `nvidia-container-toolkit` installed
- Docker configured with the `nvidia` runtime

```bash
docker run --rm -it \
  --gpus all \
  -p 1234:1234 \
  lmstudio-headless:latest
```

## Notes / troubleshooting

If the container fails saying `lms` is not found, the LM Studio installer may have changed paths/binary names.
Open a shell and locate the binary:

```bash
docker run --rm -it lmstudio-headless:latest bash
```