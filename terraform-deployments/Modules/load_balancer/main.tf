resource "google_compute_global_address" "default" {
  name = var.lb_name
}

resource "google_compute_url_map" "default" {
  name            = var.lb_name
  default_service = google_compute_backend_service.default.self_link
}

resource "google_compute_target_http_proxy" "default" {
  name      = var.lb_name
  url_map   = google_compute_url_map.default.self_link
}

resource "google_compute_global_forwarding_rule" "default" {
  name       = var.lb_name
  target     = google_compute_target_http_proxy.default.self_link
  port_range = "80"

  depends_on = [google_compute_target_http_proxy.default]
}

resource "google_compute_backend_service" "default" {
  name          = var.lb_name
  backend {
    group = var.backend_service_group
  }
  health_checks = [google_compute_health_check.default.self_link]
}

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
