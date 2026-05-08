# 🛠️ Executando o Terraform

Este projeto utiliza um par de chaves SSH para acessar as instâncias EC2. Por questões de segurança, as chaves não estão comitadas no repositório.

Antes de executar o `terraform apply`, você precisa gerar as chaves localmente dentro desta pasta:

```bash
ssh-keygen -t rsa -b 2048 -f sre_key -N ""