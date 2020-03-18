# https://www.terraform.io/docs/providers/huaweicloud/r/as_group_v1.html
# https://support.huaweicloud.com/intl/en-us/api-as/en-us_topic_0043063023.html
resource "huaweicloud_as_group_v1" "as_demo_group" {
  scaling_group_name = "as_demo_group"

  scaling_configuration_id = huaweicloud_as_configuration_v1.as_demo_config_1.id
  vpc_id                   = huaweicloud_vpc_v1.vpc_1.id
  networks {
    id = huaweicloud_vpc_subnet_v1.subnet_1.id
  }

  security_groups {
    id = huaweicloud_networking_secgroup_v2.secgroup_http_and_ssh.id
  }

  min_instance_number    = 2
  desire_instance_number = 6
  max_instance_number    = 7
  delete_publicip        = true
  cool_down_time         = 60 # default: 300

  lbaas_listeners {
    pool_id       = huaweicloud_lb_pool_v2.lb_pool_1.id
    protocol_port = huaweicloud_lb_listener_v2.lb_listener_http.protocol_port
  }
  # lbaas_listeners {
  #   pool_id       = huaweicloud_lb_pool_v2.lb_pool_ssh.id
  #   protocol_port = huaweicloud_lb_listener_v2.lb_listener_ssh.protocol_port
  # }

}

# https://www.terraform.io/docs/providers/huaweicloud/r/as_configuration_v1.html
resource "huaweicloud_as_configuration_v1" "as_demo_config_1" {
  scaling_configuration_name = "as_demo_config_1"
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

    # metadata {
    #   activity = "as_lb_demo_tf"
    # }

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

# https://www.terraform.io/docs/providers/huaweicloud/r/as_policy_v1.html
# https://support.huaweicloud.com/en-us/api-as/en-us_topic_0103010240.html
# resource "huaweicloud_as_policy_v1" "aspolicy_add" {
#   scaling_group_id    = huaweicloud_as_group_v1.as_demo_group.id
#   scaling_policy_name = "aspolicy_add"
#   scaling_policy_type = "SCHEDULED"
#   scaling_policy_action {
#     operation       = "ADD"
#     instance_number = 1
#   }
#   cool_down_time = 30 # default: 900

#   scheduled_policy {
#     # launch_time = "2020-01-30T15:09Z"
#     launch_time = 
#   }
# }

output "as_instances_ids" {
  value = huaweicloud_as_group_v1.as_demo_group.instances
}
