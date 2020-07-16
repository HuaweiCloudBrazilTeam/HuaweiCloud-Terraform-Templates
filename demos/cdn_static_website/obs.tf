resource "huaweicloud_obs_bucket" "bucket" {
  # region = var.region # FIXME: Remove after provider next release, higher than > v0.13.0
  bucket = var.obs_bucket_name

  #acl           = "private"
  force_destroy = true

  website {
    index_document = "index.html"
  }

  tags = {
    demo_project = var.demo_project
  }
}

resource "huaweicloud_s3_bucket_policy" "bucket_policy" {
  bucket = huaweicloud_obs_bucket.bucket.id
  #policy = file("obs_bucket_policy.json")
  policy = <<POLICY
{
	"Version": "2008-10-17",
	"Id": "Policy1594909191931",
	"Statement": [
		{
			"Sid": "Customized1594909186871",
			"Effect": "Allow",
			"Principal": {
				"AWS": [
					"*"
				]
			},
			"Action": [
				"s3:List*",
				"s3:Get*"
			],
			"Resource": [
				"arn:aws:s3:::${huaweicloud_obs_bucket.bucket.id}/*"
			],
			"Condition": {
				"Bool": {
					"aws:SecureTransport": [
						"true"
					]
				}
			}
		}
	]
}
POLICY
}



resource "huaweicloud_obs_bucket_object" "files" {
  bucket = huaweicloud_obs_bucket.bucket.bucket

  for_each = fileset("bucket-content/", "*")
  key      = each.value
  source   = "bucket-content/${each.value}"
  etag     = filemd5("bucket-content/${each.value}")
}


