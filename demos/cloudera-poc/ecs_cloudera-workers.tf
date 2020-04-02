resource "huaweicloud_compute_instance_v2" "cloudera-hosts" {
  count             = var.cloudera_workers_count
  name              = "ecs-${var.project_name}-host-${count.index + 1}"
  image_name        = var.ecs_image_name
  flavor_name       = var.ecs_cloudera_worker_flavor
  availability_zone = "${var.region}a"
  key_pair          = huaweicloud_compute_keypair_v2.kp_1.name
  security_groups   = [huaweicloud_networking_secgroup_v2.secgroup_cloudera.name]

  network {
    uuid = huaweicloud_vpc_subnet_v1.subnet_vpc_1.id
  }

  user_data = file("userdata.txt")

  metadata = {
    terraform         = "true"
    terraform_project = var.project_name
  }
}

resource "huaweicloud_dns_recordset_v2" "cloudera-hosts-a" {
  count   = var.cloudera_workers_count
  zone_id = huaweicloud_dns_zone_v2.private_zone.id
  name    = "${huaweicloud_compute_instance_v2.cloudera-hosts.*.name[count.index]}.${var.private_zone}"
  type    = "A"
  records = [huaweicloud_compute_instance_v2.cloudera-hosts.*.access_ip_v4[count.index]]
}

resource "huaweicloud_dns_recordset_v2" "cloudera-hosts-ptr" {
  count   = var.cloudera_workers_count
  zone_id = huaweicloud_dns_zone_v2.private_zone.id
  type    = "PTR"
  name    = "${huaweicloud_compute_instance_v2.cloudera-hosts.*.name[count.index]}.${var.private_zone}"
  records = ["${huaweicloud_compute_instance_v2.cloudera-hosts.*.access_ip_v4[count.index]}."]
}