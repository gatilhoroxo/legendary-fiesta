
source ../lib/core.sh
source ../lib/colors.sh
source ../lib/log.sh
source ../lib/command.sh
source ../lib/filesystem.sh

TEMP_ROOT="./temp-root"
TEST_DIR="./$TEMP_ROOT/sandbox"

rm -rf "$$TEMP_ROOT"
mkdir -p "$TEST_DIR"
cd "$TEMP_DIR"

# ================================= 

echo "Func 1 'command_exists': Teste 1"
echo -n "É para sair verdadeiro: "
if command_exists git; then
  echo "existe"
else 
  echo "não existe"
fi

echo "Func 1 'command_exists': Teste 2"
echo -n "É para sair falso: "
if command_exists prog_inexistente; then
  echo "existe"
else 
  echo "não existe"
fi

echo "Func 1 'command_exists': Teste 3"
echo -n "É para sair 'comando vazio' ou falso: "
if command_exists prog_inexistente; then
  echo "existe"
else 
  echo "não existe"
fi

# ---------------------------

echo "Func 2 'command_path': Teste 1"
echo -n "É para sair o caminho certo: "
$TEMP=""
command_path git > TEMP
if [ -z "$TEMP" ] ; then
  echo -e "caminho em $TEMP"
else 
  echo -e "não existe: $TEMP"
fi

echo "Func 2 'command_path': Teste 2"
echo -n "É para sair o : "
$TEMP=""
command_path programa_inexistente > TEMP
if [ -z "$TEMP" ] ; then
  echo -e "caminho em $TEMP"
else 
  echo -e "não existe: $TEMP"
fi

echo "Func 2 'command_path': Teste 3"
echo -n "É para sair 'argumento vazio' ou não existe: "
$TEMP=""
command_path > TEMP
if [ -z "$TEMP" ] ; then
  echo -e "caminho em $TEMP"
else 
  echo -e "não existe: $TEMP"
fi

# ---------------------------

echo "Func 3 'command_': Teste 1"
echo -n "É para sair 'argumento vazio' ou não existe: "
$TEMP=""
command_path > TEMP
if [ -z "$TEMP" ] ; then
  echo -e "caminho em $TEMP"
else 
  echo -e "não existe: $TEMP"
fi

# ---------------------------

echo "Func 3 'command_': Teste 1"
echo -n "É para sair 'argumento vazio' ou não existe: "
$TEMP=""
command_path > TEMP
if [ -z "$TEMP" ] ; then
  echo -e "caminho em $TEMP"
else 
  echo -e "não existe: $TEMP"
fi

# ---------------------------

echo "Func 3 'command_': Teste 1"
echo -n "É para sair 'argumento vazio' ou não existe: "
$TEMP=""
command_path > TEMP
if [ -z "$TEMP" ] ; then
  echo -e "caminho em $TEMP"
else 
  echo -e "não existe: $TEMP"
fi



# ================================= 

rm -rf "$TEST_DIR"