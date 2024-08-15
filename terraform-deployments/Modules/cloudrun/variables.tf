variable "service_name" {
  description = "Nom du service Cloud Run"
  type        = string
}

variable "image" {
  description = "Image de conteneur à déployer"
  type        = string
}

variable "region" {
  description = "Région pour le service Cloud Run"
  type        = string
}

variable "env_vars" {
  description = "Variables d'environnement pour le conteneur"
  type        = map(string)
}

