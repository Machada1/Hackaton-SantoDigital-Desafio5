# Hackaton-SantoDigital-Desafio 5 - Infraestrutura GCP com Terraform

Repositório para hospedar o Desafio 5, de Infraestrutura Cloud para o hackaton da SantoDigital.
Este projeto é uma solução para o desafio de automação de infraestrutura em um hackathon, utilizando Terraform para provisionar uma infraestrutura básica no Google Cloud Platform (GCP). A infraestrutura inclui uma rede VPC, duas instâncias de VM, e um balanceador de carga HTTP(S).

## Estrutura do Projeto

- **`main.tf`**: Contém as definições da infraestrutura, incluindo a criação da VPC, sub-redes, instâncias de VM, regras de firewall, health check, serviço de backend, e balanceador de carga.
- **`outputs.tf`**: Define as saídas do Terraform, como os endereços IP das VMs.
- **`variables.tf`**: Declara as variáveis usadas no projeto para facilitar a configuração.

## Requisitos

- Conta no Google Cloud Platform (GCP)
- Terraform instalado ([Instruções de Instalação](https://learn.hashicorp.com/tutorials/terraform/install-cli))
- Autenticação configurada com o GCP (via `gcloud`)

## Como Aplicar a Configuração

### 1. Clone o Repositório

Clone o repositório para o seu ambiente local:

   git clone <link-do-seu-repositorio>
   
   cd HackathonSD
   
### 2. Configure Suas Credenciais no GCP
Certifique-se de que está autenticado no GCP com as permissões necessárias para criar os recursos. Se ainda não tiver autenticado, execute o seguinte comando:

  gcloud auth application-default login

### 3. Inicialize o Terraform
No diretório do projeto, execute o comando para inicializar o Terraform e configurar o backend:

  terraform init

### 4.  Defina as Variáveis
Antes de aplicar a configuração, as variáveis necessárias podem ser definidas diretamente no arquivo variables.tf, ou criar um arquivo terraform.tfvars no diretório raiz com as variáveis específicas para o seu ambiente. Exemplo de terraform.tfvars:

  project_id    = "seu-projeto-id"
  region        = "us-central1"
  zone          = "us-central1-a"
  subnet1_cidr  = "192.168.1.0/24"
  subnet2_cidr  = "10.152.0.0/24"
  instance_types = {
    "vm-instance-01" = "n1-standard-1"
    "vm-instance-02" = "n1-standard-1"
  }

### 5. Aplicar a Configuração
Para criar a infraestrutura, execute o seguinte comando:

  terraform apply

O Terraform mostrará o plano de execução, descrevendo as mudanças que serão feitas. Se tudo estiver certo, digite "yes" para confirmar e aplicar as mudanças.

### 6. Verificar os Recursos Criados
Após a conclusão, pode-se verificar se os recursos foram criados corretamente acessando o console do GCP ou usando o comando 'terraform show' para visualizar os detalhes dos recursos provisionados.

### 7. Limpar os Recursos
Quando a infraestrutura não for mais necessária, é importante destruir os recursos para evitar custos desnecessários. Para destruir a infraestrutura, execute:

  terraform destroy
  
O Terraform solicitará uma confirmação antes de proceder com a destruição dos recursos.

## Justificativa das Escolhas de Configuração

 - VPC e Sub-redes: A VPC foi criada para isolar a rede da infraestrutura. As sub-redes foram divididas entre diferentes regiões para proporcionar redundância e maior disponibilidade.
 - Tipos de Instância: As instâncias de VM utilizam o tipo "n1-standard-1", que é adequado para cargas de trabalho moderadas e balanceadas entre CPU e memória.
 - Balanceador de Carga: O balanceador de carga HTTP(S) foi escolhido para distribuir o tráfego entre as duas instâncias de forma eficiente, garantindo alta disponibilidade.
 - Regras de Firewall: Configuradas para permitir tráfego HTTP, garantindo que as VMs e o balanceador de carga estejam acessíveis ao público.
 - Health Check: Implementado para monitorar a saúde das VMs, garantindo que o balanceador de carga redirecione o tráfego apenas para instâncias saudáveis.


### **Scripts de Inicialização**

Os scripts de inicialização já estão embutidos nas configurações do Terraform no arquivo `main.tf`. Quando as instâncias são criadas, o Terraform executa automaticamente o seguinte script de inicialização em cada VM:

  #!/bin/bash
  apt-get update
  apt-get install -y apache2
  systemctl start apache2
  systemctl enable apache2

Esse script realiza a atualização do sistema, instala o servidor web Apache, e garante que ele seja iniciado automaticamente em cada inicialização da VM.
Com isso, a infraestrutura estará pronta para servir conteúdo web logo após a criação das instâncias.
