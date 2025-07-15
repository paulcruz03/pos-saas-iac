variable "service_name" {
  type        = string
  description = "Name for the Cloud Run service"
}

variable "region" {
  type        = string
  default     = "us-central1"
}

variable "image_url" {
  type        = string
  description = "Container image URL (e.g. gcr.io/your-project/hasura:latest)"
}

variable "database_url" {
  type        = string
  description = "Postgres connection string"
}

variable "admin_secret" {
  type        = string
  description = "Hasura admin secret"
}
