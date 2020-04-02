resource "random_pet" "vpc_1_name" {}

resource "huaweicloud_vpc_v1" "vpc_1" {
  name = "vpc_1-${random_pet.vpc_1_name.id}"
  cidr = var.vpc_cidr
}

# https://www.terraform.io/docs/providers/huaweicloud/r/networking_subnet_v2.html
# https://www.terraform.io/docs/providers/huaweicloud/r/vpc_subnet_v1.html
resource "huaweicloud_vpc_subnet_v1" "subnet_vpc_1" {
  vpc_id     = huaweicloud_vpc_v1.vpc_1.id
  name       = "subnet_vpc_1"
  cidr       = cidrsubnet(huaweicloud_vpc_v1.vpc_1.cidr, 8, 1)
  gateway_ip = cidrhost(cidrsubnet(huaweicloud_vpc_v1.vpc_1.cidr, 8, 1), 1)

  # When the subnet DNS servers aren't defined, the field is kept empty in the console
  # and the instances use the same IP of the DHCP server, which doesn't answer as a DNS server
  # it's a BUG, but not sure where
  ## https://support.huaweicloud.com/intl/en-us/dns_faq/dns_faq_002.html
  primary_dns   = var.primary_dns
  secondary_dns = var.secondary_dns
}
