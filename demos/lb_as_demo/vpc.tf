# https://www.terraform.io/docs/providers/huaweicloud/r/vpc_v1.html
resource "huaweicloud_vpc_v1" "vpc_1" {
  # region = # optional; assumed from the provider if no informed
  name = "vpc_lb-as_demo"
  cidr = var.vpc_cidr
}

# https://www.terraform.io/docs/providers/huaweicloud/r/networking_subnet_v2.html
# https://www.terraform.io/docs/providers/huaweicloud/r/vpc_subnet_v1.html
resource "huaweicloud_vpc_subnet_v1" "subnet_1" {
  vpc_id     = huaweicloud_vpc_v1.vpc_1.id
  name       = "subnet_1"
  cidr       = cidrsubnet(huaweicloud_vpc_v1.vpc_1.cidr, 8, 1)
  gateway_ip = cidrhost(cidrsubnet(huaweicloud_vpc_v1.vpc_1.cidr, 8, 1), 1)

  # When the subnet DNS servers aren't defined, the field is kept empty in the console
  # and the instances use the same IP of the DHCP server, which doesn't answer as a DNS server
  # it's a BUG, but not sure where
  ## https://support.huaweicloud.com/intl/en-us/dns_faq/dns_faq_002.html
  primary_dns   = "100.125.1.250" # HK primary DNS
  secondary_dns = "100.125.3.250" # HK secondary DNS
}

# https://www.terraform.io/docs/providers/huaweicloud/r/networking_secgroup_v2.html
resource "huaweicloud_networking_secgroup_v2" "secgroup_http_and_ssh" {
  name        = "sec_group_as-lb"
  description = "created from terraform. sec_group for sn_1"
  # delete_default_rules = true # default false
}

# https://www.terraform.io/docs/providers/huaweicloud/r/networking_secgroup_rule_v2.html
# resource "huaweicloud_networking_secgroup_rule_v2" "secrule_outbound_ipv4" {
#   direction         = "egress"
#   ethertype         = "IPv4"
#   security_group_id = huaweicloud_networking_secgroup_v2.secgroup_http_and_ssh.id
# }

# resource "huaweicloud_networking_secgroup_rule_v2" "secrule_outbound_ipv6" {
#   direction         = "egress"
#   ethertype         = "IPv6"
#   security_group_id = huaweicloud_networking_secgroup_v2.secgroup_http_and_ssh.id
# }

resource "huaweicloud_networking_secgroup_rule_v2" "secrule_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = huaweicloud_networking_secgroup_v2.secgroup_http_and_ssh.id
}

resource "huaweicloud_networking_secgroup_rule_v2" "secrule_http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = huaweicloud_networking_secgroup_v2.secgroup_http_and_ssh.id
}
