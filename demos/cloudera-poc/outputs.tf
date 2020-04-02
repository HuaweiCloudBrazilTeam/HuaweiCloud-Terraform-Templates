output "cloudera-master-eip" {
  value = huaweicloud_compute_floatingip_v2.floatip_1.address
}

output "cloudera-hosts" {
  value = huaweicloud_compute_instance_v2.cloudera-hosts.*.name
}
