#!/bin/bash

# rede.sh - Módulo de configuração de rede para transferência de ficheiros

function configurar_rede() {
    echo -e "\n--- Configuração de Rede para Transferência de Ficheiros ---"
    
    # Pequena adição para mostrar o IP real no Windows
    echo "As suas interfaces de rede atuais (Windows):"
    ipconfig | grep "IPv4" | head -n 2
    echo "------------------------------------------------------------"

    echo "Esta função simula a configuração de rede. Num ambiente real, precisaria"
    echo "de privilégios de administrador e configurações específicas (FTP/Samba)."
    echo ""
    echo "No Windows (Git Bash), a melhor forma de transferir ficheiros é via SCP:"
    echo "Exemplo (Enviar): scp ./vendas.txt utilizador@192.168.1.10:/backup/"
    echo "Exemplo (Receber): scp utilizador@servidor:/logs/sistema.log ./logs/"
    echo ""
    echo "Certifique-se de que o serviço 'OpenSSH Server' está ativo no Windows"
    echo "em: Definições > Aplicações > Funcionalidades Opcionais."
}

function menu_rede() {
    while true;
    do
        clear
        echo "=============================================="
        echo "         Módulo de Configuração de Rede       "
        echo "=============================================="
        echo " 1. Exibir Informações e Exemplos de Rede"
        echo " 0. Voltar ao Menu Principal"
        echo "=============================================="
        read -p "Escolha uma opção: " opcao_rede

        case $opcao_rede in
            1) configurar_rede ;;
            0) break ;;
            *)
                echo "Opção inválida. Escolha uma opção válida."
                ;;
        esac
        echo ""
        read -p "Pressione Enter para continuar..."
    done
}

# Chama o menu de rede se o script for executado diretamente
if [[ "${BASH_SOURCE}" == "$0" ]]; then
    menu_rede
fi
