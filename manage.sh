#!/bin/bash

#######################################################
# manage.sh docker control script
# v1.1
#
# Dogan C. Karatas
#
# Plan-S Space & Satellite Technologies
# (C) 2023
#######################################################

_AUTHOR="doganckaratas"
_MODULE="crossmaker"
_VERSION="v1.0"

# Color Definitions
XTR_COLOR_BLANK='\033[0m'
XTR_COLOR_RED='\033[31m'
XTR_COLOR_GREEN='\033[32m'
XTR_COLOR_ORANGE='\033[33m'
XTR_COLOR_BLUE='\033[34m'
XTR_COLOR_PURPLE='\033[35m'
XTR_COLOR_CYAN='\033[36m'
XTR_COLOR_IRED='\033[31;1m'
XTR_COLOR_IGREEN='\033[32;1m'
XTR_COLOR_IORANGE='\033[33;1m'
XTR_COLOR_IBLUE='\033[34;1m'
XTR_COLOR_IPURPLE='\033[35;1m'
XTR_COLOR_ICYAN='\033[36;1m'
XTR_COLOR_BRED='\033[0;101m'

# Logger Functions
__Log() { __ClSxTR="XTR_COLOR_$1" && echo -en ${!__ClSxTR%$1}${@:2}${XTR_COLOR_BLANK}; };
trace() { __Log IBLUE "[`date "+%Y-%m-%d %H:%M:%S"`] [$0] [DEBUG] " && __Log IBLUE ${@} && echo; };
debug() { __Log IGREEN "[`date "+%Y-%m-%d %H:%M:%S"`] [$0] [DEBUG] " && __Log IGREEN ${@} && echo; };
info() { __Log BLANK "[`date "+%Y-%m-%d %H:%M:%S"`] [$0] [ INFO] " ${@} && echo; };
warn() { __Log IORANGE "[`date "+%Y-%m-%d %H:%M:%S"`] [$0] [ WARN] " && __Log IORANGE ${@} && echo; };
error() { __Log IRED "[`date "+%Y-%m-%d %H:%M:%S"`] [$0] [ERROR] " && __Log IRED ${@} && echo; };
fatal() { __Log BRED "[`date "+%Y-%m-%d %H:%M:%S"`] [$0] [FATAL] " && __Log BRED ${@} && echo; };

# Start Autocomplete
__CrAutoCp() {
        commands="build run destroy help"
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        COMPREPLY=( $(compgen -W "${commands}" -- ${cur}) )
        return 0
}
complete -o nospace -F __CrAutoCp ./manage.sh
if [ "${BASH_SOURCE[0]}" != "${0}" ]; then return; fi;

# Docker Functions
setup() {
        info this script might ask you for root password right now...
        for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
        sudo apt-get update -y
        sudo apt-get install ca-certificates curl gnupg -y
        sudo install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --batch --yes --dearmor -o /etc/apt/keyrings/docker.gpg
        sudo chmod a+r /etc/apt/keyrings/docker.gpg
        echo \
                "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
                $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update -y
        sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
        sudo groupadd docker
        sudo usermod -aG docker $USER
        newgrp docker
        warn please log out or close this shell and log in or re open new shell for applying new changes.
        info install successful.
}

build() {
        docker build --build-arg USER_NAME=$(id -u -nr) --build-arg USER_UID=$(id -u) -t ${_AUTHOR}/${_MODULE}:${_VERSION} -f Dockerfile .
        if [ $? -ne 0 ]; then
                error build failed.
        fi
}

run() {
        docker run -i --rm \
                -v /etc/passwd:/etc/passwd \
                -v /etc/shadow:/etc/shadow \
                -v /etc/group:/etc/group \
                -v ${PWD}:/home/${USER} \
                -w /home/${USER} \
                -u $(id -u ${USER}):$(id -g ${USER}) \
                -t ${_AUTHOR}/${_MODULE}:${_VERSION}
        if [ $? -ne 0 ]; then
                error run failed.
        fi
}

destroy() {
        if [ "$(docker ps -q)" != "" ]; then
                docker kill $(docker ps -q)
        fi
        docker rmi ${_AUTHOR}/${_MODULE}:${_VERSION} -f
        if [ "$(docker ps --filter status=exited -q)" != "" ]; then
                docker rm $(docker ps --filter status=exited -q)
        fi
        docker image prune -f
        docker container prune -f
        if [ $? -ne 0 ]; then
                error destroy failed.
        fi
}

help() {
        trace help
}

# Main
__Log IPURPLE "*-*--*-*-*-*-*-* manage.sh *-*--*-*-*-*-*-*" && echo

case "$1" in
        "build")
                info building dockerfile...
                build
                ;;
        "setup")
                info setting up docker...
                setup
                ;;
        "run")
                info running machine...
                run
                ;;
        "destroy")
                info destroying machine...
                destroy
                ;;
        "help")
                info help:
                info build: builds parent dockerfile
                info setup: automated setup docker on host system
                info run: starts the virtual environment
                info destroy: destroys the virtual environment
                ;;
        *)
                warn invalid arguments supplied, use 'help' command, or source this script for autocompletion.
                ;;
esac
