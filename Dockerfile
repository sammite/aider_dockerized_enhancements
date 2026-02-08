FROM paulgauthier/aider-full

USER root

RUN apt-get update && apt-get install -y \
    xclip vim

USER aider

WORKDIR /app
