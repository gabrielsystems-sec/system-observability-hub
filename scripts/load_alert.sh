#!/bin/bash
# ---------------------------------------------------------
# Script: load_alert.sh
# Finalidade: Monitoramento de sobrecarga (SRE)
# ---------------------------------------------------------

LOAD_LIMIT=2.0
CURRENT_LOAD=$(uptime | awk -F'load average:' '{ print $2 }' | cut -d, -f1 | xargs)

if (( $(echo "$CURRENT_LOAD > $LOAD_LIMIT" | bc -l) )); then
    echo "[ALERTA] Sistema sobrecarregado: $CURRENT_LOAD"
else
    echo "[OK] Sistema estavel: $CURRENT_LOAD"
fi
