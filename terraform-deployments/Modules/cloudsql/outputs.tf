output "connection_name" {
  value = google_sql_database_instance.instance.connection_name
}

output "db_host" {
  value = google_sql_database_instance.instance.private_ip_address
}

output "db_name" {
  value = google_sql_database.database.name
}

output "db_user" {
  value = google_sql_user.user.name
}

output "db_password" {
  value = var.database_password
}