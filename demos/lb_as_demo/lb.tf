# https://www.terraform.io/docs/providers/huaweicloud/r/lb_loadbalancer_v2.html
# https://support.huaweicloud.com/en-us/api-elb/en-us_topic_0096561535.html
resource "huaweicloud_lb_loadbalancer_v2" "loadbalancer_demo_1" {
  name          = "loadbalancer_demo_1"
  vip_subnet_id = huaweicloud_vpc_subnet_v1.subnet_1.subnet_id # subnet_id is the "native OpenStack ID"
}

# https://www.terraform.io/docs/providers/huaweicloud/r/networking_floatingip_v2.html
# https://github.com/terraform-providers/terraform-provider-huaweicloud/blob/master/huaweicloud/resource_huaweicloud_networking_floatingip_v2.go
# resource "huaweicloud_networking_floatingip_v2" "lb_eip_1" {
#   port_id = huaweicloud_lb_loadbalancer_v2.loadbalancer_demo_1.vip_port_id
# }

resource "huaweicloud_vpc_eip_v1" "lb_eip_1" {
  publicip {
    type    = "5_bgp" # only "5_bgp"is supported: https://support.huaweicloud.com/en-us/api-eip/eip_api_0001.html
    port_id = huaweicloud_lb_loadbalancer_v2.loadbalancer_demo_1.vip_port_id
  }
  bandwidth {
    name        = "test_bw"
    charge_mode = "traffic" # billing by "traffic" or "bandwidth"
    share_type  = "PER"     # "PER" (dedicated) or "WHOLE" (shared)
    size        = 1         # Mbps (from 1 up to 300)    
  }
}



# https://www.terraform.io/docs/providers/huaweicloud/r/lb_listener_v2.html
# https://support.huaweicloud.com/en-us/api-elb/en-us_topic_0096561483.html
resource "huaweicloud_lb_listener_v2" "lb_listener_http" {
  loadbalancer_id = huaweicloud_lb_loadbalancer_v2.loadbalancer_demo_1.id
  protocol        = "HTTP"
  protocol_port   = 80
}

# https://www.terraform.io/docs/providers/huaweicloud/r/lb_pool_v2.html
# https://support.huaweicloud.com/en-us/api-elb/en-us_topic_0141008467.html
resource "huaweicloud_lb_pool_v2" "lb_pool_1" {
  listener_id = huaweicloud_lb_listener_v2.lb_listener_http.id
  protocol    = "HTTP"
  lb_method   = "ROUND_ROBIN"

  # persistence {
  #   type        = "HTTP_COOKIE"
  #   cookie_name = "LbDemoCookie"
  # }
}


# resource "huaweicloud_lb_listener_v2" "lb_listener_ssh" {
#   loadbalancer_id = huaweicloud_lb_loadbalancer_v2.loadbalancer_demo_1.id
#   protocol        = "TCP"
#   protocol_port   = 22
# }

# resource "huaweicloud_lb_pool_v2" "lb_pool_ssh" {
#   listener_id = huaweicloud_lb_listener_v2.lb_listener_ssh.id
#   protocol    = "TCP"
#   lb_method   = "ROUND_ROBIN"
# }