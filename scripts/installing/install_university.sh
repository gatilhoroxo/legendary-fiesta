#!/bin/bash

# ==============================================================================
# SCRIPT DE INSTALAÇÃO - FERRAMENTAS PARA FACULDADE (UBUNTU 24.04)
# ==============================================================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

INSTALL_DIR="$HOME/tools"
ALIAS_FILE="$INSTALL_DIR/tools.bash"
BASH_ALIASES="$HOME/.bash_config/aliases.sh"
BLACK_WHOLE="/dev/null"

echo -e "${YELLOW}Iniciando configuração modular (Ferramentas Acadêmicas)...${NC}"

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
# LOGISIM EVOLUTION (Circuitos Digitais)
# ==============================================================================
echo -e "${YELLOW}Logisim Evolution...${NC}"

if [ "$IS_ADMIN" = true ]; then
    # Logisim não tem apt fácil, instalamos via AppImage mesmo com root
    echo "Instalando via AppImage (Padrão)..."
fi

# Instalação igual para Root ou User (AppImage é o melhor jeito aqui)
cd "$INSTALL_DIR"
rm -rf logisim-dir
mkdir -p logisim-dir
cd logisim-dir

echo "Baixando Logisim Evolution..."
wget https://github.com/logisim-evolution/logisim-evolution/releases/download/v4.0.0/logisim-evolution-4.0.0-all.jar -O logisim.jar

if ! grep -q "alias logisim=" "$ALIAS_FILE"; then
    echo "alias logisim=\"java -jar ~/$INSTALL_DIR/logisim-dir/logisim.jar > /dev/null 2>&1 &\"" >> "$ALIAS_FILE"
fi

echo "----------------------------------------------------------------"

# ==============================================================================
# ARDUINO IDE 2.0
# ==============================================================================
echo -e "${YELLOW}Arduino IDE...${NC}"

cd "$INSTALL_DIR"
rm -rf arduino-dir
mkdir -p arduino-dir
cd arduino-dir

echo "Baixando Arduino IDE..."
wget -c "https://downloads.arduino.cc/arduino-ide/arduino-ide_2.3.2_Linux_64bit.AppImage" -O arduino.AppImage
chmod +x arduino.AppImage

echo "Extraindo..."
./arduino.AppImage --appimage-extract > /dev/null
mv squashfs-root arduino-files
rm arduino.AppImage

if ! grep -q "alias arduino=" "$ALIAS_FILE"; then
    # Arduino 2.0 também é Electron, precisa das flags de GPU
    echo "alias arduino=\"$INSTALL_DIR/arduino-dir/arduino-files/arduino-ide --no-sandbox --disable-gpu > /dev/null 2>&1 &\"" >> "$ALIAS_FILE"
fi

echo "----------------------------------------------------------------"

# ==============================================================================
# MINICONDA3
# ==============================================================================
echo -e "${YELLOW}Miniconda3...${NC}"

cd "$INSTALL_DIR"
rm -rf python-dir
mkdir -p python-dir
cd python-dir

echo "Baixando Miniconda3..."
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
bash miniconda.sh

rm miniconda.sh

if ! grep -q "alias miniconda=" "$ALIAS_FILE"; then
    echo "alias miniconda=\"$INSTALL_DIR/python-dir/miniconda3/bin/conda init bash\"" >> "$ALIAS_FILE"
fi

echo "----------------------------------------------------------------"

# ==============================================================================
# GODOT ENGINE (Criação de Jogos 2D/3D - Leve e Poderoso)
# ==============================================================================
echo -e "${YELLOW}Godot Engine...${NC}"

if [ "$IS_ADMIN" = true ]; then
    #versão meio pesada
    sudo snap install godot4
else
    cd "$INSTALL_DIR"
    rm -rf godot-dir
    mkdir -p godot-dir
    cd godot-dir

    echo "Baixando Godot 4.3 (Stable)..."
    # O Godot vem num ZIP simples, não é AppImage
    wget -c "https://github.com/godotengine/godot/releases/download/4.3-stable/Godot_v4.3-stable_linux.x86_64.zip" -O godot.zip

    echo "Extraindo..."
    unzip godot.zip > /dev/null
    rm godot.zip
    mv Godot_v4.3-stable_linux.x86_64 godot4_

    if ! grep -q "alias godot=" "$ALIAS_FILE"; then
        # Godot precisa de GPU. Se der erro no lab, tente adicionar --headless (mas aí não tem interface)
        echo "alias godot=\"$INSTALL_DIR/godot-dir/godot4_ > /dev/null 2>&1 &\"" >> "$ALIAS_FILE"
    fi
fi

echo "----------------------------------------------------------------"

# ==============================================================================
# KICAD (Design de Circuitos e PCBs)
# Nota: KiCad é complexo. Usamos um AppImage não-oficial (SSB) pois o oficial exige root.
# ==============================================================================
echo -e "${YELLOW}KiCad (PCB Design)...${NC}"

cd "$INSTALL_DIR"
rm -rf kicad-dir
mkdir -p kicad-dir
cd kicad-dir

