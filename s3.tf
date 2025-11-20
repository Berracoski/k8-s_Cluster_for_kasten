resource "aws_s3_bucket" "my_bucket" {
  bucket = "repositorio-curso-claro"

  tags = {
    Name        = "repositorio-curso-claro"
  }
}

# Optional: block public access by default for security
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket                  = aws_s3_bucket.my_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}