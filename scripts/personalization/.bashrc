# ~/.bashrc: executed by bash(1) for non-login shells.

# personalização minha
echo "mugiwara $USER, bora estudar EC"
date

# Verificação de Interatividade (Se não for interativo, para aqui)
case $- in
    *i*) ;;
      *) return;;
esac

# Carregar Módulos de Configuração (~/.bash_config)
if [ -d ~/.bash_config ]; then
    for file in ~/.bash_config/*.sh; do
        [ -r "$file" ] && source "$file"
    done
fi

# Configuração de Autocomplete do Sistema
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
