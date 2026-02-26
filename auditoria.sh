#!/bin/bash

# auditoria.sh - Módulo de auditoria

ARQUIVO_VENDAS="vendas.txt"

function verificar_vendas_abaixo_valor() {
    echo -e "\n--- Verificação de Vendas Abaixo do Valor Definido ---"
    read -p "Digite o valor mínimo esperado para vendas: " valor_minimo

    # Validação simples de número
    if ! [[ "$valor_minimo" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
        echo "Erro: Valor mínimo inválido. Por favor, insira um número."
        return 1
    fi

    if [ ! -f "$ARQUIVO_VENDAS" ]; then
        echo "Erro: Arquivo $ARQUIVO_VENDAS não encontrado."
        return 1
    fi

    echo "Vendas abaixo de $valor_minimo:"
    echo "------------------------------------------------"
    
    # Busca e filtra as vendas
    grep -E ".*;.*;.*;.*;([0-9]+([.][0-9]+)?)$" "$ARQUIVO_VENDAS" | awk -F';' -v min="$valor_minimo" '{
        # Remove possíveis caracteres de retorno de carro (\r) do Windows
        gsub(/\r/, "", $5);
        if ($5 < min) {
            print "ID Venda: " $1 " | Data: " $2 " | Cliente: " $3 " | Automóvel: " $4 " | Valor: " $5
        }
    }'

    echo "------------------------------------------------"
}

function verificar_comprovativos() {
    echo -e "\n--- Verificação de Comprovativos de Venda ---"
    echo "Simulação de integração documental..."
    echo "Assumindo que vendas em 'vendas.txt' possuem comprovativo."
    echo ""
    echo "Solução para António José: Implementar base de dados centralizada."
}

function menu_auditoria() {
    while true;
    do
        clear
        echo "=============================================="
        echo "           Módulo de Auditoria                "
        echo "=============================================="
        echo "1. Verificar Vendas Abaixo do Valor"
        echo "2. Verificar Comprovativos de Venda (Simulação)"
        echo "0. Voltar ao Menu Principal"
        echo "=============================================="
        read -p "Escolha uma opção: " opcao_auditoria

        case $opcao_auditoria in
            1) verificar_vendas_abaixo_valor ;;
            2) verificar_comprovativos ;;
            0) break ;;
            *)
                echo "Opção inválida. Por favor, escolha uma opção válida."
                ;;
        esac
        echo ""
        read -p "Pressione Enter para continuar..."
    done
}

# Chama o menu de auditoria se o script for executado diretamente
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    menu_auditoria
fi
