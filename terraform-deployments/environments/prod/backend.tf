terraform {
  backend "gcs" {
    bucket = "terraform-buckets"
    prefix = "terraform/state"
  }
}
