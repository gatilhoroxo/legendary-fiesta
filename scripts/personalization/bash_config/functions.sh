
# Atualiza todo o sistema com um único comando
# Uso: sysupdate
sysupdate() {
    sudo apt update && sudo apt full-upgrade -y 
    sudo apt autoremove -y && sudo apt autoclean
    echo "Sistema atualizado e limpo!"
}

# criar diretorio e entrar nele
mkcd() {
  mkdir -p "$1"
  cd "$1" || return
}

# Sobe 'n' níveis de diretório
# Uso: up 2 (sobe 2 pastas), up (sobe 1 pasta)
up() {
    local d=""
    limit=$1
    for ((i=1 ; i <= limit ; i++)); do
        d=$d/..
    done
    d=$(echo $d | sed 's/^\///')
    if [ -z "$d" ]; then
        d=..
    fi
    cd $d
}

# extrair arquivos comuns
extract() {
  if [ -f "$1" ]; then
    case "$1" in 
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz)  tar xzj "$1" ;;
      *.bz2)     bunzip2 "$1" ;;
      *.rar)     unrar x "$1" ;;
      *.gz)      gunzip "$1" ;;
      *.tar)     tar xf "$1" ;;
      *.tbz2)    tar xjf "$1" ;;
      *.tgz)     tar xzf "$1" ;;
      *.zip)     unzip "$1" ;;
      *.Z)       uncompress "$1" ;;
      *.7z)      7z x "$1" ;;
      *)         echo "'$1' formato não suportado" ;;
    esac
  else 
    echo "'$1' não é um arquivo válido"
  fi
}

#setando um usuario git
# Uso: setUserGit "Nome" "email" [--global]
setUserGit(){
    if [ "$3" == "--global" ]; then
        git config --global user.name "$1"
        git config --global user.email "$2"
        echo "Git global configurado para: $1 <$2>"
    else 
        git config user.name "$1"
        git config user.email "$2"
        echo "Git local configurado para: $1 <$2>"
    fi 
}

# Mostra seu IP local e IP público
# Uso: myip
myip() {
    echo "IP Local: $(hostname -I | cut -d' ' -f1)"
    echo "IP Público: $(curl -s ifconfig.me)"
}

# Copia o conteúdo de um arquivo para o clipboard (requer xclip)
# Instale antes: sudo apt install xclip
# Uso: copyfile id_rsa.pub
copyfile() {
    if [ -f "$1" ]; then
        xclip -selection clipboard < "$1"
        echo "Conteúdo de '$1' copiado para a área de transferência."
    else
        echo "Arquivo não encontrado."
    fi
}

#iniciando um novo usuário
beginUser(){
  # config do grub
  sudo add-apt-repository ppa:danielrichter2007/grub-customizer -y
  sysupdate
  sudo apt install grub-customizer -y
  sudo update-grub

  # compiladores e ferramentas basicas
  sudo apt install -y gcc g++ gdb valgrind clang build-essential make
  sudo apt install -y git curl wget unzip zip 
  sudo apt install -y gnome-tweaks gnome-shell-extensions 
  sudo apt-get install -y ubuntu-restricted-extras 
  sysupdate

  # linguagens
  sudo apt install -y python3 python3-pip python3-venv
  sudo apt install -y openjdk-21-jdk maven
  sysupdate

  # framework Qt
  sudo apt install -y qtcreator qtbase5-dev qttools5-dev qt5-qmake
  # qt5qmake -y

  # sudo apt-get install systemd-genie
  # configuração do github cli
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
  sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
  sysupdate 
  sudo apt install gh -y

  # config de diretórios e git
  cd ~
  mkdir -p ~/dev/{notas,projects,ufpe} ~/tools/{arduino-dir,python-dir,godot-dir}
  
  # ferramentas extras e eletrônica
  sudo apt install zsh -y 
  sudo snap install arduino
  sudo apt install kicad -y
  sudo apt install octave gnuplot gnuplot-x11 -y

  #google chrome
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo apt install ./google-chrome*.deb
  rm google-chrome*.deb

  # docker
  sudo apt install docker.io docker-compose -y
  sudo usermod -aG docker $USER
  
  # latex leve
  sudo apt install texlive-base texstudio
  sudo apt install xclip

  sudo apt autoremove -y
}

# Função para testar mensagens coloridas
print_status() {
    echo -e "${b_green}[SUCESSO]${nc} O comando foi executado."
    echo -e "${b_red}[ERRO]${nc} Algo deu errado no processo."
    echo -e "${b_yellow}[AVISO]${nc} Tenha cuidado com este comando."
    echo -e "${b_cyan}[INFO]${nc} Iniciando o processo..."
    echo -e "${b_purple}[DEBUG]${nc} Variável X = 10"
}

# Mostra todas as cores disponíveis
show_colors() {
    echo -e "\n--- Cores Normais ---"
    echo -e "${black}Black ${red}Red ${green}Green ${yellow}Yellow ${blue}Blue ${purple}Purple ${cyan}Cyan ${white}White ${nc}"
    
    echo -e "\n--- Cores Negrito/Brilhantes ---"
    echo -e "${b_black}Black ${b_red}Red ${b_green}Green ${b_yellow}Yellow ${b_blue}Blue ${b_purple}Purple ${b_cyan}Cyan ${b_white}White ${nc}"

    echo -e "\nTeste: \033[1;91m old ${nc}"

    echo -e "\n--- Estilos ---"
    echo -e "${underline}Sublinhado${nc}  ${reverse}Invertido${nc} ${blink}Blink${nc} \n"
}