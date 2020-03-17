data "huaweicloud_images_image_v2" "ubuntu_image" {
  name        = "Ubuntu 18.04 server 64bit"
  visibility  = "public"
  most_recent = true
}

output "ubuntu_image" {
  value = data.huaweicloud_images_image_v2.ubuntu_image.id
}