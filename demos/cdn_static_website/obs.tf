resource "huaweicloud_obs_bucket" "bucket" {
  region        = var.region # FIXME: Remove after provider next release, higher than > v0.13.0
  bucket        = var.obs_bucket_name
  acl           = "public-read"
  force_destroy = true

  website {
    index_document = "index.html"
  }

  tags = {
    demo_project = var.demo_project
  }
}

resource "huaweicloud_obs_bucket_object" "files" {
  bucket = huaweicloud_obs_bucket.bucket.bucket

  for_each = fileset("bucket-content/", "*")
  key      = each.value
  source   = "bucket-content/${each.value}"
  etag     = filemd5("bucket-content/${each.value}")
}