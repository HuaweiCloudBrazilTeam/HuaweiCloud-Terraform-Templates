resource "huaweicloud_dns_zone_v2" "private_zone" {
  name      = var.private_zone
  email     = "hwclouds.cs@huawei.com" # hwclouds.cs@huawei.com is the assumed default email
  zone_type = "private"
  router {
    router_region = var.region
    router_id     = huaweicloud_vpc_v1.vpc_1.id
  }
}