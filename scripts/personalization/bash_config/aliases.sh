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


#cores
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export NC='\033[0m'

# Reset / Sem Cor
export nc='\033[0m'       # No Color (Reseta tudo)

# Cores Regulares (Texto Normal)
export black='\033[0;30m'
export red='\033[0;31m'
export green='\033[0;32m'
export yellow='\033[0;33m'
export blue='\033[0;34m'
export purple='\033[0;35m'
export cyan='\033[0;36m'
export white='\033[0;37m'

# Cores em Negrito / Brilhantes (Mais usadas em terminais escuros)
export b_black='\033[1;30m'  # Cinza escuro
export b_red='\033[1;31m'
export b_green='\033[1;32m'
export b_yellow='\033[1;33m'
export b_blue='\033[1;34m'
export b_purple='\033[1;35m'
export b_cyan='\033[1;36m'
export b_white='\033[1;37m'

# outras cores e estilos
export g_black='\033[0;40m' # preto de fundo
export bl_red='\033[1;91m'   # vermelho claro em negrito

# Estilos Extras
export italic='\033[3m'      # Faz o italico
export underline='\033[4m'   # Sublinhado
export blink='\033[5m'       # Piscar (nem todos terminais suportam)
export reverse='\033[7m'     # Inverte fundo e texto
export riscado='\033[9m'     # Risca o texto
