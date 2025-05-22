#! /bin/zsh

set -e
# set -x

REPO=~/dev/skiplabs/skip

docker rm -f sk-dev >/dev/null 2>&1

docker build -t $USER-skdb:latest -f $USER/Dockerfile .

docker run --interactive --tty\
       --env TERM=screen-256color \
       --mount src=$REPO,dst=/skip,type=bind \
       --mount src=/etc/localtime,dst=/etc/localtime,type=bind,readonly \
       --mount src=$HOME/.zshrc,dst=/root/.zshrc,type=bind,readonly \
       --mount src=$ZSH,dst=/root/.oh-my-zsh,type=bind,readonly \
       --mount src=$HOME/.zsh_history,dst=/root/.zsh_history,type=bind \
       --mount src=$HOME/.gitconfig,dst=/root/.gitconfig,type=bind,readonly \
       --name sk-dev \
       --hostname sk-dev \
       --network="host" \
       $USER-skdb:latest \
       /bin/zsh
