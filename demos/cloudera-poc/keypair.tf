resource "huaweicloud_compute_keypair_v2" "kp_1" {
  name       = "${var.project_name}-keypair"
  public_key = var.keypair_public_key
}
