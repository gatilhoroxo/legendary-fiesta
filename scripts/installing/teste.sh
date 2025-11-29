
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
echo "----------------------------------------------------------------"
echo "----------------------------------------------------------------"

# ==============================================================================
# GODOT ENGINE (Criação de Jogos 2D/3D - Leve e Poderoso)
# ==============================================================================
echo -e "${YELLOW}[Extra 7] Godot Engine...${NC}"

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
# O executável tem um nome longo, vamos simplificar no alias

if ! grep -q "alias godot=" "$ALIAS_FILE"; then
    # Godot precisa de GPU. Se der erro no lab, tente adicionar --headless (mas aí não tem interface)
    echo "alias godot=\"$INSTALL_DIR/godot-dir/Godot_v4.3-stable_linux.x86_64 > /dev/null 2>&1 &\"" >> "$ALIAS_FILE"
fi

echo "----------------------------------------------------------------"

# ==============================================================================
# KICAD (Design de Circuitos e PCBs)
# Nota: KiCad é complexo. Usamos um AppImage não-oficial (SSB) pois o oficial exige root.
# ==============================================================================
echo -e "${YELLOW}[Extra 8] KiCad (PCB Design)...${NC}"

cd "$INSTALL_DIR"
rm -rf kicad-dir
mkdir -p kicad-dir
cd kicad-dir

echo "Baixando KiCad 7 (AppImage com bibliotecas inclusas)..."
# Usamos a versão 7 pois é a mais estável em formato AppImage atualmente
wget -c "https://github.com/probonopd/KiCad/releases/download/continuous/KiCad-7.0.0-202302130704+6a380965f7-x86_64.AppImage" -O kicad.AppImage
chmod +x kicad.AppImage

echo "Extraindo KiCad (Isso pode demorar, é grande)..."
./kicad.AppImage --appimage-extract > /dev/null
mv squashfs-root kicad-files
rm kicad.AppImage

if ! grep -q "alias kicad=" "$ALIAS_FILE"; then
    echo "alias kicad=\"$INSTALL_DIR/kicad-dir/kicad-files/AppRun > /dev/null 2>&1 &\"" >> "$ALIAS_FILE"
fi

echo "----------------------------------------------------------------"

# ==============================================================================
# CIRCUITBLOCKS (Programação Visual de Hardware)
# ==============================================================================
echo -e "${YELLOW}[Extra 9] CircuitBlocks...${NC}"

cd "$INSTALL_DIR"
rm -rf circuitblocks-dir
mkdir -p circuitblocks-dir
cd circuitblocks-dir

echo "Baixando CircuitBlocks..."
# Link da versão 1.10.1
wget -c "https://github.com/CircuitMess/CircuitBlocks/releases/download/v1.10.1/circuitblocks-1.10.1-x86_64.AppImage" -O cb.AppImage
chmod +x cb.AppImage

echo "Extraindo..."
./cb.AppImage --appimage-extract > /dev/null
mv squashfs-root cb-files
rm cb.AppImage

if ! grep -q "alias circuitblocks=" "$ALIAS_FILE"; then
    # É Electron, precisa das flags de segurança
    echo "alias circuitblocks=\"$INSTALL_DIR/circuitblocks-dir/cb-files/circuitblocks --no-sandbox --disable-gpu > /dev/null 2>&1 &\"" >> "$ALIAS_FILE"
fi

echo "----------------------------------------------------------------"

# ==============================================================================
# MUSIC BLOCKS (Programação Visual de Música)
# ==============================================================================
echo -e "${YELLOW}[Extra 10] Music Blocks...${NC}"

cd "$INSTALL_DIR"
rm -rf musicblocks-dir
mkdir -p musicblocks-dir
cd musicblocks-dir

echo "Baixando Music Blocks Launcher..."
# Versão 2.1.2
wget -c "https://github.com/sugarlabs/musicblocks-launcher/releases/download/v2.1.2/Music.Blocks.Launcher-2.1.2.AppImage" -O mb.AppImage
chmod +x mb.AppImage

echo "Extraindo..."
./mb.AppImage --appimage-extract > /dev/null
mv squashfs-root mb-files
rm mb.AppImage

if ! grep -q "alias musicblocks=" "$ALIAS_FILE"; then
    echo "alias musicblocks=\"$INSTALL_DIR/musicblocks-dir/mb-files/AppRun --no-sandbox --disable-gpu > /dev/null 2>&1 &\"" >> "$ALIAS_FILE"
fi

echo "----------------------------------------------------------------"

# ==============================================================================
# ARCADE MANAGER (Gerenciador de ROMs/Retropie)
# ==============================================================================
echo -e "${YELLOW}[Extra 11] Arcade Manager...${NC}"

cd "$INSTALL_DIR"
rm -rf arcademanager-dir
mkdir -p arcademanager-dir
cd arcademanager-dir

echo "Baixando Arcade Manager..."
# Versão 7.1
wget -c "https://github.com/cosmo0/arcade-manager/releases/download/v7.1/arcade-manager-7.1.0-linux.AppImage" -O am.AppImage
chmod +x am.AppImage

echo "Extraindo..."
./am.AppImage --appimage-extract > /dev/null
mv squashfs-root am-files
rm am.AppImage

if ! grep -q "alias arcademanager=" "$ALIAS_FILE"; then
    echo "alias arcademanager=\"$INSTALL_DIR/arcademanager-dir/am-files/arcade-manager --no-sandbox --disable-gpu > /dev/null 2>&1 &\"" >> "$ALIAS_FILE"
fi

echo "----------------------------------------------------------------"
