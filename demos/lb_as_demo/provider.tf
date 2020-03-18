# Documentação do provider:
# https://www.terraform.io/docs/providers/huaweicloud/index.html
provider "huaweicloud" {
  # Descrição dos parâmetros: https://support.huaweicloud.com/en-us/api-iam/en-us_topic_0057845582.html
  # A URL de autenticação usa o formato:: https://iam.{region_id}.myhwclouds.com:443/v3
  # auth_url = "https://iam.myhwclouds.com:443/v3" # Global
  auth_url    = var.auth_url
  region      = var.region
  # tenant_name = var.tenant_name
  domain_name = var.domain_name
  user_name   = var.user_name
  password    = var.user_password  # recomendável usar a variável OS_PASSWORD (ao invés de salvar em disco a senha)
  # https://www.terraform.io/docs/providers/huaweicloud/index.html#aksk
  access_key = var.access_key
  secret_key = var.secret_key
}

# O endpoint de autenticação. Utilizar algum endpoint específico para sua região pode tornar as operações com Terraform mais rápidas
# https://developer.huaweicloud.com/intl/en-us/endpoint
variable "auth_url" { # OS_AUTH_URL
  default = "https://iam.myhuaweicloud.com/v3"
}

variable "user_name" { # OS_USERNAME
  description = "O nome de usuário para autenticação. Pode ser idêntico ao nome da conta."
}

variable "user_password" { # OS_PASSWORD
  description = "A senha para autenticação com o usuário definido em 'user_name'"
}


variable "domain_name" { # OS_DOMAIN_NAME
  description = "O nome da conta na Huawei Cloud"
}

variable "region" { # OS_TENANT_NAME
  default = "la-south-2"
  # default = "sa-brazil-1"
  description = "A região da Huawei Cloud"
}

# variable "tenant_name" { # OS_TENANT_NAME
#   description = "The Name of the Tenant (Identity v2) or Project (Identity v3) to login with."
# }

# Chamadas de API ao OBS (Armazenamento de Objeto) requerem Acess Key e Secret Key. Apenas Username/Password não é suficiente
variable "access_key" { # OS_ACCESS_KEY
  default = ""
}
variable "secret_key" { # OS_OS_SECRET_KEY
  default = ""
} 