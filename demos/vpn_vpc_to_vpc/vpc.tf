resource "random_pet" "vpc_a" {}
resource "random_pet" "vpc_b" {}

resource "huaweicloud_vpc_v1" "vpc_a" {
  region = var.region_a
  name   = "vpc_a-${random_pet.vpc_a.id}"
  cidr   = var.vpc_a_cidr
}

# https://www.terraform.io/docs/providers/huaweicloud/r/networking_subnet_v2.html
# https://www.terraform.io/docs/providers/huaweicloud/r/vpc_subnet_v1.html
resource "huaweicloud_vpc_subnet_v1" "subnet_vpc_a" {
  vpc_id     = huaweicloud_vpc_v1.vpc_a.id
  name       = "subnet_vpc_a"
  cidr       = cidrsubnet(huaweicloud_vpc_v1.vpc_a.cidr, 8, 1)
  gateway_ip = cidrhost(cidrsubnet(huaweicloud_vpc_v1.vpc_a.cidr, 8, 1), 1)

  # When the subnet DNS servers aren't defined, the field is kept empty in the console
  # and the instances use the same IP of the DHCP server, which doesn't answer as a DNS server
  # it's a BUG, but not sure where
  ## https://support.huaweicloud.com/intl/en-us/dns_faq/dns_faq_002.html
  primary_dns   = "100.125.1.250" # HK primary DNS
  secondary_dns = "100.125.3.250" # HK secondary DNS
}

resource "huaweicloud_vpc_v1" "vpc_b" {
  provider = huaweicloud.b
  region   = var.region_b
  name     = "vpc_b-${random_pet.vpc_b.id}"
  cidr     = var.vpc_b_cidr
}

resource "huaweicloud_vpc_subnet_v1" "subnet_vpc_b" {
  provider   = huaweicloud.b
  vpc_id     = huaweicloud_vpc_v1.vpc_b.id
  name       = "subnet_vpc_b"
  cidr       = cidrsubnet(huaweicloud_vpc_v1.vpc_b.cidr, 8, 1)
  gateway_ip = cidrhost(cidrsubnet(huaweicloud_vpc_v1.vpc_b.cidr, 8, 1), 1)

  primary_dns   = "100.125.1.250" # HK primary DNS
  secondary_dns = "100.125.3.250" # HK secondary DNS
}