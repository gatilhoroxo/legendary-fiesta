#!/bin/bash

# ==============================================================================
# SCRIPT DE INSTALAÇÃO (UBUNTU 24.04)
# ==============================================================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

INSTALL_DIR="$HOME/tools"
ALIAS_FILE="$INSTALL_DIR/tools.bash"
BASH_ALIASES="$HOME/.bash_config/aliases.sh"
BLACK_WHOLE="/dev/null"

echo -e "${YELLOW}Iniciando configuração modular...${NC}"

mkdir -p "$INSTALL_DIR"

# 1. Garante que o arquivo de aliases existe
if [ ! -f "$ALIAS_FILE" ]; then
    touch "$ALIAS_FILE"
    echo "# Arquivo de Aliases para Ferramentas Locais" > "$ALIAS_FILE"
fi

# 2. Conecta o tools.bash ao .bashrc
if ! grep -q "source $ALIAS_FILE" "$BASH_ALIASES"; then
    echo "" >> "$BASH_ALIASES"
    echo "# Carregar aliases locais" >> "$BASH_ALIASES"
    echo "if [ -f $ALIAS_FILE ]; then source $ALIAS_FILE; fi" >> "$BASH_ALIASES"
    echo -e "${GREEN}Link criado no .bashrc para ler o tools.bash${NC}"
fi

# Verifica Admin (Grupo sudo ou Root)
if [ "$EUID" -eq 0 ]; then
    IS_ADMIN=true
    echo -e "${GREEN}Você está rodando como ROOT.${NC}"
elif groups | grep -q "\bsudo\b"; then
    IS_ADMIN=true
    echo -e "${GREEN}Você pertence ao grupo ADMIN. Usaremos APT/SNAP.${NC}"
else
    IS_ADMIN=false
    echo -e "${YELLOW}Ambiente restrito detectado. Instalando modo PORTÁTIL.${NC}"
fi



echo "----------------------------------------------------------------"

# ==============================================================================
# OBSIDIAN (Anotações e Markdown)
# ==============================================================================
echo -e "${YELLOW}Obsidian...${NC}"

cd "$INSTALL_DIR"
rm -rf obsidian-dir
mkdir -p obsidian-dir
cd obsidian-dir

echo "Baixando Obsidian..."
# Link da versão 1.6.7 (Estável)
wget -c "https://github.com/obsidianmd/obsidian-releases/releases/download/v1.6.7/Obsidian-1.6.7.AppImage" -O obsidian.AppImage
chmod +x obsidian.AppImage

echo "Extraindo..."
./obsidian.AppImage --appimage-extract > /dev/null
mv squashfs-root obsidian-files
rm obsidian.AppImage

if ! grep -q "alias obsidian=" "$ALIAS_FILE"; then
    # É Electron, precisa das flags de segurança
    echo "alias obsidian=\"$INSTALL_DIR/obsidian-dir/obsidian-files/obsidian --no-sandbox --disable-gpu > /dev/null 2>&1 &\"" >> "$ALIAS_FILE"
fi

echo "----------------------------------------------------------------"


# ==============================================================================
# GITHUB CLI (gh) - Para autenticação e gerenciamento de repositórios
# ==============================================================================
echo -e "${YELLOW}[Extra 13] GitHub CLI (gh)...${NC}"

cd "$INSTALL_DIR"
rm -rf gh-dir
mkdir -p gh-dir
cd gh-dir

echo "Baixando GitHub CLI v2.63.0..."
# Link oficial do binário para Linux x64
wget -c "https://github.com/cli/cli/releases/download/v2.63.0/gh_2.63.0_linux_amd64.tar.gz" -O gh.tar.gz

echo "Extraindo..."
tar -xvf gh.tar.gz > /dev/null
rm gh.tar.gz

# O tar extrai uma pasta com nome longo, vamos achar o binário independente do nome
GH_BIN_PATH=$(find . -name "gh" -type f | head -n 1)

