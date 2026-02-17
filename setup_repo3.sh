#!/bin/bash

# --- Configurações ---
REPO_PATH="$HOME/system-observability-hub"
ASSETS_PATH="$REPO_PATH/docs/assets"

echo "🚀 Iniciando automação do Repo 3: System Health & Observability"

# 1. Criando diretórios de documentação'
if [ ! -d "$ASSETS_PATH" ]; then
    mkdir -p "$ASSETS_PATH"
    echo "✅ Diretórios docs/assets criados."
else
    echo "ℹ️  Diretórios já existem."
fi

# 2. Aplicando permissões de segurança (Hardening inicial)
# Dono tem leitura/escrita, grupo e outros apenas leitura.
chmod 744 "$REPO_PATH"
chmod 644 "$REPO_PATH/README.md"
echo "🔐 Permissões de hardening aplicadas aos arquivos de documentação."

# 3. Status do Git
cd "$REPO_PATH"
git status

echo "---"
echo "✅ Estrutura pronta para receber as evidências via SCP."
echo "💡 Próximo passo: No Ubuntu, envie as fotos para $ASSETS_PATH"
