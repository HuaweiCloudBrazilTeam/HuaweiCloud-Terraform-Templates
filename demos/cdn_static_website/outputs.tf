output "bucket_access_s3_api" {
  value = huaweicloud_obs_bucket.bucket.bucket_domain_name
}

output "bucket_access_website" {
    value = "https://${huaweicloud_obs_bucket.bucket.id}.obs-website.${huaweicloud_obs_bucket.bucket.region}.myhuaweicloud.com/"
}
