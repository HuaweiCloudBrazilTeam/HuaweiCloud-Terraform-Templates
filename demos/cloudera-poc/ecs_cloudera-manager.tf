resource "huaweicloud_compute_instance_v2" "cloudera-manager" {
  name              = "ecs-${var.project_name}-manager"
  image_name        = var.ecs_image_name
  flavor_name       = var.ecs_cloudera_manager_flavor
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

resource "huaweicloud_compute_floatingip_v2" "floatip_1" {
}

resource "huaweicloud_compute_floatingip_associate_v2" "fip_1" {
  floating_ip = huaweicloud_compute_floatingip_v2.floatip_1.address
  instance_id = huaweicloud_compute_instance_v2.cloudera-manager.id
}

resource "huaweicloud_dns_recordset_v2" "cloudera-manager-a" {
  zone_id = huaweicloud_dns_zone_v2.private_zone.id
  name    = "${huaweicloud_compute_instance_v2.cloudera-manager.name}.${var.private_zone}"
  type    = "A"
  records = [huaweicloud_compute_instance_v2.cloudera-manager.access_ip_v4]
}

resource "huaweicloud_dns_recordset_v2" "cloudera-manager-ptr" {
  zone_id = huaweicloud_dns_zone_v2.private_zone.id
  type    = "PTR"
  name    = "${huaweicloud_compute_instance_v2.cloudera-manager.name}.${var.private_zone}"
  records = ["${huaweicloud_compute_instance_v2.cloudera-manager.access_ip_v4}."]
}