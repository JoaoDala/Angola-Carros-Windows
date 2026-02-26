#!/bin/bash

# Garante que o script rode no diretório correto
cd "$(dirname "$0")"

# Tenta carregar as funções auxiliares
if [ -f "funcoes.sh" ]; then
    source funcoes.sh
else
    echo "Erro: funcoes.sh não encontrado!"
    exit 1
fi

while true; do
    clear
    echo "=============================================="
    echo "                MENU VENDAS                   "
    echo "=============================================="
    echo " 1) Adicionar Venda"
    echo " 2) Listar Vendas"
    echo " 3) Buscar Venda"
    echo " 4) Emitir comprovativo"
    echo " 0) Sair da aplicação"
    echo "=============================================="
    
    read -p "Escolha uma opção: " opcao

    case $opcao in
        1)
            # Verifica se a função existe no funcoes.sh
            if declare -f adicionar_venda > /dev/null; then
                adicionar_venda
            else
                # Se não existir, chama vender_carro que estava no teu funcoes.sh anterior
                vender_carro
            fi
            ;;
        2)
            listar_vendas
            ;;
        3)
            # Verifica se a função existe
            if declare -f buscar_venda > /dev/null; then
                buscar_venda
            else
                echo "Função 'buscar_venda' ainda não implementada."
                sleep 2
            fi
            ;;
        4)
            if declare -f emitir_comprovativo > /dev/null; then
                emitir_comprovativo
            else
                echo "Função 'emitir_comprovativo' ainda não implementada."
                sleep 2
            fi
            ;;
        0)
            echo "Saindo do módulo de vendas..."
            sleep 1
            break
            ;;
        *)  
            echo "Opção inválida! Tente novamente."
            sleep 1
            ;;
    esac
done
