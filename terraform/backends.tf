resource "google_compute_region_health_check" "front-health-checks" {
  name = "todolist-front-health-check-p2"
  timeout_sec = 30
  check_interval_sec = 30
  healthy_threshold = 10
  unhealthy_threshold = 10

  tcp_health_check {
    port = 80
    proxy_header = "NONE"
  }
}

resource "google_compute_region_backend_service" "front-backend-service" {
  name = "todolist-front-backend-service-p2"
  protocol = "TCP"
  session_affinity = "NONE"
  timeout_sec = 30
  backend {
    balancing_mode = "CONNECTION"
    group = google_compute_region_instance_group_manager.front-igm-p2.instance_group
    failover = false
  }
  connection_draining_timeout_sec = 300
  health_checks = [ google_compute_region_health_check.front-health-checks.id ]
  load_balancing_scheme = "EXTERNAL"
}

resource "google_compute_region_health_check" "back-health-checks" {
  name = "todolist-back-health-check-p2"
  timeout_sec = 30
  check_interval_sec = 30
  healthy_threshold = 10
  unhealthy_threshold = 10

  tcp_health_check {
    port = 3000
    proxy_header = "NONE"
  }
}

resource "google_compute_region_backend_service" "back-backend-service" {
  name = "todolist-back-backend-service-p2"
  protocol = "TCP"
  session_affinity = "NONE"
  timeout_sec = 30
  backend {
    balancing_mode = "CONNECTION"
    group = google_compute_region_instance_group_manager.back-igm-p2.instance_group
    failover = false
  }
  connection_draining_timeout_sec = 300
  health_checks = [ google_compute_region_health_check.back-health-checks.id ]
  load_balancing_scheme = "INTERNAL"
}
