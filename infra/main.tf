provider "google" {
  project = var.project_id
  region  = var.region
}

module "hasura_cloudrun" {
  source        = "./modules/hasura_cloudrun"
  service_name  = "hasura"
  region        = var.region
  image_url     = var.image_url
  database_url  = var.database_url
  admin_secret  = var.admin_secret
}
