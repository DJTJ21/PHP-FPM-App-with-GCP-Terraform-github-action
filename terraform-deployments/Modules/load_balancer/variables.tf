variable "lb_name" {
  description = "Nom de l'équilibrage de charge"
  type        = string
}

variable "backend_service_group" {
  description = "Le service backend"
  type        = string
}

variable "region" {
  description = "Région pour le service Cloud Run"
  type        = string
}

variable "cloud_run_service_name" {
  description = "Nom du service Cloud Run à utiliser dans le NEG"
  type        = string
}
