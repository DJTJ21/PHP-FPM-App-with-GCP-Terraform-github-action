provider "google" {
  project = var.project_id
  region  = var.region
}

module "cloudsql" {
  source            = "./Modules/cloudsql"
  instance_name     = var.sql_instance_name
  database_name     = var.sql_database_name
  database_user     = var.sql_database_user
  database_version  = var.sql_database_version
  database_password = var.sql_database_password

  region            = var.region
}

module "storage" {
  source = "./Modules/storage"
  bucket_name = var.bucket_name
  location    = var.region
}

module "cloudrun" {
  source = "./Modules/cloudrun"
  image   = var.image
  region  = var.region
  service_name = var.cloudrun_service_name
  env_vars = {
    DB_HOST     = module.cloudsql.db_host,
    DB_NAME     = module.cloudsql.db_name,
    DB_USER     = module.cloudsql.db_user,
    DB_PASSWORD = module.cloudsql.db_password,
  }
}

module "load_balancer" {
  source                = "./Modules/load_balancer"
  lb_name               = var.lb_name
  region                = var.region
  backend_service_group = module.cloudrun.service_url
  cloud_run_service_name = module.cloudrun.service_name
}

output "sql_instance_connection_name" {
  value = module.cloudsql.connection_name
}

output "storage_bucket_url" {
  value = module.storage.bucket_url
}

output "cloudrun_service_url" {
  value = module.cloudrun.service_url
}
