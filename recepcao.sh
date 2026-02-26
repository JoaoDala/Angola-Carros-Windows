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
    echo "               MENU RECEPÇÃO                  "
    echo "=============================================="
    echo " 1) Adicionar clientes"
    echo " 2) Listar clientes"
    echo " 3) Adicionar carros"
    echo " 4) Listar carros"
    echo " 5) Alugar carros"
    echo " 6) Listar aluguéis"
    echo " 7) Emitir comprovativo"
    echo " 8) Consultar Histórico por Cliente"
    echo " 0) Sair"
    echo "=============================================="
    
    read -p "Escolha uma opção: " opcao

    case $opcao in
        1)
            adicionar_cliente
            ;;
        2)
            listar_cliente
            ;;
        3)
            adicionar_carro
            ;;
        4)
            listar_carros
            ;;
        5)
            alugar_carro
            ;;
        6)
            listar_alugueis
            ;;
        7)
            # Verifica se a função existe antes de chamar
            if declare -f emitir_comprovativo > /dev/null; then
                emitir_comprovativo
            else
                echo "Função 'emitir_comprovativo' ainda não implementada no funcoes.sh"
                sleep 2
            fi
            ;;
        8)
            if declare -f consultar_cliente > /dev/null; then
                consultar_cliente
            else
                echo "Função 'consultar_cliente' ainda não implementada no funcoes.sh"
                sleep 2
            fi
            ;;
        0)
            echo "Saindo do sistema de recepção..."
            sleep 1
            break
            ;;
        *)
            echo "Opção inválida! Tente novamente."
            sleep 1
            ;;
    esac
done
