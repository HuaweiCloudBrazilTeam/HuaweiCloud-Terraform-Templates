# Documentação do provider:
# https://www.terraform.io/docs/providers/huaweicloud/index.html
provider "huaweicloud" {
  # Descrição dos parâmetros: https://support.huaweicloud.com/en-us/api-iam/en-us_topic_0057845582.html
  # A URL de autenticação usa o formato:: https://iam.{region_id}.myhwclouds.com:443/v3
  # auth_url = "https://iam.myhwclouds.com:443/v3" # Global
  auth_url    = var.auth_url
  region      = var.region
  tenant_name = var.tenant_name  
}

# O endpoint de autenticação. Utilizar algum endpoint específico para sua região pode tornar as operações com Terraform mais rápidas
# https://developer.huaweicloud.com/intl/en-us/endpoint
variable "auth_url" { # OS_AUTH_URL
  default = "https://iam.myhuaweicloud.com/v3"
}

variable "region" { # OS_REGION_NAME
  default = "la-south-2"  
  description = "A região da Huawei Cloud"
}

variable "tenant_name" { # OS_TENANT_NAME
  description = "The Name of the Tenant (Identity v2) or Project (Identity v3) to login with."
}