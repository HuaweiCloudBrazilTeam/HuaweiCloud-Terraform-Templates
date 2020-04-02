# Este template cria os seguintes recursos:
## 1 VPC e 1 Subnet dentro da mesma
## 1 instância de computação ECS Linux
## 1 Elastic IP, associado à instância, para conexão à mesma pela Internet
## 1 security group, liberando acesso originado da Internet para HTTP (TCP 80) e SSH (TCP 22)
## 1 keypar (apenas a chave pública) para autenticação por SSH na instância usando a chave privada

variable "vpc_cidr" { # Faixa de endereços da VPC
  default = "10.70.0.0/16"
}

# https://www.terraform.io/docs/providers/huaweicloud/r/vpc_v1.html
resource "huaweicloud_vpc_v1" "vpc_single_instance_1" {
  # region = # opcional; assumido a partir dos parâmetros do provider
  name = "vpc_single_instance_1"
  cidr = var.vpc_cidr
}

# https://www.terraform.io/docs/providers/huaweicloud/r/networking_subnet_v2.html
# https://www.terraform.io/docs/providers/huaweicloud/r/vpc_subnet_v1.html
resource "huaweicloud_vpc_subnet_v1" "subnet_1" {
  vpc_id = huaweicloud_vpc_v1.vpc_single_instance_1.id
  name   = "subnet_1"
  # Range da subnet e endereço do gateway são calculados automaticamente a partir da VPC
  cidr       = cidrsubnet(huaweicloud_vpc_v1.vpc_single_instance_1.cidr, 8, 1)
  gateway_ip = cidrhost(cidrsubnet(huaweicloud_vpc_v1.vpc_single_instance_1.cidr, 8, 1), 1)

  # Internal DNS servers
  ## https://support.huaweicloud.com/intl/en-us/dns_faq/dns_faq_002.html
  primary_dns   = "100.125.1.250"
  secondary_dns = "100.125.3.250"
}

# https://www.terraform.io/docs/providers/huaweicloud/r/networking_secgroup_v2.html
resource "huaweicloud_networking_secgroup_v2" "secgroup_http_and_ssh" {
  name = "secgroup_http_and_ssh"
  # delete_default_rules = true # default false
}

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

output "instance_internal_ip_addr" {
  value = huaweicloud_compute_instance_v2.test-server-vpc.network[0].fixed_ip_v4
}

output "instance_eip" {
  value = huaweicloud_vpc_eip_v1.eip_1.publicip[0].ip_address
}

# https://www.terraform.io/docs/providers/huaweicloud/r/compute_keypair_v2.html
resource "huaweicloud_compute_keypair_v2" "kp_1" {
  name       = "keypar_importada"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1OYmahtVjdGPomo4ELZoySLzV+UXfg3oazEaTA4R/oGYUrRj+O54UTad4hqNosLCoBoxV71SHoEDsp5uLBiii7jy6OCb3yKqS9rTOzVpfqcs+HH31XIrGe3z34tF6rRI3gULnTpcu4M7omPBHM3XJPvlf3+Mp1GvrU9TY7BjcqSOfZPTH/ppiHdavYN2EMdszZEiOAxSgcMCmuoW63buuaRiD5h6Qn1X9E9MH6nBKT2fsbSsBNPCJKm4asPeCa51+h+UQGqK3pNmAdwCQ2A9tv/tmb2UIFkCfBxwfkCtQMcMB+Whcp+0HhvELFpdDBNizHTkQBxwWp6sBKCTKVoQT"
}



# https://www.terraform.io/docs/providers/huaweicloud/r/compute_instance_v2.html
# https://www.terraform.io/docs/providers/openstack/r/compute_instance_v2.html
# https://github.com/terraform-providers/terraform-provider-huaweicloud/blob/master/huaweicloud/resource_huaweicloud_compute_instance_v2.go
resource "huaweicloud_compute_instance_v2" "test-server-vpc" {
  name = "test-server-terraform-vpc"
  # image_id = "cbe0df31-1150-488a-a9b2-612c745e1be0"
  image_name        = "Ubuntu 18.04 server 64bit"
  flavor_name       = "s3.small.1"
  availability_zone = "${var.region}a"
  key_pair          = huaweicloud_compute_keypair_v2.kp_1.name
  security_groups   = [huaweicloud_networking_secgroup_v2.secgroup_http_and_ssh.name]

  network {
    uuid = huaweicloud_vpc_subnet_v1.subnet_1.id
  }

  # Troubleshooting logs are /var/log/cloud-init*
  user_data = <<-EOT
    timedatectl set-timezone America/Sao_Paulo    
    echo "Hello, the time is now $(date -R)" | tee /output.txt

    apt-get update
    apt-get install nginx --yes
    echo "<h1>Hello from Nginx</h1><br>My hostname is $(hostname)"> /var/www/html/index.html
  EOT

  metadata = {
    terraform = "true" # exemplo de tag
  }
}

# https://www.terraform.io/docs/providers/huaweicloud/r/vpc_eip_v1.html
resource "huaweicloud_vpc_eip_v1" "eip_1" {
  publicip {
    type    = "5_bgp" # only "5_bgp"is supported: https://support.huaweicloud.com/en-us/api-eip/eip_api_0001.html
    port_id = huaweicloud_compute_instance_v2.test-server-vpc.network[0].port
  }
  bandwidth {
    name        = "test_bw"
    charge_mode = "traffic" # cobrança por tráfego de dados ("traffic") ou reserva de banda ("bandwidth")
    share_type  = "PER"     # Banda dedicada ("PER") ou compartilhada ("WHOLE") com outras instâncias
    size        = 1         # Banda em Mbps (de 1 up até 300)    
  }
}
