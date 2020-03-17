# Huawei Cloud Terraform - Demo do provider

Este demo não provisiona qualquer recurso.

Tem como objetivo demonstrar como se autenticar na Huawei Cloud a partir desse provider.

Para demonstrar o sucesso, obtém o ID de uma imagem IMS e a exibe como um _output_.


## Parâmetros de autenticação

A definição do provider assume que você está parametrizando a autenticação por variáveis de ambiente.

São as seguintes:
```bash
export OS_TENANT_NAME=ap-southeast-1 					# nome da região
export TF_region=$OS_TENANT_NAME # é necessário informar a região, e aqui fazemos por uma varíavel a parte para evitar um conflito com o OpenStackClient
export OS_AUTH_URL=https://iam.$OS_TENANT_NAME.myhuaweicloud.com/v3	# consulte a lista de endpoints IAM em https://developer.huaweicloud.com/intl/en-us/endpoint
export OS_DOMAIN_NAME= 							# o nome da conta na Huawei Cloud
export OS_USERNAME=							# algum usuário da conta (ou o próprio nome da conta, se você ainda não tiver criado usuários)
export OS_PASSWORD=							# senha da conta ou usuário

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
