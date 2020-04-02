# Demo de Cloudera CDH na Huawei Cloud

**Esta documentação e o respectivo template ainda estão em construção.**

Este template de Terraform provisiona, numa nova VPC, uma estrutura de instâncias de computação ECS para os papéis de Cloudera Manager (e Utility Node) e Worker nodes.

No template foram seguidas as recomendações da Cloudera pra ambientes de POC, não-produtivos. Para um ambiente de produção o setup é mais complexo. Por exemplo, é obrigatório o uso de um banco de dados de configurações externa, ao invés do embutido no Cloudera Manager.

O processo de instalação do Cloudera Manager e demais componentes é similar a uma estrutura on-premises.

FIXME: O template ainda não ajusta automaticamente o `/etc/resolv.conf` das instância de forma a usar o nome da zona privada escolhida. Isso obriga o uso do nome `openstacklocal` para zona DNS.

## Instruções para criação da infraestrutura com Terraform

Os comandos de manipulação de variáveis assumem que seu ambiente é Linux. <br>No Windows, substitua `export` por `SET`.

### Setup inicial 
1. [Instale](https://learn.hashicorp.com/terraform/getting-started/install.html) o Terraform
1. Verifique se o Terraform está instalado corretamente rodando `terraform version`
1. Clone o repositório de templates rodando `git clone https://github.com/HuaweiCloudBrazilTeam/HuaweiCloud-Terraform-Templates.git`
1. Configure as variáveis de ambiente OS_* conforme a [explicação para o OpenStackClient](https://support.huaweicloud.com/en-us/devg-sdk_cli/en-us_topic_0070637155.html), usando sua credencial Huawei Cloud. **FIXME: Detalhar explicação**
1. Defina a [região](https://developer.huaweicloud.com/intl/en-us/endpoint) para provisionamento pela variável `region` do template
    * Exemplos (escolha apenas uma forma):
        * `export TF_VAR_region=sa-brazil-1`        
        * `echo region=sa-brazil-1 >> terraform.tfvars`
        * `terraform plan -var region=sa-brazil-1`

### Executando o template
1. Informe sua chave SSH pública na variável `keypair_public_key` FIXME: Detalhar
1. Defina a quantidade de Worker Nodes, usando alguma das formas abaixo
    * `export TF_VAR_cloudera_workers_count=3`
    * `echo cloudera_workers_count=3 >> terraform.tfvars`
1. `terraform plan`
1. `terraform apply`
1. Após a criação dos recursos, o valor do IP externo da instância do Cloudera Manager será exibido na variável `cloudera-master-eip`. Conecte por SSH nesse endereço IP  
1. Na instância do Cloudera Manager, execute `ping` para as demais instâncias, a partir do nome das mesmas
    * `ping ecs-cloudera-demo-host-1.openstacklocal`

## Passos de instalação do Cloudera Manager

Após o provisionamento dos servidores com o Terraform, a instalação do Cloudera Manager segue de forma manual.

A [página de download](https://www.cloudera.com/downloads/manager/6-3-1.html) exibe os comandos abaixo mediante login.

O download em si não requer autenticação.

```bash
wget https://archive.cloudera.com/cm6/6.3.1/cloudera-manager-installer.bin
chmod u+x cloudera-manager-installer.bin
sudo ./cloudera-manager-installer.bin
```

## Documentação adicional
* https://docs.cloudera.com/documentation/enterprise/6/6.3/topics/poc_installation.html
* https://docs.cloudera.com/documentation/enterprise/6/release-notes/topics/rg_hardware_requirements.html
