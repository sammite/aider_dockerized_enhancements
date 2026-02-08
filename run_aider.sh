#!/bin/bash

#SYSTEM_PROMPT="
#<instructions>
#\"Do not edit the files directly. Instead, write the delivered .patch file contents
#to swap_diff.patch and then run the following command to merge the differences.
#patch <FILE> swap_diff.patch
#Then, zero out the swap_diff.patch file.\"
#</instructions>
#"

sudo docker run -it \
    --user $(id -u):$(id -g) \
    --network host \
    --volume $(pwd):/app \
    --env DISPLAY=$DISPLAY \
    --env OLLAMA_API_BASE=http://192.168.56.1:11434 \
    --volume /tmp/.X11-unix:/tmp/.X11-unix \
    aider-xclip \
    --no-check-update \
    --model ollama_chat/qwen2.5-coder:3b
#   --copy-paste 