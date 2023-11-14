resource "google_compute_region_autoscaler" "front-scaler" {
  name = "todolist-front-scaler"
  target = google_compute_region_instance_group_manager.front-igm-p2.id

  autoscaling_policy {
    max_replicas = 5
    min_replicas = 1
    cooldown_period = 60

    cpu_utilization {
      target = 0.6
    }
  }
}

resource "google_compute_region_autoscaler" "back-scaler" {
  name = "todolist-back-scaler"
  target = google_compute_region_instance_group_manager.back-igm-p2.id

  autoscaling_policy {
    max_replicas = 5
    min_replicas = 1
    cooldown_period = 60

    cpu_utilization {
      target = 0.6
    }
  }
}