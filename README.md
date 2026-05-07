# 🚀 Projeto SRE End-to-End: AWS, Kubernetes (CKA Standard), CI/CD e Observabilidade

Bem-vindo ao meu portfólio de Engenharia de Confiabilidade (SRE). Este repositório documenta a construção de uma arquitetura em nuvem completa e automatizada, desenhada do zero para demonstrar o ciclo de vida de uma aplicação moderna, desde a infraestrutura até a monitorização.

## 🎯 Objetivo do Projeto
Provisionar e administrar uma infraestrutura resiliente na nuvem, orquestrar contêineres utilizando as melhores práticas do mercado (foco nos padrões do exame CKA) e garantir visibilidade total do ambiente através de ferramentas avançadas de observabilidade.

## 🛠️ Stack Tecnológica
* **Cloud Provider:** AWS (Amazon Web Services)
* **Infraestrutura como Código (IaC):** Terraform
* **Orquestração de Contêineres:** Kubernetes (`kubeadm`, `kubelet`, `kubectl`)
* **Container Runtime & Rede:** Containerd e Calico (CNI)
* **CI/CD:** GitHub Actions & Docker Hub
* **Linguagem da Aplicação:** Python
* **Observabilidade:** Helm, Prometheus e Grafana

---

## 🏗️ Fases da Implementação

### 1. Infraestrutura como Código (Terraform)
A fundação do projeto foi estabelecida na AWS utilizando Terraform. A arquitetura de rede foi configurada com instâncias EC2 rodando Ubuntu, alocadas em uma Virtual Private Cloud (VPC) com Security Groups restritos, garantindo o acesso apenas às portas estritamente necessárias (como a 6443 para a API do Kubernetes e a 8000 para a aplicação e túneis de monitoramento).

### 2. Cluster Kubernetes (Bootstrapping manual com `kubeadm`)
Para aprofundar o conhecimento prático e simular cenários exigidos na certificação **Certified Kubernetes Administrator (CKA)**, o cluster não utilizou serviços gerenciados (como EKS). O processo envolveu:
* Carregamento de módulos de Kernel Linux (`overlay`, `br_netfilter`) e ajustes de `sysctl`.
* Instalação e configuração do motor `containerd`.
* Inicialização do Control Plane (Master Node) e ingresso do Worker Node via `kubeadm`.
* Implementação da rede de pods com o plugin CNI **Calico**.

### 3. Integração e Entrega Contínuas (CI/CD)
A aplicação Python foi containerizada através de um `Dockerfile`. Foi desenvolvida uma pipeline automatizada utilizando **GitHub Actions** que, a cada novo *push* na branch principal:
1. Realiza o checkout do código.
2. Efetua a autenticação segura no **Docker Hub** via *GitHub Secrets*.
3. Realiza o *build* da imagem Docker e o *push* para o repositório público.
* O *deploy* no Kubernetes foi realizado de forma declarativa, utilizando manifestos YAML para criar um `Deployment` com múltiplas réplicas (alta disponibilidade) e um `Service` para balanceamento de carga.

### 4. Observabilidade (O "Dia 2")
A infraestrutura não está completa sem monitoramento. Utilizando o gerenciador de pacotes **Helm**, a stack do `kube-prometheus-stack` foi implementada no namespace de monitoramento.
A telemetria do cluster foi extraída para dashboards avançados no **Grafana**, permitindo a análise em tempo real do consumo de CPU, Memória, IOPS de disco e tráfego de rede de cada Pod e Node, garantindo a confiabilidade e facilitando o *troubleshooting*.

---

## 📸 Evidências e Resultados

### Pipeline de CI/CD (GitHub Actions)
A esteira de deploy automatizada rodando com sucesso.
![Pipeline CI/CD](https://github.com/user-attachments/assets/960477ca-36bd-46c1-99dd-99b881cb8ff7)

### Aplicação Rodando
A API Python respondendo diretamente de dentro do cluster Kubernetes através do roteamento de portas.
![API Python no Navegador](link-da-sua-imagem-do-hello-world-aqui.png)

### Dashboards de Observabilidade (Grafana)
Painéis detalhando o consumo de recursos do cluster e tráfego de rede, essenciais para a operação em NOC/SRE.
![Painel Grafana - CPU e Memória](link-da-sua-imagem-do-grafana-cpu-memoria-aqui.png)
![Painel Grafana - Rede e IOPS](link-da-sua-imagem-do-grafana-rede-iops-aqui.png)

---

## 🧹 FinOps e Desmobilização
Seguindo as boas práticas de gestão de custos em Cloud Computing, toda a infraestrutura AWS foi destruída automaticamente via `terraform destroy` ao final do laboratório, garantindo zero desperdício de recursos.

---

**Autor:** Lucas Ferreira de Almeida  
*Conecte-se comigo no [LinkedIn](https://linkedin.com/in/seu-perfil) ou acompanhe meus estudos no GitHub.*
