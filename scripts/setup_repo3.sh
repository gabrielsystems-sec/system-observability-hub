#!/bin/bash
# setup_repo3.sh - Automação de Observabilidade e Hardening
# Foco: Resolução de conflitos de portas e Tuning de SRE

# 1. Checagem de privilégio
if [ "$EUID" -ne 0 ]; then 
  echo "Erro: Execute como sudo."
  exit 1
fi

echo "--- Iniciando Configuração do Repo 3 ---"

# 2. Firewall - Gestão Moderno (Firewalld)
# Portas: SSH(2222), Cockpit(9090), Node(9100), Grafana(3000), Prom(9091), Postgres(9187, 5432)
echo "[+] Configurando portas no firewall..."
for porta in 2222/tcp 9090/tcp 9100/tcp 3000/tcp 9091/tcp 9187/tcp 5432/tcp; do
    firewall-cmd --permanent --add-port=$porta >/dev/null 2>&1
done
firewall-cmd --reload
echo "[OK] Firewall atualizado."

# 3. Analisador Proativo
echo "[+] Instalando analisador de logs no sistema..."
if [ -f "./analisador_proativo.sh" ]; then
    chmod +x ./analisador_proativo.sh
    ln -sf "$(pwd)/analisador_proativo.sh" /usr/local/bin/analisador-audit
    echo "[OK] Comando 'analisador-audit' pronto."
else
    echo "[!] Aviso: analisador_proativo.sh não encontrado."
fi

# 4. Tuning de Performance (SRE)
echo "[+] Ajustando prioridade do Prometheus (Nice -5)..."
PID_PROM=$(pgrep prometheus)
if [ ! -z "$PID_PROM" ]; then
    renice -n -5 -p $PID_PROM
    echo "[OK] Tuning aplicado no PID $PID_PROM."
else
    echo "[!] Prometheus offline, tuning ignorado."
fi

# 5. Estrutura do Repo
mkdir -p docs/assets
echo "--- Setup Finalizado ---"
