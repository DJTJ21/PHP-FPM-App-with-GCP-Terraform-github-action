variable "instance_name" {
  description = "Nom de l'instance Cloud SQL"
  type        = string
}

variable "database_name" {
  description = "Nom de la base de données MySQL"
  type        = string
}

variable "database_user" {
  description = "Nom d'utilisateur pour la base de données"
  type        = string
}

variable "database_password" {
  description = "Mot de passe pour l'utilisateur de la base de données"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "Région pour l'instance Cloud SQL"
  type        = string
}

variable "database_version" {
  description = "Version de MYSQL"
  type        = string
}

resource "random_id" "bucket_id" {
  byte_length = 4
}