resource "google_compute_global_address" "default" {
  name = var.lb_name
}

resource "google_compute_url_map" "default" {
  name            = var.lb_name
  default_service = google_compute_backend_service.default.self_link
}

resource "google_compute_target_http_proxy" "default" {
  name    = var.lb_name
  url_map = google_compute_url_map.default.self_link
}

resource "google_compute_global_forwarding_rule" "default" {
  name       = var.lb_name
  target     = google_compute_target_http_proxy.default.self_link
  port_range = "80"

  depends_on = [google_compute_target_http_proxy.default]
}

resource "google_compute_backend_service" "default" {
  name = var.lb_name

  backend {
    group = google_compute_region_network_endpoint_group.cloud_run_neg.id
  }

}

# Création du Network Endpoint Group (NEG) pour le service Cloud Run
resource "google_compute_region_network_endpoint_group" "cloud_run_neg" {
  name                  = "${var.lb_name}-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region

  cloud_run {
    service = var.cloud_run_service_name
  }
}


# A utiliser si jamais j'en est besoin

resource "google_compute_health_check" "default" {
  name               = "${var.lb_name}-hc"
  check_interval_sec = 10
  timeout_sec        = 5
  healthy_threshold  = 2
  unhealthy_threshold = 2

  http_health_check {
    request_path = "/"
    port         = 80
  }
}
