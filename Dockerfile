FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

RUN useradd --create-home --uid 10001 app

WORKDIR /build
COPY pyproject.toml setup.py README.md LICENSE ./
COPY src ./src
RUN apt-get update \
 && apt-get install -y --no-install-recommends build-essential libfreetype-dev \
 && pip install ".[composite]" \
 && apt-get purge -y --auto-remove build-essential \
 && rm -rf /var/lib/apt/lists/* /build \
 && cd /

USER app
WORKDIR /home/app
CMD ["python", "-c", "from psd_tools.version import __version__; print('psd-tools', __version__)"]
