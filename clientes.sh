#!/bin/bash

# clientes.sh - Módulo de gestão de clientes

ARQUIVO_CLIENTES="clientes.txt"

function inicializar_arquivo_clientes() {
    if [ ! -f "$ARQUIVO_CLIENTES" ]; then
        touch "$ARQUIVO_CLIENTES"
        echo "Arquivo de clientes criado: $ARQUIVO_CLIENTES"
    fi
}

function adicionar_cliente() {
    echo -e "\n--- Adicionar Novo Cliente ---"
    read -p "ID do Cliente: " id_cliente
    read -p "Nome do Cliente: " nome_cliente
    read -p "Contacto: " contacto_cliente
    read -p "Data de Registo (YYYY-MM-DD): " data_registo

    # Validação simples de preenchimento
    if [[ -z "$id_cliente" || -z "$nome_cliente" ]]; then
        echo "Erro: ID e Nome são obrigatórios!"
        return 1
    fi

    echo "$id_cliente;$nome_cliente;$contacto_cliente;$data_registo" >> "$ARQUIVO_CLIENTES"
    echo "Cliente adicionado com sucesso!"
}

function listar_clientes() {
    echo -e "\n--- Lista de Clientes ---"
    if [ -s "$ARQUIVO_CLIENTES" ]; then
        echo "ID | Nome | Contacto | Data Registo"
        echo "------------------------------------------------"
        cat "$ARQUIVO_CLIENTES" | tr ';' '|'
    else
        echo "Nenhum cliente registado ainda."
    fi
}

function buscar_cliente() {
    echo -e "\n--- Buscar Cliente ---"
    read -p "Digite o ID ou Nome do Cliente para buscar: " termo_busca
    if [ -z "$termo_busca" ]; then
        echo "Busca cancelada (termo vazio)."
        return
    fi
    
    resultados=$(grep -i "$termo_busca" "$ARQUIVO_CLIENTES")
    
    if [ -n "$resultados" ]; then
        echo "Resultados encontrados:"
        echo "$resultados" | tr ';' '|'
    else
        echo "Nenhum cliente encontrado com o termo '$termo_busca'."
    fi
}

function limpar_clientes_inativos() {
    echo -e "\n--- Limpar Clientes Inativos (mais de 6 meses) ---"
    
    # No Windows/Git Bash, o comando date -d pode variar. 
    # Esta é a forma mais segura de pegar a data de 6 meses atrás (formato numérico para comparação)
    DATA_LIMITE=$(date +%Y%m%d -d "6 months ago")
    
    echo "Removendo clientes registados antes de $(date +%Y-%m-%d -d "6 months ago")..."
    
    # Criamos um temporário
    # O awk remove os hífens da data (YYYY-MM-DD -> YYYYMMDD) para comparar como número
    awk -F';' -v limite="$DATA_LIMITE" '{
        data_reg = $4
        gsub(/-/, "", data_reg) 
        if (data_reg >= limite || data_reg == "") {
            print $0
        }
    }' "$ARQUIVO_CLIENTES" > "${ARQUIVO_CLIENTES}.tmp"
    
    linhas_antes=$(wc -l < "$ARQUIVO_CLIENTES")
    linhas_depois=$(wc -l < "${ARQUIVO_CLIENTES}.tmp")

    if [ "$linhas_antes" -gt "$linhas_depois" ]; then
        mv "${ARQUIVO_CLIENTES}.tmp" "$ARQUIVO_CLIENTES"
        echo "Limpeza concluída! $((linhas_antes - linhas_depois)) cliente(s) removido(s)."
    else
        rm "${ARQUIVO_CLIENTES}.tmp"
        echo "Nenhum cliente inativo encontrado para remover."
    fi
}

function menu_clientes() {
    inicializar_arquivo_clientes
    while true;
    do
        clear
        echo "=============================================="
        echo "          Módulo de Gestão de Clientes        "
        echo "=============================================="
        echo "1. Adicionar Cliente"
        echo "2. Listar Clientes"
        echo "3. Buscar Cliente"
        echo "4. Limpar Clientes Inativos"
        echo "0. Voltar ao Menu Principal"
        echo "=============================================="
        read -p "Escolha uma opção: " opcao_clientes

        case $opcao_clientes in
            1) adicionar_cliente ;;
            2) listar_clientes ;;
            3) buscar_cliente ;;
            4) limpar_clientes_inativos ;;
            0) break ;;
            *)
                echo "Opção inválida."
                ;;
        esac
        echo ""
        read -p "Pressione Enter para continuar..."
    done
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    menu_clientes
fi
