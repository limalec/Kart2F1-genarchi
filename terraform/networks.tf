resource "google_compute_address" "front-ip-p2" {
  name = "todolist-front-ip-p2"
  network_tier = "PREMIUM"
  address_type = "EXTERNAL"
}

resource "google_compute_address" "back-ip-p2" {
  name = "todolist-back-ip-p2"
  address_type = "INTERNAL"
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

resource "google_compute_forwarding_rule" "back-forward-p2" {
  name = "todolist-back-forward-p2"

  ip_address = google_compute_address.back-ip-p2.id
  ip_protocol = "TCP"
  all_ports = true
  load_balancing_scheme = "INTERNAL"
  network_tier = "PREMIUM"
  backend_service = google_compute_region_backend_service.back-backend-service.id
}

output "front-ip" {
  depends_on = [google_compute_address.front-ip-p2]
  value = google_compute_address.front-ip-p2.address
}
