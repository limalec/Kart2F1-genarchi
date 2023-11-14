resource "google_compute_address" "front-ip-p2" {
  name = "todolist-front-ip-p2"
  network_tier = "PREMIUM"
}

resource "google_compute_forwarding_rule" "front-forward-p2" {
  name = "todolist-front-forward-p2"

  ip_address = google_compute_address.front-ip-p2.id
  ip_protocol = "TCP"
  all_ports = true
  load_balancing_scheme = "EXTERNAL"
  network_tier = "PREMIUM"
  backend_service = google_compute_region_backend_service.front-backend-service.id
}

output "front-ip" {
  depends_on = [google_compute_address.front-ip-p2]
  value = google_compute_address.front-ip-p2.address
}