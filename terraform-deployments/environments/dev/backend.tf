terraform {
  backend "gcs" {
    bucket = "terraform-buckets-dev"
    prefix = "terraform/state"
  }
}
