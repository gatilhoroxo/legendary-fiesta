#!/bin/bash

# ==============================================================================
# SCRIPT DE INSTALAÇÃO (UBUNTU 24.04)
# ==============================================================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

INSTALL_DIR="$HOME/Tools"
ALIAS_FILE="$INSTALL_DIR/tools.bash"
BASHRC="$HOME/.bashrc"
BLACK_WHOLE="/dev/null"

echo -e "${YELLOW}Iniciando configuração modular...${NC}"

mkdir -p "$INSTALL_DIR"

# 1. Garante que o arquivo de aliases existe
if [ ! -f "$ALIAS_FILE" ]; then
    touch "$ALIAS_FILE"
    echo "# Arquivo de Aliases para Ferramentas Locais" > "$ALIAS_FILE"
fi

# 2. Conecta o tools.bash ao .bashrc
if ! grep -q "source $ALIAS_FILE" "$BASHRC"; then
    echo "" >> "$BASHRC"
    echo "# Carregar aliases locais" >> "$BASHRC"
    echo "if [ -f $ALIAS_FILE ]; then source $ALIAS_FILE; fi" >> "$BASHRC"
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
echo -e "${GREEN}Instalação Finalizada!${NC}"
if [ "$IS_ADMIN" = false ]; then
    echo "Aliases salvos em: $ALIAS_FILE"
    echo "Para ativar agora, rode: source ~/.bashrc"
fi
