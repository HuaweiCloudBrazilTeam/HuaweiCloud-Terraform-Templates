# Terraforms
O Terraform é uma ferramenta para criar e alterar planos de infraestrutura com segurança e eficiência. O Terraform pode gerenciar provedores de serviços existentes e populares, bem como soluções personalizadas internas.
Os arquivos de configuração descrevem para Terraform os componentes necessários para executar um único aplicativo ou todo o seu datacenter. O Terraform gera um plano de execução descrevendo o que fará para atingir o estado desejado e, em seguida, executa-o para construir a infraestrutura descrita. Conforme a configuração muda, o Terraform pode determinar o que mudou e criar planos de execução incrementais que podem ser aplicados.
A infraestrutura que o Terraform pode gerenciar inclui componentes de baixo nível, como instâncias de computação, armazenamento e rede, além de componentes de alto nível, como entradas DNS, recursos PaaS e SaaS.

Atualmente existem dezenas de provedores disponiveis e neste repositorio iremos cobrir alguns exemplos utilizando os provedores da [Huawei Cloud](https://www.huaweicloud.com/intl/en-us/) e [Huawei Cloud Stack Online](https://www.huaweicloud.com/intl/es-us/solution/HCSOnline/index.html)

Scripts Terraform para utilizar com Huawei Cloud
Documentação para utilizar Huawei Cloud ou Huawei Cloud Stack Online estão nos endereços abaixo:
Huawei Cloud : https://www.terraform.io/docs/providers/huaweicloud/index.html
Huawei Cloud Stack Online : https://www.terraform.io/docs/providers/huaweicloudstack/index.html


## Parâmetros de autenticação do provider Terraform **huaweicloud**

O endpoint de autenticação usa o formato _https://iam.<código da região>.myhuaweicloud.com/v3_.

A listagem completa dos endpoints de autenticação (IAM) e de todos outros serviços Huawei Cloud está [nesta página](https://developer.huaweicloud.com/intl/en-us/endpoint).

A definição do provider assume que você está parametrizando a autenticação por variáveis de ambiente.


São as seguintes:
```bash
export OS_TENANT_NAME=ap-southeast-1 					# nome da região
export TF_region=$OS_TENANT_NAME # é necessário informar a região, e aqui fazemos por uma varíavel a parte para evitar um conflito com o OpenStackClient
export OS_AUTH_URL=https://iam.$OS_TENANT_NAME.myhuaweicloud.com/v3	# consulte a lista de endpoints IAM em https://developer.huaweicloud.com/intl/en-us/endpoint
export OS_DOMAIN_NAME= 							# o nome da conta na Huawei Cloud
export OS_USERNAME=							# algum usuário da conta (ou o próprio nome da conta, se você ainda não tiver criado usuários)
export OS_PASSWORD=							# senha da conta ou usuário

# Para provisionar recursos no OBS é necessária autenticação usando Access Key/Secret Key
# A criação de AK/SK é feita no console IAM. Mais detalhes em: https://support.huaweicloud.com/intl/en-us/usermanual-iam/iam_02_0003.html
export OS_ACCESS_KEY=
export OS_SECRET_KEY=

# Não é necessário personalizar variáveis daqui para baixo
export NOVA_ENDPOINT_TYPE=publicURL 
export OS_ENDPOINT_TYPE=publicURL 
export CINDER_ENDPOINT_TYPE=publicURL 
export OS_VOLUME_API_VERSION=2 
export OS_IDENTITY_API_VERSION=3 
export OS_IMAGE_API_VERSION=2
```

Consulte a página abaixo para mais informaçãoes a respeito do papel de cada uma das variáveis *OS_*
* https://support.huaweicloud.com/en-us/devg-sdk_cli/en-us_topic_0070637155.html
