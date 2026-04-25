# System Health, Observability & Tuning 🛡️

Este repositório documenta a implementação de uma stack de observabilidade de alta performance e a resolução de gargalos críticos de infraestrutura. O foco é a aplicação prática de conceitos de **SRE (Site Reliability Engineering)**, **Tuning de Kernel**, **Governança de Logs** e **Monitoramento Ativo**.

## 🎯 Business Value & Observabilidade
O objetivo central é garantir a **Disponibilidade (Uptime)** e a **Previsibilidade** do ecossistema. Através de métricas em tempo real e análise de logs centralizada, reduzimos o **MTTR (Mean Time To Repair)** e antecipamos falhas de hardware/software antes que impactem o usuário final.

---

## Stack Tecnológica & Matriz de Arquitetura
* **Monitoramento:** Prometheus, Node Exporter, Glances, Postgres Exporter.
* **Visualização:** Grafana.
* **Database Health:** PostgreSQL 15.
* **Governança de Logs:** Rsyslog (Centralizado) & Logrotate (Lifecycle Management).
* **Automação & Auditoria:** Systemd Units, Anacron e Modular Shell Scripting.

### Matriz de Monitoramento e Tuning
| Camada | Tecnologia Principal | Estratégia de Observabilidade | Função no Ecossistema |
| :--- | :--- | :--- | :--- |
| **Real-time Stats** | Glances / Top | Terminal-based Monitoring | Auditoria imediata de carga e IO |
| **Time-Series** | Prometheus | Data Collection & Scraping | Histórico de performance e métricas |
| **Kernel Tuning** | Nice / Ionice | Priorização de Escalonamento | Proteção de recursos para serviços críticos |
| **Log Governance** | Rsyslog / Logrotate | Log Shifting & Compression | Auditoria forense e economia de storage |
| **DB Observability**| Postgres Exporter | Least Privilege Monitoring | Saúde interna do banco de dados |

---

## 📁 1. Monitoramento de Performance & Recursos

### Contexto do Problema
Sistemas de larga escala sofrem degradação silenciosa. Era necessário centralizar a visão de hardware (CPU Load) com a saúde dos daemons críticos e pontos de montagem.

### Evidência Técnica
<details>
  <summary>📂 Clique para ver a Performance em Tempo Real</summary>

  * **Full Stack View (Glances):** ![Realtime Glances](./docs/assets/monitoramento_realtime_glances.jpg)
  * **System Performance (Top):** ![Top View](./docs/assets/system-performance-top-view.png)
  * **Serviços e Storage Audit:** ![Services Audit](./docs/assets/services-and-storage-audit.png)
</details>

---

## 📁 2. [GOLDEN EVIDENCE] Post-Mortem: Conflito de Porta (9090)

### O Incidente
Falha crítica na inicialização do Prometheus impedindo a subida do serviço. 
* **Investigação SRE:** O comando `ss -tulpn` identificou que o serviço **Cockpit** estava ocupando a porta padrão `9090`.
* **Causa Raiz:** Colisão de porta entre o serviço nativo do Rocky Linux e o exportador de métricas.
* **Resolução:** Migração do Prometheus para a porta `9091` e ajuste nos Data Sources do Grafana.

### Evidência Técnica
<details>
  <summary>📂 Clique para ver o Diagnóstico e Resolução</summary>

  * **Conflito Detectado (DOWN):** ![Port Conflict](./docs/assets/troubleshooting_port_conflict_cockpit_vs_prometheus.png)
  * **Análise de Socket (Causa Raiz):** ![Socket Bind Error](./docs/assets/Diagnostico_Conflito_Porta_9090_Cockpit.png)
  * **Stack Reestabelecida (UP):** ![Stack Healthy](./docs/assets/final_observability_stack_healthy_all_up.png)
</details>

---

## 📁 3. Engenharia de Performance & Tuning (Nice/Ionice)

### Contexto do Problema
Contenção de recursos durante picos de IO no banco de dados, causando "gaps" nas métricas do Prometheus.

### Resolução SRE
1. **CPU Tuning:** Implementação de prioridade negativa (**Nice -5**) no binário do Prometheus para garantir precedência sobre processos secundários.
2. **IO Tuning:** Uso de **Ionice (Idle/Class 3)** para scripts de backup, evitando que o throughput de disco seja saturado.

### Evidência Técnica
<details>
  <summary>📂 Clique para ver o Tuning de Kernel</summary>

  * **Prioridade de Processos:** ![Nice Ionice](./docs/assets/tuning-prioridade-processos-nice-ionice.png)
  * **Análise PromQL (irate):** ![PromQL Analise](./docs/assets/Analise_Pico_CPU_PromQL_irate.png)
</details>

---

## 📁 4. Governança de Logs & Lifecycle (Rsyslog)

### Contexto do Problema
Logs espalhados dificultam a auditoria. Além disso, logs sem rotação causam travamento do sistema por saturação de disco.

### Estratégia Aplicada
* **Centralização:** Implementação de um servidor de log centralizado no Rocky Linux 9.
* **Log Lifecycle:** Automação via `logrotate` com compressão Gzip, garantindo conformidade e economia de 80% em storage.

### Evidência Técnica
<details>
  <summary>📂 Clique para ver a Governança de Logs</summary>

  * **Servidor Central de Logs:** ![Central Log](./docs/assets/central-log-server-implementation-rocky9.png)
  * **Automação & Compressão:** ![Logrotate Proof](./docs/assets/log-lifecycle-automation-compress-proof.png)
</details>

---

## 📁 5. Database Health & Least Privilege (PostgreSQL)

### Contexto do Problema
Necessidade de monitorar o banco de dados sem utilizar credenciais de super-usuário, reduzindo a superfície de ataque.

### Resolução
Criação da role dedicada `monitor` com permissão limitada de leitura de métricas (`pg_monitor`), configurando o Postgres Exporter via Systemd.

### Evidência Técnica
<details>
  <summary>📂 Clique para ver o Monitoramento de DB</summary>

  * **Criação da Role SQL:** ![Postgres User](./docs/assets/postgresql_create_monitor_user_sql.png)
  * **Exporter Active:** ![Systemd Exporter](./docs/assets/systemd_postgres_exporter_active_service.png)
  * **Métricas Expostas:** ![Metrics Browser](./docs/assets/postgresql_metrics_exposed_browser.jpg)
</details>

---

## 📁 6. Automação de Auditoria (Modular Shell Scripting)

### Diferencial Técnico
Desenvolvimento de uma biblioteca de automação modular para auditoria de Hardening e detecção proativa de falhas.

### Evidência Técnica
<details>
  <summary>📂 Clique para ver o Código e Execução</summary>

  * **Setup de Automação:** ![Setup Script](./docs/assets/setup_automacao_infra.png)
  * **Modular Source Code:** ![Modular Shell](./docs/assets/projeto_modular_shell.png)
  * **Auditoria Proativa (Sucesso):** ![Auditoria Result](./docs/assets/auditoria_proativa_hardening_sucesso.png)
</details>

---

> [!IMPORTANT]
> **SRE Insight: Hardening de Exportadores**
> Durante o deploy, identificamos que o Node Exporter estava operando com permissões excessivas. Realizamos o hardening de permissões de diretórios e configuramos o Firewall para aceitar apenas tráfego vindo do nó do Prometheus.
> ![Node Exporter Hardening](./docs/assets/node_exporter_permissions_hardening.png)
