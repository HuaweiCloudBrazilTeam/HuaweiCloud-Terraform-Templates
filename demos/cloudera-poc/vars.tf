variable "auth_url" {
  default = "https://iam.myhuaweicloud.com/v3"
}

variable "project_name" {
  default = "cloudera-demo"
}

variable "region" {
  default = "ap-southeast-1"
}

variable "tenant_name" {
  default = "ap-southeast-1"
}

variable "vpc_cidr" {
  default = "10.70.0.0/16"
}

variable "primary_dns" {
  default = "100.125.1.250" # HK primary DNS
}

variable "secondary_dns" {
  default = "100.125.3.250" # HK secondary DNS
}

variable "ecs_image_name" {
  default = "CentOS 7.6 64bit"
}

variable "ecs_cloudera_manager_flavor" {
  default = "s3.large.4"
}

variable "ecs_cloudera_worker_flavor" {
  default = "s3.large.4"
}

variable "cloudera_workers_count" {
  default = 3
}

variable "keypair_public_key" {}

variable "private_zone" {
  default = "openstacklocal."
}