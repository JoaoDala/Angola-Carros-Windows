#!/bin/bash

# Define os nomes de arquivos e pastas
ARQUIVO="historico_vendas.txt"
BACKUP_DIR="backups"
mkdir -p "$BACKUP_DIR"
DATA_HORA=$(date +%F_%H%M)
BACKUP_NOME="backup_$DATA_HORA"

if [[ -f "$ARQUIVO" ]]; then
    # Verifica se o comando 'zip' existe no sistema
    if command -v zip >/dev/null 2>&1; then
        zip -q "$BACKUP_DIR/$BACKUP_NOME.zip" "$ARQUIVO"
        ARQUIVO_FINAL="$BACKUP_DIR/$BACKUP_NOME.zip"
    else
        # Se não houver zip, usa o 'tar' (nativo do Windows 10/11)
        tar -a -cf "$BACKUP_DIR/$BACKUP_NOME.zip" "$ARQUIVO"
        ARQUIVO_FINAL="$BACKUP_DIR/$BACKUP_NOME.zip"
    fi

    echo "========================================"
    echo "           BACKUP REALIZADO             "
    echo "========================================"
    echo "Sucesso! Arquivo criado em:"
    echo "$ARQUIVO_FINAL"
    echo "========================================"
    read -p "Pressione Enter para continuar..."
else
    echo "========================================"
    echo "              ERRO                      "
    echo "========================================"
    echo "Erro: Arquivo '$ARQUIVO' não encontrado!"
    echo "========================================"
    read -p "Pressione Enter para continuar..."
fi
