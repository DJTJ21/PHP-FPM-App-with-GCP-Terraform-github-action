resource "google_storage_bucket" "default"{
  name          = "${var.bucket_name}-${random_id.bucket_id.hex}"
  location      = "US"
  force_destroy = false
}