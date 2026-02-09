#!/bin/bash

[ -f .env ] && source .env

IS_SUDO=""
if ! docker ps >/dev/null 2>&1; then
    IS_SUDO="sudo"
fi

$IS_SUDO docker run -it \
    --user $(id -u):$(id -g) \
    --network host \
    --volume $(pwd):/app \
    --env DISPLAY=$DISPLAY \
    --env OLLAMA_API_BASE=http://$MODEL_HOST_IP:11434 \
    --volume /tmp/.X11-unix:/tmp/.X11-unix \
    aider-xclip \
    --no-check-update \
    --model ollama_chat/$MODEL_SLUG