variable "bucket_name" {
  description = "Nom du bucket Cloud Storage"
  type        = string
}

variable "location" {
  description = "Localisation du bucket"
  type        = string
}

resource "random_id" "bucket_id" {
  byte_length = 4
}