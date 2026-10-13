variable "project" {
  type        = string
  description = "Project name, e.g. webapp"
}

variable "environment" {
  type        = string
  description = "Environment, e.g. dev or prod"

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "environment must be dev, test or prod."
  }
}
