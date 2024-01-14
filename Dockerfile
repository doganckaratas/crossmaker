FROM ubuntu:22.04

ARG USER_NAME
ARG USER_UID

RUN apt update -y
RUN apt install -y build-essential
RUN apt install -y bison
RUN apt install -y flex
RUN apt install -y libgmp3-dev
RUN apt install -y libmpc-dev
RUN apt install -y libmpfr-dev
RUN apt install -y texinfo
RUN apt install -y libisl-dev

# CREATE machine config
RUN useradd -m $USER_NAME -u $USER_UID
RUN apt update -y && apt upgrade -y
RUN apt install -y curl wget gcc g++ make
