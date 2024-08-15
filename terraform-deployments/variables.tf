variable "project_id" {
  description = "ID du projet Google Cloud"
  type        = string
}

variable "region" {
  description = "Région dans laquelle déployer les ressources"
  type        = string
  default     = "us-central1"
}

variable "sql_instance_name" {
  description = "Nom de l'instance Cloud SQL"
  type        = string
}

variable "sql_database_name" {
  description = "Nom de la base de données MySQL"
  type        = string
}

variable "sql_database_user" {
  description = "Nom d'utilisateur pour la base de données MySQL"
  type        = string
}

variable "sql_database_password" {
  description = "Mot de passe pour l'utilisateur MySQL"
  type        = string
  sensitive   = true
}

variable "bucket_name" {
  description = "Nom du bucket Cloud Storage"
  type        = string
}

variable "image" {
  description = "Nom de l'image de conteneur Docker à utiliser pour Cloud Run"
  type        = string
}

variable "cloudrun_service_name" {
  description = "Nom du service Cloud Run"
  type        = string
}

variable "sql_database_version" {
  description = "Version de MYSQL"
  type        = string
  
}

variable "lb_name" {
  description = "Nom de l'équilibrage de charge"
  type        = string
}

variable "cloud_run_service_name" {
  description = "Nom du service Cloud Run à utiliser dans le NEG"
  type        = string
}