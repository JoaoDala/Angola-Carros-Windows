#!/bin/bash

ARQUIVO="interessados.txt"

# Verifica se o arquivo existe e se não está vazio
if [[ ! -f "$ARQUIVO" || ! -s "$ARQUIVO" ]]; then
    echo "========================================"
    echo "                AVISO                   "
    echo "========================================"
    echo "Nenhum interessado cadastrado ainda..."
    echo "========================================"
    read -p "Pressione Enter para continuar..."
    exit 0
fi

# Pega a data de 6 meses atrás no formato YYYYMMDD para comparação fácil
# (Ex: 20231026)
DATA_LIMITE=$(date +%Y%m%d -d "6 months ago")

echo "Iniciando limpeza de registros anteriores a $(date +%Y-%m-%d -d "6 months ago")..."

# O AWK processa o arquivo:
# 1. Remove os hífens da data do arquivo ($1) para ficar YYYYMMDD
# 2. Compara com a DATA_LIMITE
awk -v limite="$DATA_LIMITE" -F' ' '{
    data_reg = $1
    gsub(/-/, "", data_reg)
    # Se a data for maior ou igual ao limite (mais recente), mantemos no arquivo
    if (data_reg >= limite || data_reg == "") {
        print $0
    }
}' "$ARQUIVO" > interessados_temp.txt

# Verifica se houve mudanças
linhas_antes=$(wc -l < "$ARQUIVO")
linhas_depois=$(wc -l < "interessados_temp.txt")

mv interessados_temp.txt "$ARQUIVO"

echo "========================================"
echo "          LIMPEZA CONCLUÍDA             "
echo "========================================"
echo "Registros removidos: $((linhas_antes - linhas_depois))"
echo "========================================"
read -p "Pressione Enter para continuar..."
