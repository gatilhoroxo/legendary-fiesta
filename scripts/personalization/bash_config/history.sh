# ~/.bash_config/history.sh

# Não colocar linhas duplicadas ou que comecem com espaço no histórico
export HISTCONTROL="ignoreboth"
export HISTIGNORE="ls:cd:pwd:history:clear"

# Adicionar ao arquivo de histórico, não sobrescrever
shopt -s histappend

# Tamanho do histórico
HISTSIZE=1000
HISTFILESIZE=2000

# Atualizar valores de LINES e COLUMNS após cada comando
shopt -s checkwinsize

# Make less more friendly for non-text input files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
