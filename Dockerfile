FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

RUN useradd --create-home --uid 10001 app

WORKDIR /build
COPY pyproject.toml setup.py README.md LICENSE ./
COPY src ./src
RUN pip install ".[composite]" && cd / && rm -rf /build

USER app
WORKDIR /home/app
CMD ["python", "-c", "from psd_tools.version import __version__; print('psd-tools', __version__)"]
