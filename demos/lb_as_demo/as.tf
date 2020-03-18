# https://www.terraform.io/docs/providers/huaweicloud/r/as_group_v1.html
# https://support.huaweicloud.com/intl/en-us/api-as/en-us_topic_0043063023.html
resource "huaweicloud_as_group_v1" "as_group-blue" {
  scaling_group_name = "as_group-blue"

  lifecycle {
    create_before_destroy = true
  }

  scaling_configuration_id = huaweicloud_as_configuration_v1.as_demo_config_1.id
  vpc_id                   = huaweicloud_vpc_v1.vpc_1.id
  networks {
    id = huaweicloud_vpc_subnet_v1.subnet_1.id
  }

  security_groups {
    id = huaweicloud_networking_secgroup_v2.secgroup_http_and_ssh.id
  }

  min_instance_number    = var.as_group_min_instances
  desire_instance_number = var.as_group_desired_instances
  max_instance_number    = var.as_group_max_instances
  delete_publicip        = true
  cool_down_time         = 60 # default: 300

  lbaas_listeners {
    pool_id       = huaweicloud_lb_pool_v2.lb_pool_1.id
    protocol_port = huaweicloud_lb_listener_v2.lb_listener_http.protocol_port
    weight        = var.as_group_blue_weight
  }
}


resource "huaweicloud_as_group_v1" "as_group-green" {
  scaling_group_name = "as_group-green"

  lifecycle {
    create_before_destroy = true
  }

  scaling_configuration_id = huaweicloud_as_configuration_v1.as_demo_config_1.id
  vpc_id                   = huaweicloud_vpc_v1.vpc_1.id
  networks {
    id = huaweicloud_vpc_subnet_v1.subnet_1.id
  }

  security_groups {
    id = huaweicloud_networking_secgroup_v2.secgroup_http_and_ssh.id
  }

  min_instance_number    = var.as_group_min_instances
  desire_instance_number = var.as_group_desired_instances
  max_instance_number    = var.as_group_max_instances
  delete_publicip        = true
  cool_down_time         = 60 # default: 300

  lbaas_listeners {
    pool_id       = huaweicloud_lb_pool_v2.lb_pool_1.id
    protocol_port = huaweicloud_lb_listener_v2.lb_listener_http.protocol_port
    weight        = "1" # var.as_group_green_weight
  }
}

# https://www.terraform.io/docs/providers/huaweicloud/r/as_configuration_v1.html
resource "huaweicloud_as_configuration_v1" "as_demo_config_1" {
  scaling_configuration_name = "as_demo_config_1"

  lifecycle {
    create_before_destroy = true
  }

  instance_config {
    flavor = "s3.small.1"
    image  = data.huaweicloud_images_image_v2.ubuntu.id
    # image = "0a5cc0c2-1a00-4160-bfa4-591b4651de92"
    disk {
      size        = 40
      volume_type = "SATA"
      disk_type   = "SYS"
    }
    key_name  = huaweicloud_compute_keypair_v2.kp_1.name
    user_data = file("userdata.txt")

    public_ip {
      eip {
        ip_type = "5_bgp"
        bandwidth {
          size          = 1
          share_type    = "PER"
          charging_mode = "traffic"
        }
      }
    }
  }
}

data "huaweicloud_images_image_v2" "ubuntu" {
  name        = "Ubuntu 18.04 server 64bit"
  visibility  = "public"
  most_recent = true
}


# https://www.terraform.io/docs/providers/huaweicloud/r/compute_keypair_v2.html
resource "huaweicloud_compute_keypair_v2" "kp_1" {
  name       = "keypar_importada"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1OYmahtVjdGPomo4ELZoySLzV+UXfg3oazEaTA4R/oGYUrRj+O54UTad4hqNosLCoBoxV71SHoEDsp5uLBiii7jy6OCb3yKqS9rTOzVpfqcs+HH31XIrGe3z34tF6rRI3gULnTpcu4M7omPBHM3XJPvlf3+Mp1GvrU9TY7BjcqSOfZPTH/ppiHdavYN2EMdszZEiOAxSgcMCmuoW63buuaRiD5h6Qn1X9E9MH6nBKT2fsbSsBNPCJKm4asPeCa51+h+UQGqK3pNmAdwCQ2A9tv/tmb2UIFkCfBxwfkCtQMcMB+Whcp+0HhvELFpdDBNizHTkQBxwWp6sBKCTKVoQT"
}
