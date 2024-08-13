resource "google_sql_database_instance" "default" {
  name = var.instance_name
  region = var.region
  database_version = var.database_version
  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_database" "default" {
  name     = var.database_name
  instance = google_sql_database_instance.default.name
}

resource "google_sql_user" "default" {
  name     = var.database_user
  instance = google_sql_database_instance.default.name
  password = var.database_password
}

