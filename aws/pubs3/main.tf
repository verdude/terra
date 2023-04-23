resource "aws_s3_bucket" "public_bucket" {
  bucket = "${var.environment}.${var.object_name}"
}

resource "aws_s3_bucket_acl" "public_bucket_acl" {
  bucket = aws_s3_bucket.public_bucket.id
  acl    = "public-read"
}

resource "aws_s3_object" "folder" {
  bucket = aws_s3_bucket.public_bucket.id
  key    = "${var.folder}/"
}
