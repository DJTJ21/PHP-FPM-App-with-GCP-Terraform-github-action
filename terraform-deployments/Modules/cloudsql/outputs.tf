output "connection_name" {
  value = google_sql_database_instance.default.connection_name
}

output "db_host" {
  value = google_sql_database_instance.default.private_ip_address
}

output "db_name" {
  value = google_sql_database.default.name
}

output "db_user" {
  value = google_sql_user.default.name
}

output "db_password" {
  value = var.database_password
}