##### # Region A ####
resource "huaweicloud_vpnaas_service_v2" "vpn_service_a" {
  name      = "vpn_service_a"
  router_id = huaweicloud_vpc_v1.vpc_a.id
}

resource "huaweicloud_vpnaas_site_connection_v2" "vpn_connection_a_to_b" {
  name              = "vpn_connection_a_to_b"
  ikepolicy_id      = huaweicloud_vpnaas_ike_policy_v2.policy_ike_a.id
  ipsecpolicy_id    = huaweicloud_vpnaas_ipsec_policy_v2.policy_ipsec_a.id
  vpnservice_id     = huaweicloud_vpnaas_service_v2.vpn_service_a.id
  psk               = var.vpn_psk
  peer_address      = huaweicloud_vpnaas_service_v2.vpn_service_b.external_v4_ip
  peer_id           = huaweicloud_vpnaas_service_v2.vpn_service_b.external_v4_ip
  local_ep_group_id = huaweicloud_vpnaas_endpoint_group_v2.local_ep_group_a.id
  peer_ep_group_id  = huaweicloud_vpnaas_endpoint_group_v2.peer_ep_group_a.id
}

resource "huaweicloud_vpnaas_endpoint_group_v2" "local_ep_group_a" {
  name      = "local_ep_group_a"
  type      = "cidr"
  endpoints = [huaweicloud_vpc_v1.vpc_a.cidr]
}

resource "huaweicloud_vpnaas_endpoint_group_v2" "peer_ep_group_a" {
  name      = "peer_ep_group_a"
  type      = "cidr"
  endpoints = [huaweicloud_vpc_v1.vpc_b.cidr]
}

resource "huaweicloud_vpnaas_ipsec_policy_v2" "policy_ipsec_a" {
  name = "policy_ipsec_a"
}

resource "huaweicloud_vpnaas_ike_policy_v2" "policy_ike_a" {
  name = "policy_ike_a"
}

##### # Region B ####
resource "huaweicloud_vpnaas_service_v2" "vpn_service_b" {
  provider  = huaweicloud.b
  name      = "vpn_service_b"
  router_id = huaweicloud_vpc_v1.vpc_b.id
}

resource "huaweicloud_vpnaas_site_connection_v2" "vpn_connection_b_to_a" {
  provider          = huaweicloud.b
  name              = "vpn_connection_b_to_a"
  ikepolicy_id      = huaweicloud_vpnaas_ike_policy_v2.policy_ike_b.id
  ipsecpolicy_id    = huaweicloud_vpnaas_ipsec_policy_v2.policy_ipsec_b.id
  vpnservice_id     = huaweicloud_vpnaas_service_v2.vpn_service_b.id
  psk               = var.vpn_psk
  peer_address      = huaweicloud_vpnaas_service_v2.vpn_service_a.external_v4_ip
  peer_id           = huaweicloud_vpnaas_service_v2.vpn_service_a.external_v4_ip
  local_ep_group_id = huaweicloud_vpnaas_endpoint_group_v2.local_ep_group_b.id
  peer_ep_group_id  = huaweicloud_vpnaas_endpoint_group_v2.peer_ep_group_b.id
}


resource "huaweicloud_vpnaas_endpoint_group_v2" "local_ep_group_b" {
  provider  = huaweicloud.b
  name      = "local_ep_group_b"
  type      = "cidr"
  endpoints = [huaweicloud_vpc_v1.vpc_b.cidr]
}

resource "huaweicloud_vpnaas_endpoint_group_v2" "peer_ep_group_b" {
  provider  = huaweicloud.b
  name      = "peer_ep_group_b"
  type      = "cidr"
  endpoints = [huaweicloud_vpc_v1.vpc_a.cidr]
}


resource "huaweicloud_vpnaas_ipsec_policy_v2" "policy_ipsec_b" {
  provider = huaweicloud.b
  name     = "policy_ipsec_b"
}

resource "huaweicloud_vpnaas_ike_policy_v2" "policy_ike_b" {
  provider = huaweicloud.b
  name     = "policy_ike_b"
}
