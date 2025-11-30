# ~/.bash_config/aliases.sh

eval "`dircolors`"
# Habilitar suporte a cores no ls e aliases úteis
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# facilitar navegação
shopt -s autocd
shopt -s cdspell

# Mais aliases para ls
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Alias "alert" para comandos longos
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# extras =================================

# git
alias gs='git status'

# comuns
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias update='sudo apt update -y && sudo apt upgrade -y'

# outros



