# Authentication
## Configure the HuaweiCloud Provider
provider "huaweicloud" {
    user_name   = "${var.user_name}"        // IAM User
    password    = "${var.password}"         // IAM Password     
    domain_name = "${var.domain_name}"      // What Is My Credentials? - https://support.huaweicloud.com/en-us/usermanual-ca/en-us_topic_0046606215.html
    tenant_name = "${var.tenant_name}"      // What Is My Credentials? - https://support.huaweicloud.com/en-us/usermanual-ca/en-us_topic_0046606215.html
    region      = "${var.region}"           // Regions and Endpoints - https://developer.huaweicloud.com/intl/en-us/endpoint?IAM
    auth_url    = "iam.sa-brazil-1.myhuaweicloud.com"   // Regions and Endpoints - https://developer.huaweicloud.com/intl/en-us/endpoint?IAM
}

// O provider da Huawei Cloud permite 4 tipos diferentes de autenticação:
//
//  1 - User Name + Password
//  2 - AK / SK
//  3 - Token
//  4 - Assume Role

// 1 - User name + Password -- Example
// provider "huaweicloud" {
//  user_name   = "${var.user_name}"
//  password    = "${var.password}"
//  domain_name = "${var.domain_name}"
//  tenant_name = "${var.tenant_name}"
//  region      = "${var.region}"
//  auth_url    = "https://iam.myhwclouds.com:443/v3"
// }

// 2 - AK / SK -- Example
// provider "huaweicloud" {
//  access_key  = "${var.access_key}"
//  secret_key  = "${var.secret_key}"
//  domain_name = "${var.domain_name}"
//  tenant_name = "${var.tenant_name}"
//  region      = "${var.region}"
//  auth_url    = "https://iam.myhwclouds.com:443/v3"
// }

// 3 - Token -- Example
// provider "huaweicloud" {
//  token       = "${var.token}"
//  domain_name = "${var.domain_name}"
//  tenant_name = "${var.tenant_name}"
//  region      = "${var.region}"
//  auth_url    = "https://iam.myhwclouds.com:443/v3"
// }

/* 4 - Assume Role
»User name + Password
provider "huaweicloud" {
  agency_name        = "${var.agency_name}"
  agency_domain_name = "${var.agency_domain_name}"
  delegated_project  = "${var.delegated_project}"
  user_name          = "${var.user_name}"
  password           = "${var.password}"
  domain_name        = "${var.domain_name}"
  region             = "${var.region}"
  auth_url           = "https://iam.myhwclouds.com:443/v3"
}
»AKSK
provider "huaweicloud" {
  agency_name        = "${var.agency_name}"
  agency_domain_name = "${var.agency_domain_name}"
  delegated_project  = "${var.delegated_project}"
  access_key         = "${var.access_key}"
  secret_key         = "${var.secret_key}"
  domain_name        = "${var.domain_name}"
  region             = "${var.region}"
  auth_url           = "https://iam.myhwclouds.com:443/v3"
}
»Token
provider "huaweicloud" {
  agency_name        = "${var.agency_name}"
  agency_domain_name = "${var.agency_domain_name}"
  delegated_project  = "${var.delegated_project}"
  token              = "${var.token}"
  region             = "${var.region}"
  auth_url           = "https://iam.myhwclouds.com:443/v3"
} */
