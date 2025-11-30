# ~/.bash_config/tools.sh

# editor de texto no terminal
export EDITOR=nano
export LANG=pt_BR.UTF-8

# Exports MSP430
#export PATH=/opt/ti/msp430-gcc/bin:$PATH
export PATH=/usr/local/msp430/bin:$PATH

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Carrega nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # Carrega nvm bash_completion

# Angular CLI autocompletion
source <(ng completion script)
