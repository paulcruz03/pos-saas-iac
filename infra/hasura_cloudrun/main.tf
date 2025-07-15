resource "google_artifact_registry_repository" "hasura_repo" {
  location      = var.region
  repository_id = "hasura-repo"
  format        = "DOCKER"
}

resource "google_cloud_run_service" "hasura" {
  name     = var.service_name
  location = var.region

  template {
    spec {
      containers {
        image = var.image_url

        env {
          name  = "HASURA_GRAPHQL_DATABASE_URL"
          value = var.database_url
        }
        env {
          name  = "HASURA_GRAPHQL_ENABLE_CONSOLE"
          value = "true"
        }
        env {
          name  = "HASURA_GRAPHQL_DEV_MODE"
          value = "true"
        }
        env {
          name  = "HASURA_GRAPHQL_ADMIN_SECRET"
          value = var.admin_secret
        }
      }
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "1"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "public_access" {
  location        = google_cloud_run_service.hasura.location
  service         = google_cloud_run_service.hasura.name
  role            = "roles/run.invoker"
  member          = "allUsers"
}
