variable "bucket_name" {
  type        = string
  description = "Globally unique S3 bucket name"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "Bucket name must be 3-63 characters: lowercase letters, numbers, dots and hyphens."
  }
}

variable "source_dir" {
  type        = string
  description = "Local folder containing the website files"
}

variable "index_document" {
  type    = string
  default = "index.html"
}

variable "error_document" {
  type    = string
  default = "error.html"
}

variable "force_destroy" {
  type        = bool
  description = "Allow destroy to delete the bucket even if it still contains files"
  default     = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
