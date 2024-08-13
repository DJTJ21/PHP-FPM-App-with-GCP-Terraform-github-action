output "load_balancer_ip" {
  description = "Adresse IP du Load Balancer"
  value       = google_compute_global_address.default.address
}
