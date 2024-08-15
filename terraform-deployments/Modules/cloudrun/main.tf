resource "google_cloud_run_service" "default" {
  name     = var.service_name
  location = var.region

  template {
    spec {
      containers {
        image = var.image

        env {
          name  = "DB_HOST"
          value = var.env_vars["DB_HOST"]
        }

        env {
          name  = "DB_NAME"
          value = var.env_vars["DB_NAME"]
        }

        env {
          name  = "DB_USER"
          value = var.env_vars["DB_USER"]
        }

        env {
          name  = "DB_PASSWORD"
          value = var.env_vars["DB_PASSWORD"]
        }
      }
      
      
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}


# Autoriser l'accès non authentifié
resource "google_cloud_run_service_iam_member" "noauth" {
  service = google_cloud_run_service.default.name
  location = google_cloud_run_service.default.location
  role    = "roles/run.invoker"
  member  = "allUsers"
}