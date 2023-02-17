resource "aws_s3_bucket" "private_bucket" {
  bucket = "${var.environment}.${var.object_name}"
}

resource "aws_s3_bucket_acl" "private_bucket_acl" {
  bucket = aws_s3_bucket.private_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_cors_configuration" "s3_private_bucket_cors" {
  bucket = aws_s3_bucket.private_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["http://example.com"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_intelligent_tiering_configuration" "default" {
  bucket = aws_s3_bucket.private_bucket.id
  name   = "default"

  status = "Enabled"

  filter {
    prefix = "${var.folder}/"
  }

  tiering {
    access_tier = "ARCHIVE_ACCESS"
    days        = 90
  }

  tiering {
    access_tier = "DEEP_ARCHIVE_ACCESS"
    days        = 180
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "aes256" {
  bucket = aws_s3_bucket.private_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "default" {
  bucket = aws_s3_bucket.private_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "folder" {
  bucket = aws_s3_bucket.private_bucket.id
  key    = "${var.folder}/"
}
