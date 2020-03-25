# Documentação do provider:
## https://www.terraform.io/docs/providers/huaweicloud/index.html

# Documentação das variáveis de ambiente
## https://support.huaweicloud.com/en-us/devg-sdk_cli/en-us_topic_0070637155.html

provider "huaweicloud" {
  # alias  = "a" # default provider
  region = var.region_a
}

provider "huaweicloud" {
  alias       = "b"
  tenant_name = var.region_b
  region      = var.region_b
  auth_url    = "https://iam.${var.region_b}.myhuaweicloud.com/v3"
}