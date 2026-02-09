FROM ghcr.io/astral-sh/uv:0.10.0 AS uv
FROM ubuntu:24.04

ARG USER=vscode
ARG GROUP=${USER}
ARG UID
ARG GID
ARG WORKDIR=/app

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    bash-completion=1:2.11-8 \
    sudo=1.9.15p5-3ubuntu5.24.04.1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd --gid ${GID} ${GROUP} && \
    useradd --uid ${UID} --gid ${GID} --groups sudo --shell /bin/bash --create-home ${USER} && \
    echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

COPY --from=uv /uv /uvx /bin/

USER ${USER}
WORKDIR ${WORKDIR}
COPY --chown=${USER}:${GROUP} .python-version pyproject.toml uv.lock ./
RUN uv python install && uv sync --frozen
