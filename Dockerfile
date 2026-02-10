FROM paulgauthier/aider-full@sha256:271fb5285a21591f1a43e13674d7783d34593f4f17e7eb5049d9e5245f6fb340

USER root

RUN apt-get update && apt-get install --no-install-recommends -y \
    xclip vim && \
    rm -rf /var/lib/apt/lists/*

USER appuser

WORKDIR /app

COPY commands.py.patch .

RUN patch /venv/lib/python3.10/site-packages/aider/commands.py commands.py.patch && \
    rm commands.py.patch
