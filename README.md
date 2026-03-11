cat << 'EOF' > README.md
# Repo 3: System Health, Observability & Tuning 🛡️

Este repositório documenta a implementação de uma stack de observabilidade de alta performance e a resolução de gargalos críticos. O foco é a aplicação de conceitos de **SRE (Site Reliability Engineering)**, **Tuning de Kernel** e **Monitoramento Ativo**.

---

## 🛠️ Stack Tecnológica
* **Monitoramento:** Prometheus & Node Exporter
* **Visualização:** Grafana
* **Database Health:** PostgreSQL & Postgres Exporter
* **Auditoria:** Lynis & Scripting customizado (`monitor_sistema.sh`)

---

## 1. Monitoramento de Performance & Recursos (Full View)
Para garantir a estabilidade, implementei uma rotina de inspeção que correlaciona o consumo de hardware com a saúde dos serviços.

### 1.1. Visão Geral do Sistema (Performance)
Análise em tempo real do Load Average e escalonamento de processos para evitar *starvation*.
* **Evidência:** ![System Performance](docs/assets/system-performance-top-view.png)

### 1.2. Gestão de Ativos e Capacidade de Armazenamento
Auditoria combinada de Daemons ativos e disponibilidade de disco para prevenção de incidentes por falta de espaço (Disk Pressure).
* **Serviços Monitorados:** Prometheus, Grafana, Auditd e Firewalld.
* **Storage:** Monitoramento preventivo dos pontos de montagem `/` e `/storage_gab`.
* **Evidência:** ![Serviços e Disco](docs/assets/services-and-storage-audit.png)

---

## 2. Engenharia de Performance & Tuning
Implementei a priorização de recursos para garantir que a stack de monitoramento tenha precedência sobre processos não críticos através do escalonador do Kernel.

* **Ação:** Alteração do valor de NI (Nice) para `-5` (Prioridade Alta) e ajuste de I/O via `ionice`.
* **Justificativa:** Garantir que a coleta de métricas não sofra "gaps" durante picos de escrita no banco de dados.
* **Evidências:** ![Gestão de Processos](docs/assets/tuning-prioridade-processos-nice-ionice.png)
  ![Analise PromQL](docs/assets/Analise_Pico_CPU_PromQL_irate.png)

---

## 3. Post-Mortem: Troubleshooting de Conflitos (SRE)
**Evento:** Falha crítica na inicialização do Prometheus (Porta 9090 ocupada).

### Diagnóstico e Resolução
1. **Identificação:** Conflito detectado via `ss -tuln` (Serviço Cockpit utilizando a porta padrão).
2. **Decisão:** Migração do Prometheus para a porta `9091` via flag `--web.listen-address`.
3. **Resultado:** Restabelecimento total da visibilidade da infraestrutura.

<details>
<summary>📂 Visualizar Evidências de Diagnóstico</summary>

* **Conflito Detectado:** ![Erro Porta 9090](docs/assets/Diagnostico_Conflito_Porta_9090_Cockpit.png)
* **Correção Aplicada:** ![Fix Prometheus](docs/assets/fix-prometheus-cockpit-conflict.png)
</details>

---

## 4. Database Observability (PostgreSQL)
Configuração de exportador dedicado seguindo o princípio de **Least Privilege** (Privilégio Mínimo).

* **Segurança:** Criação do usuário `monitor_user` com permissões restritas à role `pg_monitor`.
* **Evidências:** ![Criação do Usuário](docs/assets/postgresql_create_monitor_user_sql.png)
  ![Status do Exportador](docs/assets/systemd_postgres_exporter_active_service.png)

---

## 5. Automação e Auditoria Proativa
Desenvolvimento de ferramentas para garantir a conformidade contínua.

### 5.1. Firewall & Perímetro
Centralização no `firewall-cmd` para persistência de regras de Hardening (Portas 2222 e 9091).
* **Evidência:** ![Firewall](docs/assets/Hardening_Firewall_Grafana_Prometheus.png)

### 5.2. Script de Monitoramento Customizado
Execução do `monitor_sistema.sh` para auditoria rápida de saúde e integridade do sistema.
* **Evidência:** ![Relatório de Auditoria](docs/assets/monitor_sistema_sh.png)

---

## 📈 Conclusão
O ambiente opera com 100% de visibilidade. Todas as decisões técnicas — do isolamento de portas ao tuning de prioridade de CPU — visam a alta disponibilidade e a integridade dos dados coletados para o time de SOC.

---
**Licença:** MIT
EOF
