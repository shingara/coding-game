FROM golang:1.21

WORKDIR /usr/src/app

RUN apt-get update && \
  apt-get install -y neovim git rake


## User creation
ARG UNAME=shingara
ARG UID=501
ARG GID=21 #$USER_UID

RUN groupadd -g $GID -o $UNAME
RUN useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME

## Entrypoint
USER $UNAME

RUN ls -lah /home/$UNAME/
RUN mkdir /home/$UNAME/.config/
RUN git clone https://github.com/shingara/vim-conf.git ~/vim-conf && \
  rake neovim_install

## Go dependences of nvim
# RUN go install github.com/mgechev/revive@latest
# RUN go install golang.org/x/tools/gopls@latest

