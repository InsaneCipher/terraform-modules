locals {
  name_prefix = lower("${var.project}-${var.environment}")

  tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}