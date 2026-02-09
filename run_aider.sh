#!/bin/bash

[ -f .env ] && source .env

sudo docker run -it \
    --user $(id -u):$(id -g) \
    --network host \
    --volume $(pwd):/app \
    --env DISPLAY=$DISPLAY \
    --env OLLAMA_API_BASE=http://$MODEL_HOST_IP:11434 \
    --volume /tmp/.X11-unix:/tmp/.X11-unix \
    aider-xclip \
    --no-check-update \
    --model ollama_chat/$MODEL_SLUG
#   --copy-paste 