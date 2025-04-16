variable "github_repo" {
  description = "GitHub repo in 'owner/repo' format"
  type        = string
}

variable "secret_name" {
  description = "Name of the secret in Secrets Manager"
  type        = string
  default     = "petclinic-db-secret"
}

variable "secret_username" {
  description = "Username for the PetClinic database"
  type        = string
  default     = "admin"
}

variable "lifecycle_ignore_changes" {
  type        = bool
  default     = true
  description = "Whether to ignore changes to secret value"
}
