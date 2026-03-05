#!/bin/bash
# ANALISADOR PROATIVO - REPO 3 (PostgreSQL Health Center)
# FOCO: Hardening de Rede & Integridade de Serviços

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}>>> [INICIANDO AUDITORIA DE HARDENING - REPO 3] <<<${NC}"

# 1. AUDITORIA DE SSH (PORTA CUSTOM 2222)
echo -e "\n${YELLOW}[1/4] Verificando SSH na porta customizada 2222...${NC}"
if ss -tuln | grep -q ":2222"; then
    echo -e "${GREEN}[ OK ] SSH operando na porta segura 2222.${NC}"
else
    echo -e "${RED}[ ALERTA ] SSH NÃO DETECTADO NA PORTA 2222! Verifique o sshd_config.${NC}"
fi

# 2. CONFLITO DE PORTA: PROMETHEUS (9091) vs COCKPIT (9090)
echo -e "\n${YELLOW}[2/4] Validando isolamento Prometheus (9091) vs Cockpit (9090)...${NC}"
# Check Prometheus
if ss -tuln | grep -q ":9091"; then
    echo -e "${GREEN}[ OK ] Prometheus isolado na porta 9091.${NC}"
else
    echo -e "${RED}[ ERRO ] Prometheus (9091) está offline.${NC}"
fi

# Check Cockpit (Para garantir que ele não "roubou" a vez do Prometheus)
if ss -tuln | grep -q ":9090"; then
    echo -e "${GREEN}[ INFO ] Cockpit detectado na porta 9090. Coexistência validada.${NC}"
fi

# 3. SEGURANÇA: LOGS DE ATAQUE
echo -e "\n${YELLOW}[3/4] Analisando tentativas de invasão (egrep/awk)...${NC}"
ATTEMPTS=$(sudo egrep -i "failed|unauthorized" /var/log/secure | wc -l)
if [ "$ATTEMPTS" -gt 10 ]; then
    echo -e "${RED}[ CRÍTICO ] Foram detectadas $ATTEMPTS tentativas de invasão!${NC}"
else
    echo -e "${GREEN}[ OK ] Logs de segurança dentro da normalidade ($ATTEMPTS tentativas).${NC}"
fi

# 4. HOUSEKEEPING: SAÚDE DO DISCO
echo -e "\n${YELLOW}[4/4] Checando espaço para armazenamento de métricas...${NC}"
DISK=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$DISK" -gt 80 ]; then
    echo -e "${RED}[ ALERTA ] Disco em $DISK%. Limpando arquivos temporários...${NC}"
    sudo find /tmp -name "*.tmp" -mtime +1 -delete
else
    echo -e "${GREEN}[ OK ] Espaço em disco: $DISK%.${NC}"
fi

echo -e "\n${GREEN}>>> [AUDITORIA FINALIZADA COM SUCESSO] <<<${NC}"