if ! grep -q "alias gh=" "$ALIAS_FILE"; then
    # O comando é simples, não precisa de flags de GPU
    echo "alias gh=\"$INSTALL_DIR/gh-dir/$GH_BIN_PATH\"" >> "$ALIAS_FILE"
fi

echo "----------------------------------------------------------------"
echo "----------------------------------------------------------------"

# ==============================================================================
# CALIBRE (Versão Fixa 6.29.0 para compatibilidade)
# ==============================================================================
echo -e "${YELLOW}Calibre (v6.29.0)...${NC}"

if [ "$IS_ADMIN" = true ]; then
    sudo apt update && sudo apt install -y calibre
else
    # Define a pasta de instalação
    TARGET_DIR="$INSTALL_DIR/calibre-dir"
    rm -rf "$TARGET_DIR" # Limpa anterior
    mkdir -p "$TARGET_DIR"
    
    cd "$INSTALL_DIR"
    
    echo "Baixando Calibre 6.29.0 (Versão compatível)..."
    # Usamos o wget direto no arquivo .txz em vez do instalador script
    wget -c "https://download.calibre-ebook.com/6.29.0/calibre-6.29.0-x86_64.txz" -O calibre.txz
    
    echo "Extraindo..."
    # Extrai o conteúdo para dentro da pasta alvo
    tar -xvf calibre.txz -C "$TARGET_DIR" > "$BLACK_WHOLE"
    
    rm calibre.txz

    # Adiciona Alias
    if ! grep -q "alias calibre=" "$ALIAS_FILE"; then
        # O executável fica direto dentro da pasta extraída
        echo "alias calibre=\"$TARGET_DIR/calibre\"" >> "$ALIAS_FILE"
        echo -e "${GREEN}Alias Calibre configurado.${NC}"
    fi
fi

echo "----------------------------------------------------------------"

# ==============================================================================
# DRAW.IO (Versão Fixa v29.0.3)
# ==============================================================================
echo -e "${YELLOW}Draw.io...${NC}"

if [ "$IS_ADMIN" = true ]; then
    if command -v snap > "$BLACK_WHOLE"; then sudo snap install drawio; else sudo apt install -y dia; fi
else
    TARGET_DIR="$INSTALL_DIR/drawio-dir"
    rm -rf "$TARGET_DIR" # Limpa anterior
    mkdir -p "$TARGET_DIR"
    
    cd "$TARGET_DIR"

    echo "Baixando v29.0.3..."
    wget -c "https://github.com/jgraph/drawio-desktop/releases/download/v29.0.3/drawio-x86_64-29.0.3.AppImage" -O drawio.AppImage
    chmod +x drawio.AppImage
    
    echo "Extraindo..."
    ./drawio.AppImage --appimage-extract > "$BLACK_WHOLE"
    rm drawio.AppImage

    # Adiciona alias
    if ! grep -q "alias drawio=" "$ALIAS_FILE"; then
        echo "alias drawio=\"$TARGET_DIR/squashfs-root/drawio --no-sandbox > $BLACK_WHOLE 2>&1 &\"" >> "$ALIAS_FILE"
    fi
fi

echo "----------------------------------------------------------------"

# ==============================================================================
# GIMP (Versão Fixa Legacy 2.10.21)
# ==============================================================================
echo -e "${YELLOW}GIMP...${NC}"

if [ "$IS_ADMIN" = true ]; then
    sudo apt install -y gimp
else
    TARGET_DIR="$INSTALL_DIR/gimp-dir"
    rm -rf "$TARGET_DIR" # Limpa anterior
    mkdir -p "$TARGET_DIR"
    
    cd "$TARGET_DIR"

    echo "Baixando Legacy 2.10.21..."
    wget -c "https://github.com/aferrero2707/gimp-appimage/releases/download/continuous/GIMP_AppImage-git-2.10.21-20201001-x86_64.AppImage" -O gimp.AppImage
    chmod +x gimp.AppImage
    
    echo "Extraindo..."
    ./gimp.AppImage --appimage-extract > "$BLACK_WHOLE"

    # Adiciona alias
    if ! grep -q "alias gimp=" "$ALIAS_FILE"; then
        echo "alias gimp=\"$TARGET_DIR/squashfs-root/AppRun > $BLACK_WHOLE 2>&1 &\"" >> "$ALIAS_FILE"
    fi
