FROM paulgauthier/aider-full

# Switch to root to install packages
USER root

# Install xclip
RUN apt-get update && apt-get install -y \
    xclip vim
    #&& rm -rf /var/lib/apt/lists/*

USER aider

# Set the working directory
WORKDIR /app
