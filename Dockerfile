FROM paulgauthier/aider-full

# Switch to root to install packages
USER root

# Install xclip and vim
RUN apt-get update && apt-get install -y \
    xclip vim

USER aider

# Set the working directory
WORKDIR /app
