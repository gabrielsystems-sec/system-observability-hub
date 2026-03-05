# Repo 3: System Health, Observability & Tuning 📊

Este repositório documenta a implementação de uma stack de monitoramento de alta disponibilidade em ambiente **Rocky Linux**. O projeto demonstra a transição de um gerenciamento reativo para uma cultura de **SRE (Site Reliability Engineering)**, focando em automação de infraestrutura, tuning de kernel e visibilidade proativa.

---

## 🛠️ Roadmap de Confiabilidade & Evolução SRE

| Camada | Especialidade Técnica | Status |
| :--- | :--- | :--- |
| **Performance Tuning** | Otimização de Scheduler e I/O (`Nice`/`Renice`/`Ionice`) | ✅ Estável |
| **Service Automation** | Gestão de Ciclo de Vida e Automação com Systemd | ✅ Estável |
| **Modern Monitoring** | Telemetria e Dashboards (Prometheus/Grafana/Exporters) | ✅ Estável |
| **Log Governance** | Auditoria de Segurança e Diagnóstico Proativo | ✅ Estável |

---

## 1. Engenharia de Performance & Tuning (Kernel Level)
Implementação de políticas de priorização para garantir a estabilidade da stack de monitoramento sob alta carga de trabalho.

* **Priorização de Processos:** Ajuste fino de `Nice` para o Prometheus e otimização de sub-sistemas de disco.
    * [tuning-prioridade-processos-nice-ionice.png](./docs/assets/tuning-prioridade-processos-nice-ionice.png)
* **Análise de Pico:** Monitoramento de métricas via PromQL para identificar gargalos de CPU.
    * [Analise_Pico_CPU_PromQL_irate.png](./docs/assets/Analise_Pico_CPU_PromQL_irate.png)

---

## 2. Observabilidade e Diagnóstico Proativo
A integridade do ecossistema é validada através de telemetria em tempo real e auditorias de segurança automatizadas.

### Auditoria de Hardening & Logs
Desenvolvi scripts para identificar tentativas de intrusão e falhas de configuração em serviços críticos.
* **Execução Proativa:** [auditoria_proativa_hardening_sucesso.png](./docs/assets/auditoria_proativa_hardening_sucesso.png)
* **Detecção de Falhas:** [automacao_auditoria_detecçao_falhas.png](./docs/assets/automacao_auditoria_detecçao_falhas.png)
* **Hardening Lynis:** [index69_auditoria_hardening_lynis.png](./docs/assets/index69_auditoria_hardening_lynis.png)

### Monitoramento de Recursos
* **Saúde da Memória:** [monitoramento-ram-persistente-sucesso.png](./docs/assets/monitoramento-ram-persistente-sucesso.png)
* **Visualização Real-time:** [monitoramento_realtime_glances.png](./docs/assets/monitoramento_realtime_glances.png)

---

## 3. Automação de Infraestrutura & Troubleshooting
Resolução de conflitos reais de rede e automação de serviços via `systemd`.

### Gestão de Conflitos (Port Mapping)
Identificação e correção do conflito na porta **9090** entre Cockpit e Prometheus, movendo a stack de monitoramento para a porta **9091**.
* **Diagnóstico de Porta:** [troubleshooting_port_conflict_cockpit_vs_prometheus.png](./docs/assets/troubleshooting_port_conflict_cockpit_vs_prometheus.png)
* **Fix de Configuração:** [fix-prometheus-cockpit-conflict.png](./docs/assets/fix-prometheus-cockpit-conflict.png)

### Automação com Systemd
* **Postgres Exporter:** [systemd_postgres_exporter_active_service.png](./docs/assets/systemd_postgres_exporter_active_service.png)
* **Automação de Serviços:** [systemd-service-automation-active.png](./docs/assets/systemd-service-automation-active.png)
* **Debug de Dependências:** [debug_file_not_found_tar_fix.png](./docs/assets/debug_file_not_found_tar_fix.png)

---

## 4. Stack de Dados (PostgreSQL Monitoring)
Configuração de exportadores e segurança para monitoramento de banco de dados.

* **Criação de Usuário de Monitoramento:** [postgresql_create_monitor_user_sql.png](./docs/assets/postgresql_create_monitor_user_sql.png)
* **Métricas Expostas:** [postgresql_metrics_exposed_browser.png](./docs/assets/postgresql_metrics_exposed_browser.png)
* **Configuração Prometheus:** [prometheus_config_postgres_exporter.png](./docs/assets/prometheus_config_postgres_exporter.png)

---

## 5. Hardening de Rede (Firewalld)
Gestão moderna de firewall para isolamento de serviços de monitoramento e SSH.

* **Configuração de Portas:** [Hardening_Firewall_Grafana_Prometheus.png](./docs/assets/Hardening_Firewall_Grafana_Prometheus.png)
* **Isolamento de Sessões:** [gestao-de-sessoes-screen-e-background-jobs.png](./docs/assets/gestao-de-sessoes-screen-e-background-jobs.png)

---

Este repositório é a prova técnica da minha capacidade de orquestrar ambientes Linux complexos, garantindo **Visibilidade, Performance e Segurança**.
