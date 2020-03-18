output "loadbalancer_eip" {
  # value       = huaweicloud_networking_floatingip_v2.lb_eip_1.address
  value       = huaweicloud_vpc_eip_v1.lb_eip_1.publicip[*].ip_address
  description = "The external IP of the Load Balancer"
}

output "as_group-blue_instances-ids" {
  value = huaweicloud_as_group_v1.as_group-blue.instances
}

output "as_group-blue_weight" {
  value = var.as_group_blue_weight
}


output "as_group_green_instances-ids" {
  value = huaweicloud_as_group_v1.as_group-green.instances
}

output "as_group_green_weight" {
  value = var.as_group_green_weight
}



