# Repo 3: System Health, Observability & Tuning 🛡️

Este repositório documenta a implementação de uma stack de observabilidade de alta performance e a resolução de gargalos críticos. O foco é a aplicação de conceitos de **SRE**, **Tuning de Kernel** e **Hardening**.

---

## Stack Tecnológica
* **Monitoramento:** Prometheus & Node Exporter
* **Visualização:** Grafana
* **Database Health:** PostgreSQL & Postgres Exporter
* **Auditoria:** Lynis & Scripting customizado (`analisador-audit`)

---

## 1. Engenharia de Performance & Tuning
Implementei a priorização de recursos para garantir que a stack de monitoramento tenha precedência.

### Ajuste de Prioridade (Nice/Renice)
Utilizei o escalonador do Kernel para garantir CPU ao Prometheus.
* **Ação:** Alteração do valor de NI para `-5` e ajuste de prioridade de I/O.
* **Evidência de Tuning:** ![Tuning de Performance](docs/assets/Analise_Pico_CPU_PromQL_irate.png)
![Gestão de Processos](docs/assets/tuning-prioridade-processos-nice-ionice.png)

---

## 2. Post-Mortem: Troubleshooting de Conflitos
Resolução da disputa pela porta `9090` entre o **Cockpit** e o **Prometheus**.

### Diagnóstico e Resolução
1. **Identificação:** Identificação do conflito via `ss -tuln`.
2. **Decisão Técnica:** Reconfiguração do Prometheus para a porta `9091`.
3. **Resultado:** Coleta de métricas restabelecida.

<details>
<summary>📂 Visualizar Evidências de Diagnóstico</summary>

* **Conflito Detectado:** ![Erro Porta 9090](docs/assets/Diagnostico_Conflito_Porta_9090_Cockpit.png)
* **Correção Aplicada:** ![Fix Prometheus](docs/assets/fix-prometheus-cockpit-conflict.png)
</details>

---

## 3. Database Observability (PostgreSQL)
Configuração de exportador dedicado com o princípio de **Least Privilege**.

* **Segurança:** Criação do usuário `monitor_user` com permissões restritas.
* **Evidência:** ![Status do Exportador](docs/assets/systemd_postgres_exporter_active_service.png)
![Criação do Usuário](docs/assets/postgresql_create_monitor_user_sql.png)

---

## 4. Hardening & Auditoria Proativa
Implementação de defesa ativa e automação de auditoria.

### Gestão de Firewall Moderno (Firewalld)
* **Portas Liberadas:** `2222/tcp`, `9091/tcp`, `3000/tcp`, `9187/tcp`.
* **Evidência:** ![Firewall](docs/assets/Hardening_Firewall_Grafana_Prometheus.png)

### Analisador Proativo
Automação via `analisador_proativo.sh` integrado como binário global.
* **Evidência:** ![Relatório de Auditoria](docs/assets/auditoria_proativa_hardening_sucesso.png)

---

## 📈 Conclusão
O sistema opera com 100% de visibilidade e todas as decisões técnicas foram documentadas com evidências reais.
