variable "lb_name" {
  description = "Nom de l'équilibrage de charge"
  type        = string
}

variable "backend_service_group" {
  description = "Le service backend"
  type        = string
}
