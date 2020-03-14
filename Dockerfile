FROM ubuntu:latest

RUN apt-get update

RUN apt-get install -y \
    build-essential \
    qtcreator \
    qt5-default \
    vim

WORKDIR /home/project

