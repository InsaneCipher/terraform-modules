resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy
  tags          = var.tags
}

resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = var.index_document
  }

  error_document {
    key = var.error_document
  }
}

# New buckets block public access by default; allow a public bucket policy
resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = false
  restrict_public_buckets = false
}

data "aws_iam_policy_document" "public_read" {
  statement {
    sid       = "PublicReadGetObject"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.this.arn}/*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.public_read.json

  # The policy is rejected if applied before public access is unblocked
  depends_on = [aws_s3_bucket_public_access_block.this]
}

locals {
  mime_types = {
    ".html" = "text/html"
    ".css"  = "text/css"
    ".js"   = "application/javascript"
    ".json" = "application/json"
    ".png"  = "image/png"
    ".jpg"  = "image/jpeg"
    ".jpeg" = "image/jpeg"
    ".gif"  = "image/gif"
    ".svg"  = "image/svg+xml"
    ".ico"  = "image/x-icon"
    ".txt"  = "text/plain"
  }
}

resource "aws_s3_object" "site_files" {
  for_each = fileset(var.source_dir, "**")

  bucket       = aws_s3_bucket.this.id
  key          = each.value
  source       = "${var.source_dir}/${each.value}"
  etag         = filemd5("${var.source_dir}/${each.value}")
  content_type = lookup(local.mime_types, lower(try(regex("\\.[^.]+$", each.value), "")), "application/octet-stream")
}
