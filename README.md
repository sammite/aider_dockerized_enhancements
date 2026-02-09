# aider_dockerized_enhancements
Just my personal mods to the docker version of aider

This project is designed for users who have access to much more powerful models via a web interface (like Gemini) than via API, but who still want to utilize the CLI workflow of aider.

My Dockerfile enhancements allow running aider in a container specifically for **copy-paste mode**, as first-party support for this workflow within Docker seems to be missing.

*Tested on Ubuntu 22.04.*

build:

```
docker build aider-xclip .
```

Create a .env with the following:

```
MODEL_HOST_IP=<IP of your ollama or similar>
MODEL_SLUG=<model slug>
```
run with:


```
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

```

You can even run this without a model at all, if you're ok with doing all of your commits completely manually.
I have a shell script, `run_aider.sh` that I am using to test it, and also to play with prompting further.

```
$IS_SUDO docker run -it \
    --user $(id -u):$(id -g) \
    --network host \
    --volume $(pwd):/app \
    --env DISPLAY=$DISPLAY \
    --env OLLAMA_API_BASE=http://$MODEL_HOST_IP:11434 \
    --volume /tmp/.X11-unix:/tmp/.X11-unix \
    aider-xclip \
    --no-check-update \
    --model null

```

This is because the actual commands we need minimum- `/copy-context` and `/run` don't need a functional model.



## Workflow

1. Start a web chat (e.g., Gemini).
2. Start this docker container.
3. Paste the **System Prompt** below into the web chat.
4. In aider, use `/copy-context` to grab the repo state.
5. Paste that context into the web chat with your request.
6. Copy the web chat's response (a `/run` command) and paste it into aider to apply changes.

## System Prompt

```text
this chat is a coding project in conjunction with the tool aider in copy-paste mode.
Additionally, the actual driver of the edits is qwen2.5-coder:3b, which is a small and not very powerful model.
For each prompt following this one.
- minimize total token response to reduce potential context problems.
- optimize messages for me to copy paste them in and out of gemini and make the whole experience more lightweight.
- return code suggestions in the format of a .patch file.

Additionally, we won't use the local model at all- simply return to me a /run command I can give aider 
that will write the contents of your suggestions into a local file named swap_diff.patch, then run this general command:
patch --ignore-whitespace --verbose <TARGET_FILE> swap_diff.patch
The totality of the command you return should be in `markdown` for easy plaintext copy and pasting.

Respond "beep boop" to this prompt.
```


## Gotchas

It seems like `--copy-paste` mode doesn't work- as does the aider inline `/paste` command. It doesn't like you pasting in `/run` commands,
which is probably a good thing, and there may be a simple way around it (other than forking) but normal copy paste works fine in my testing.

The model you use via the webui sometimes doesn't return a valid diff- you will start to notice what needs an extra prompt pretty quickly if you 
play with this long enough though!