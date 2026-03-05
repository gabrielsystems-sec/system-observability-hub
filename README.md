# Repo 3: System Health, Observability & Tuning

Este repositório documenta a implementação de uma stack de observabilidade de alta performance e a resolução de gargalos críticos em sistemas Linux (Ubuntu x86_64). O foco é a aplicação prática de conceitos de **SRE**, **Tuning de Kernel** e **Hardening**.

---

## 🛠️ Stack Tecnológica
* **Monitoramento:** Prometheus & Node Exporter
* **Visualização:** Grafana
* **Database Health:** PostgreSQL & Postgres Exporter
* **Auditoria:** Lynis & Scripting customizado (`analisador-audit`)

---

## 1. Engenharia de Performance & Tuning
Implementei a priorização de recursos para garantir que a stack de monitoramento tenha precedência sobre processos não críticos.

### Ajuste de Prioridade (Nice/Renice)
Utilizei o escalonador do Kernel para garantir CPU ao Prometheus.
* **Ação:** Alteração do valor de NI e ajuste de prioridade de I/O.
* **Evidência de Tuning:** ![Tuning de Performance](Analise_Pico_CPU_PromQL_irate.png)
![Gestão de Processos xargs e ionice](Uso_do_xargs_com_ionice_e_nice.png)

---

## 2. Post-Mortem: Troubleshooting de Conflitos
Um dos maiores problemas enfrentados foi a disputa pela porta `9090`, utilizada pelo **Cockpit** e pelo **Prometheus**.

### Diagnóstico e Resolução
1. **Identificação:** O serviço do Prometheus falhava ao iniciar. Usei `ss -tuln` para identificar a ocupação da porta.
2. **Decisão Técnica:** Reconfiguração do Prometheus para a porta `9091` e ajuste imediato nas regras de Firewall.
3. **Resultado:** Coleta de métricas restabelecida sem desativar a gestão do sistema via Cockpit.

<details>
<summary>📂 Visualizar Evidências de Diagnóstico</summary>

* **Conflito Detectado:** ![Erro Porta 9090](Diagnostico_Conflito_Porta_9090_Cockpit.png)
* **Correção Aplicada:** ![Fix Prometheus](fix-prometheus-cockpit-conflict.png)
</details>

---

## 3. Database Observability (PostgreSQL)
Configuração de um exportador dedicado para métricas de banco de dados, utilizando o princípio de **Least Privilege**.

* **Segurança:** Criação do usuário `monitor_user` com permissões restritas (RBAC).
* **Correção de Conexão:** Resolução de erro de parse no `DATA_SOURCE_NAME` via variáveis de ambiente no Systemd.
* **Evidência:** ![Status do Postgres Exporter](postgres_exporter_active_status.png)
![Dashboard de Métricas](grafana_com_postgres_exporter.png)

---

## 4. Hardening & Auditoria Proativa
Além do monitoramento passivo, implementei uma camada de defesa ativa.

### Gestão de Firewall Moderno (Firewalld)
Configuração rigorosa de zonas e portas.
* **Portas Liberadas:** `2222/tcp` (SSH), `9091/tcp` (Prometheus), `3000/tcp` (Grafana), `9187/tcp` (Postgres Exporter).

### Analisador Proativo
Desenvolvimento de um script de automação (`analisador_proativo.sh`) integrado como binário global em `/usr/local/bin/analisador-audit`.
* **Evidência de Auditoria:** ![Relatório de Auditoria](Auditoria_Proativa_Analisador.png)
![Resultado do Hardening](lynis_audit_system_result.png)

---

## 📈 Conclusão
O sistema opera agora com 100% de visibilidade. Todas as falhas foram documentadas em logs e resolvidas com decisões técnicas fundamentadas, garantindo um ambiente resiliente e monitorado.
