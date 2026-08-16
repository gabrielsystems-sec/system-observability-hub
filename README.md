# System Health, Observability & Tuning

Stack prática de observabilidade e operação de infraestrutura, com foco em monitoramento, troubleshooting, tuning e governança de logs.

## Tecnologias

**Prometheus · Grafana · Node Exporter · PostgreSQL · Rsyslog · Logrotate · Systemd · Bash**

---

## Projetos

### Monitoramento de Performance

Monitoramento de recursos, serviços e pontos de montagem utilizando Glances, Top, Prometheus e Grafana.

<details>
  <summary>Ver evidências</summary>

  ![Glances](./docs/assets/monitoramento_realtime_glances.png)
  ![Top](./docs/assets/system-performance-top-view.png)
  ![Services](./docs/assets/services-and-storage-audit.png)

</details>

---

### Post-Mortem: Conflito de Porta

Durante a implantação da stack de observabilidade, o Prometheus não iniciava porque a porta `9090` já estava sendo utilizada pelo Cockpit.

**Investigação:** análise com `ss -tulpn`.  
**Causa raiz:** colisão de serviços na porta padrão.  
**Resolução:** migração do Prometheus para a porta `9091` e ajuste do Data Source no Grafana.

<details>
  <summary>Ver investigação e resolução</summary>

  ![Conflict](./docs/assets/troubleshooting_port_conflict_cockpit_vs_prometheus.png)
  ![Diagnosis](./docs/assets/Diagnostico_Conflito_Porta_9090_Cockpit.png)
  ![Healthy](./docs/assets/final_observability_stack_healthy_all_up.png)

</details>

---

### Performance Tuning

Aplicação de tuning de processos durante contenção de recursos:

- `nice -5` para priorizar o Prometheus.
- `ionice` para reduzir o impacto de tarefas de backup no disco.

<details>
  <summary>Ver evidências</summary>

  ![Tuning](./docs/assets/tuning-prioridade-processos-nice-ionice.png)
  ![PromQL](./docs/assets/Analise_Pico_CPU_PromQL_irate.png)

</details>

---

### Governança de Logs

Implementação de centralização de logs com Rsyslog e gerenciamento do ciclo de vida utilizando Logrotate com compressão.

<details>
  <summary>Ver evidências</summary>

  ![Central Log](./docs/assets/central-log-server-implementation-rocky9.png)
  ![Logrotate](./docs/assets/log-lifecycle-automation-compress-proof.png)

</details>

---

### Database Monitoring

Monitoramento do PostgreSQL utilizando uma role dedicada `monitor`, com permissões limitadas via `pg_monitor` e integração do Postgres Exporter ao Systemd.

<details>
  <summary>Ver evidências</summary>

  ![Role](./docs/assets/postgresql_create_monitor_user_sql.png)
  ![Exporter](./docs/assets/systemd_postgres_exporter_active_service.png)
  ![Metrics](./docs/assets/postgresql_metrics_exposed_browser.png)

</details>

---

### Automação de Auditoria

Desenvolvimento de uma estrutura modular em Shell Script para auditoria de hardening e detecção proativa de falhas.

<details>
  <summary>Ver evidências</summary>

  ![Setup](./docs/assets/setup_automacao_infra.png)
  ![Code](./docs/assets/projeto_modular_shell.png)
  ![Result](./docs/assets/auditoria_proativa_hardening_sucesso.png)

</details>

---

> **Hardening de Exportadores:** durante o deploy, foram identificadas permissões excessivas no Node Exporter. Foram ajustadas as permissões dos diretórios e restringido o tráfego de rede ao nó Prometheus.

<details>
  <summary>Ver evidência</summary>

  ![Node Exporter](./docs/assets/node_exporter_permissions_hardening.png)

</details>
