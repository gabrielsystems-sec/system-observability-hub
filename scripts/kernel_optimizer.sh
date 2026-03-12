#!/bin/bash
# ---------------------------------------------------------
# Script: kernel_optimizer.sh
# Finalidade: Otimizacao de parametros de rede e seguranca do Kernel
# ---------------------------------------------------------

echo "--- [Iniciando Otimizacao do Kernel] ---"

# 1. Aumentar o limite de arquivos abertos
echo "* soft nofile 65535" | sudo tee -a /etc/security/limits.conf
echo "* hard nofile 65535" | sudo tee -a /etc/security/limits.conf

# 2. Ajustes de Rede via sysctl
sudo sysctl -w net.ipv4.tcp_fastopen=3
sudo sysctl -w net.ipv4.tcp_max_syn_backlog=2048
sudo sysctl -w net.core.somaxconn=1024

echo "[SUCESSO] Parametros aplicados localmente."
