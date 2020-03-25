variable "region" { # OS_REGION_NAME
  default = "ap-southeast-1"
  # default = "sa-brazil-1"
  description = "A região da Huawei Cloud"
}

variable "vpc_cidr" {
  default = "10.70.0.0/16"
}

variable "as_group_min_instances" {
  default = "0"
}

variable "as_group_desired_instances" {
  default = "2"
}

variable "as_group_max_instances" {
  default = "4"
}

variable "as_group_blue_weight" {
  default = "10"
}

variable "as_group_green_weight" {
  default = "1"
}