echo "Baixando KiCad 7 (AppImage com bibliotecas inclusas)..."
# Usamos a versão 7 pois é a mais estável em formato AppImage atualmente
wget -c "https://github.com/KarlZeilhofer/kicad-appimage/releases/download/v5.1.4/KiCad-5.1.4.glibc2.27-x86_64.AppImage" -O kicad.AppImage
chmod +x kicad.AppImage

echo "Extraindo KiCad (Isso pode demorar, é grande)..."
./kicad.AppImage --appimage-extract > /dev/null
mv squashfs-root kicad-files
rm kicad.AppImage

# removendo algumas coisas
if [ "$IS_ADMIN" = true ]; then
    find . -name "libpixman-1.so*" -delete
    find . -name "libcairo.so*" -delete
    find . -name "libstdc++.so.6" -delete

    find . -name "libglib-2.0.so*" -delete
    find . -name "libgmodule-2.0.so*" -delete
    find . -name "libgio-2.0.so*" -delete
    find . -name "libgobject-2.0.so*" -delete
    
    find . -name "libselinux.so*" -delete
fi 


if ! grep -q "alias kicad=" "$ALIAS_FILE"; then
    echo "alias kicad=\"$INSTALL_DIR/kicad-dir/kicad-files/AppRun > /dev/null 2>&1 &\"" >> "$ALIAS_FILE"
fi

echo "----------------------------------------------------------------"

# ==============================================================================
# CIRCUITBLOCKS (Programação Visual de Hardware)
# ==============================================================================
echo -e "${YELLOW}CircuitBlocks...${NC}"

if [ "$IS_ADMIN" = true ]; then
    cd "$INSTALL_DIR"
    rm -rf circuitblocks-dir
    mkdir -p circuitblocks-dir
    cd circuitblocks-dir

    echo "Baixando CircuitBlocks..."
    # Link da versão 1.10.1
    wget -c "https://github.com/CircuitMess/CircuitBlocks/releases/download/v1.10.0/CircuitBlocks-1.10.0-Linux.AppImage" -O cb.AppImage
    chmod +x cb.AppImage

    echo "Extraindo..."
    ./cb.AppImage --appimage-extract > /dev/null
    mv squashfs-root cb-files
    rm cb.AppImage

    if ! grep -q "alias circuitblocks=" "$ALIAS_FILE"; then
        # É Electron, precisa das flags de segurança
        echo "alias circuitblocks=\"$INSTALL_DIR/circuitblocks-dir/cb-files/circuitblocks --no-sandbox --disable-gpu > /dev/null 2>&1 &\"" >> "$ALIAS_FILE"
    fi
else
    echo -e "${YELLOW}CircuitBlocks requer privilégios de administrador.${NC}"
fi

echo "----------------------------------------------------------------"

# ==============================================================================
# MUSIC BLOCKS (Programação Visual de Música)
# ==============================================================================
echo -e "${YELLOW}Music Blocks...${NC}"

cd "$INSTALL_DIR"
rm -rf musicblocks-dir
mkdir -p musicblocks-dir
cd musicblocks-dir

echo "Baixando Music Blocks Launcher..."
# Versão 2.1.2
wget -c "https://github.com/sugarlabs/musicblocks/archive/refs/tags/v3.6.2.tar.gz" -O mb.tar.gz

echo "Extraindo..."
tar -xvf mb.tar.gz
rm mb.tar.gz

if ! grep -q "alias musicblocks=" "$ALIAS_FILE"; then
    echo "alias musicblocks=\"$INSTALL_DIR/musicblocks-dir/mb-bin/musicblocks --no-sandbox --disable-gpu > /dev/null 2>&1 &\"" >> "$ALIAS_FILE"
fi

echo "----------------------------------------------------------------"

# ==============================================================================
# ARCADE MANAGER (Gerenciador de ROMs/Retropie)
# ==============================================================================
echo -e "${YELLOW}Arcade Manager...${NC}"

cd "$INSTALL_DIR"
rm -rf arcademanager-dir
mkdir -p arcademanager-dir
cd arcademanager-dir

echo "Baixando Arcade Manager..."
# Versão 7.1
wget -c "https://github.com/cosmo0/arcade-manager/releases/download/v25.1/ArcadeManager-linux-25.1.0.AppImage" -O am.AppImage
chmod +x am.AppImage

echo "Extraindo..."
./am.AppImage --appimage-extract > /dev/null
mv squashfs-root am-files
rm am.AppImage

if ! grep -q "alias arcademanager=" "$ALIAS_FILE"; then
    echo "alias arcademanager=\"$INSTALL_DIR/arcademanager-dir/am-files/arcade-manager --no-sandbox --disable-gpu > /dev/null 2>&1 &\"" >> "$ALIAS_FILE"
fi

echo "----------------------------------------------------------------"
echo "----------------------------------------------------------------"

echo -e "${GREEN}Instalação de Ferramentas Acadêmicas Finalizada!${NC}"
if [ "$IS_ADMIN" = false ]; then
    echo "Aliases salvos em: $ALIAS_FILE"
    echo "Para ativar agora, rode: source ~/.bashrc"
fi
