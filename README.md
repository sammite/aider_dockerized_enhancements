# aider_dockerized_enhancements
Some personal mods to aider that were originally monkey patches for some very simple stuff but have spiraled a bit.

This project is designed for users who have access to much more powerful models via a web interface (like Gemini) than via API, but who still want to utilize the CLI workflow of aider.

My Dockerfile enhancements allow running aider in a container specifically for **copy-paste mode(sort of)**, as first-party support for this workflow within Docker seems to be missing.
However, the prompt I'm recommending and workflow I'm recommending are techniques you can use to do more than just copy paste- they let you leverage your webui only model with a very
weak local model to the point of being actually useful and fast even with 6GB of VRAM (what I have), though if you go with the "no model at all" option below, you can literally run this on 
anything that will just run the basic aider binary.

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


## why?

Good question. There's a few use cases for this.

- no monies
    Some people can't afford to burn money on api access. As far as I can tell, this is a decent way to make a webui workflow more cli friendly, and the fact that
    aider can build a whole context map makes that significantly less painful than having to manually describe your file/folder structure. The original idea was inspired by
    https://aider.chat/docs/usage/copypaste.html where they indicate that the process is within the T&C of most providers (for now at least). 
    All I'm doing is making that same copypaste mode a tiny bit easier to use in certain constrained situations.

- You can use a webui ai, but only a webui ai.
    Maybe your org bought licenses for some fancy AI stuff but only web browser- if you're a software dev org this may sound weird, but
    other industries often don't think API first. So if your license is the only way you have data governance, or it's a better model for your use case,
    or you just get more tokens that way, this set of techniques could be pretty valuable to you, since you can run it with a potato local model, or no local model at all.

- You enjoy doing things the harder way for sometimes no real reason.
    This project forced me to learn more about what the actual constraints of low end models are, how to more effectively pRoMpT eNgInEeR, 
    and play with some goofy ideas.

    As Sanderson's Second law states.

    Limitations > Powers