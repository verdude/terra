module "prod-bucket" {
  source = "../../aws/s3"

  environment = "prod"
  object_name = "thingy"
  folder      = "thingies"
}

module "staging-bucket" {
  source = "../../aws/s3"

  environment = "staging"
  object_name = "thingy"
  folder      = "thingies"
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "thingy.logs"
}

resource "aws_s3_bucket_acl" "log_acl" {
  bucket = aws_s3_bucket.log_bucket.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_logging" "prod" {
  bucket = module.prod-bucket.bucket.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "thingies/"
}

resource "aws_s3_bucket_logging" "staging" {
  bucket = module.staging-bucket.bucket.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "thingies/"
}
