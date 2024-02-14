FROM golang:1.21

WORKDIR /usr/src/app

RUN apt-get update && \
  apt-get install -y neovim git rake zsh tmux nodejs


## User creation
ARG UNAME=shingara
ARG UID=501
ARG GID=21 #$USER_UID

RUN groupadd -g $GID -o $UNAME
RUN useradd -m -u $UID -g $GID -o -s /bin/zsh $UNAME

## Entrypoint
USER $UNAME

RUN ls -lah /home/$UNAME/
RUN mkdir /home/$UNAME/.config/
RUN mkdir -p -m 0700 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts
RUN --mount=type=ssh,uid=$UID git clone git@github.com:shingara/vim-conf.git ~/vim-conf && \
  cd ~/vim-conf && rake neovim_install

RUN --mount=type=ssh,uid=$UID git clone git@github.com:shingara/dotfile.git ~/dotfile && \
  cd ~/dotfile && rake install

## Go dependences of nvim
RUN go install github.com/mgechev/revive@latest
RUN go install golang.org/x/tools/gopls@latest

## Copilot
RUN git clone https://github.com/github/copilot.vim.git \
  ~/.config/nvim/pack/github/start/copilot.vim
