# Documentação do provider:
## https://www.terraform.io/docs/providers/huaweicloud/index.html

# Documentação das variáveis de ambiente
## https://support.huaweicloud.com/en-us/devg-sdk_cli/en-us_topic_0070637155.html

provider "huaweicloud" {
  region = var.region
}

variable "region" { # OS_TENANT_NAME
  default = "ap-southeast-1"
  # default = "sa-brazil-1"
  description = "A região da Huawei Cloud"
}