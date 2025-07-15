variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "image_url" {
  description = "URL of the Hasura Docker image"
  type        = string
}

variable "database_url" {
  description = "Postgres connection string"
  type        = string
}

variable "admin_secret" {
  description = "Hasura admin secret"
  type        = string
}