fi

echo "----------------------------------------------------------------"
echo "----------------------------------------------------------------"

# ==============================================================================
# VS CODE (PORTABLE)
# ==============================================================================
echo -e "${YELLOW}[4/6] VS Code (Portable)...${NC}"

if [ "$IS_ADMIN" = true ]; then
    sudo snap install code --classic
else
    cd "$INSTALL_DIR"
    rm -rf vscode-dir
    mkdir -p vscode-dir
    cd vscode-dir

    echo "Baixando VS Code (tar.gz)..."
    # Link oficial que sempre aponta para a última versão estável
    wget -c "https://code.visualstudio.com/sha/download?build=stable&os=linux-x64" -O vscode.tar.gz
    
    echo "Extraindo..."
    tar -xvf vscode.tar.gz > /dev/null
    rm vscode.tar.gz
    
    # A pasta extraída geralmente se chama "VSCode-linux-x64"
    mv VSCode-linux-x64 vscode-bin

    if ! grep -q "alias codes=" "$ALIAS_FILE"; then
        # Adiciona flags de segurança para rodar sem travar no lab
        echo "alias codes=\"$INSTALL_DIR/vscode-dir/vscode-bin/code --no-sandbox --disable-gpu --disable-software-rasterizer > /dev/null 2>&1 &\"" >> "$ALIAS_FILE"
    fi
fi

echo "----------------------------------------------------------------"
echo "----------------------------------------------------------------"

# ==============================================================================
# DBEAVER (Banco de Dados)
# ==============================================================================
echo -e "${YELLOW}DBeaver Community...${NC}"

cd "$INSTALL_DIR"
rm -rf dbeaver-dir
mkdir -p dbeaver-dir
cd dbeaver-dir

echo "Baixando DBeaver..."
# Versão CE 24.0.0 (Linux tar.gz)
wget -c "https://dbeaver.io/files/24.0.0/dbeaver-ce-24.0.0-linux.gtk.x86_64.tar.gz" -O dbeaver.tar.gz

echo "Extraindo..."
tar -xvf dbeaver.tar.gz > /dev/null
rm dbeaver.tar.gz
# A pasta extraída chama-se 'dbeaver'
mv dbeaver dbeaver-bin

if ! grep -q "alias dbeaver=" "$ALIAS_FILE"; then
    echo "alias dbeaver=\"$INSTALL_DIR/dbeaver-dir/dbeaver-bin/dbeaver > /dev/null 2>&1 &\"" >> "$ALIAS_FILE"
fi

echo "----------------------------------------------------------------"

# ==============================================================================
# POSTMAN (APIs e Redes)
# ==============================================================================
echo -e "${YELLOW}Postman...${NC}"

cd "$INSTALL_DIR"
rm -rf postman-dir
mkdir -p postman-dir
cd postman-dir

echo "Baixando Postman..."
# Link direto oficial (sempre latest, mas costuma ser estável em estrutura)
wget -c "https://dl.pstmn.io/download/latest/linux64" -O postman.tar.gz

echo "Extraindo..."
tar -xvf postman.tar.gz > /dev/null
rm postman.tar.gz
# A pasta extraída chama-se 'Postman'
mv Postman postman-bin

if ! grep -q "alias postman=" "$ALIAS_FILE"; then
    # Postman também é Electron
    echo "alias postman=\"$INSTALL_DIR/postman-dir/postman-bin/Postman --no-sandbox --disable-gpu > /dev/null 2>&1 &\"" >> "$ALIAS_FILE"
fi

echo "----------------------------------------------------------------"
echo "----------------------------------------------------------------"

echo -e "${GREEN}Instalação Finalizada!${NC}"
if [ "$IS_ADMIN" = false ]; then
    echo "Aliases salvos em: $ALIAS_FILE"
    echo "Para ativar agora, rode: source ~/.bashrc"
fi
