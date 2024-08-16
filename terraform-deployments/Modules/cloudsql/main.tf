resource "google_sql_database_instance" "instance" {
  name = "${var.instance_name}-${random_id.bucket_id.hex}"
  region = var.region
  database_version = var.database_version
  deletion_protection = false

  settings {
    tier = "db-f1-micro"  # Type de machine pour l'instance

    backup_configuration {
      enabled = true
    }

    ip_configuration {
      ipv4_enabled = true
    }

    disk_autoresize = true
    disk_size       = 10  # Taille du disque en Go
    disk_type       = "PD_SSD"
  }
 
}

resource "google_sql_database" "database" {
  name     = var.database_name
  instance = google_sql_database_instance.instance.name
}


resource "google_sql_user" "user" {
  name     = var.database_user
  instance = google_sql_database_instance.instance.name
  password = var.database_password
}

