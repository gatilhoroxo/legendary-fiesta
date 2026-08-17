#!/bin/bash
#
# Funções totalmente genéricas
# 
# ESTADO: incompleto
# Depende de log.sh
# 

#retorna se existe ou não
#silenciosa
command_exists() {
  local cmd="$1"
  [ -z "$cmd" ] && return 1
  #verificar se o cmd existe dentro do ambiente
  command -v "$cmd" > /dev/null 2>&1
}

# retorna caminho do comando
command_path() {
  local cmd="$1"
  [ -z "$cmd" ] && return 1
  command -v "$cmd"
}

#requer algum comando para continuar algo
#"Preciso desse comando para continuar; ele existe?"
require_command() {
  local cmd="$1"
  if [ -z "$cmd" ]; then
    return 1
  fi
  if command_exists "$cmd"; then
    return 0
  fi

  log_error "Comando '$cmd' não encontrado."
  return 1
}

#requer vários comandos diferentes
#"Preciso de todos esses comandos?"
require_commands()

# retorna versão do comando?
# "Qual versão ele informa?"
command_version() {
  local cmd="$1"
  require_command "$cmd" || return 1
  "$cmd" --version
}
