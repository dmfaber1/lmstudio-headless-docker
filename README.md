# LM Studio Headless (Docker)

This builds a basic Docker image that installs LM Studio using:

```bash
curl -fsSL https://lmstudio.ai/install.sh | bash
```

and starts the headless server on `0.0.0.0:1234`.

The image is based on **Ubuntu 24.04** and includes the Intel oneAPI Level Zero and OpenCL runtimes for Intel Arc GPU support.

## Build

```bash
docker build -t lmstudio-headless:latest .
```

## Run (maps host port 1234 -> container port 1234)

```bash
docker run --rm -it -p 1234:1234 lmstudio-headless:latest
```

## Run with Intel Arc GPU

```bash
docker run --rm -it \
  --device /dev/dri \
  --group-add render \
  -p 1234:1234 \
  lmstudio-headless:latest
```

- `--device /dev/dri` passes the Intel GPU DRI nodes (including `renderD128`) into the container
- `--group-add render` grants permissions to use those device nodes
- The Intel oneAPI Level Zero and OpenCL runtimes are baked into the image

## Notes / troubleshooting

If the container fails saying `lms` is not found, the LM Studio installer may have changed paths/binary names.
Open a shell and locate the binary:

```bash
docker run --rm -it lmstudio-headless:latest bash
```

To verify the Intel GPU is visible inside the container, run:

```bash
docker run --rm -it --device /dev/dri --group-add render lmstudio-headless:latest \
  bash -c "apt-get install -y --no-install-recommends clinfo > /dev/null 2>&1 && clinfo | grep -i 'device name'"
```

The output should include `Intel(R) Arc(TM) A750 Graphics`.