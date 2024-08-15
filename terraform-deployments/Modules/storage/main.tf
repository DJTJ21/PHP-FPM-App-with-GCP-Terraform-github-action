resource "google_storage_bucket" "my-bucket"{
  name          = var.bucket_name
  location      = "US"
  force_destroy = false
}