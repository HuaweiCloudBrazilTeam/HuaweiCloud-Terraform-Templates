# https://www.terraform.io/docs/providers/huaweicloud/r/networking_secgroup_v2.html
resource "huaweicloud_networking_secgroup_v2" "secgroup_cloudera" {
  name = "secgroup_cloudera"
  # delete_default_rules = true # default false
}

resource "huaweicloud_networking_secgroup_rule_v2" "secrule_secgroup_cloudera" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_group_id   = huaweicloud_networking_secgroup_v2.secgroup_cloudera.id
  security_group_id = huaweicloud_networking_secgroup_v2.secgroup_cloudera.id
}

resource "huaweicloud_networking_secgroup_rule_v2" "secrule_cloudera_manager" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 7180
  port_range_max    = 7180
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = huaweicloud_networking_secgroup_v2.secgroup_cloudera.id
}

resource "huaweicloud_networking_secgroup_rule_v2" "secrule_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = huaweicloud_networking_secgroup_v2.secgroup_cloudera.id
}
