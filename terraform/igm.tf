resource "google_compute_region_instance_group_manager" "front-igm-p2" {
  name = "todolist-front-igm"

  base_instance_name = "todolist-front-p2"
  distribution_policy_zones = [ "europe-west9-a", "europe-west9-b", "europe-west9-c" ]

  version {
    name = "todolist-front-p2"
    instance_template = google_compute_region_instance_template.todolist-front-template.self_link
  }

  update_policy {
    type = "PROACTIVE"
    minimal_action = "REPLACE"
    max_unavailable_fixed = 3
  }

  named_port {
    name = "http"
    port = 80
  }
}

resource "google_compute_region_instance_group_manager" "back-igm-p2" {
  name = "todolist-back-igm"

  base_instance_name = "todolist-back-p2"
  distribution_policy_zones = [ "europe-west9-a", "europe-west9-b", "europe-west9-c" ]

  version {
    name = "todolist-back-p2"
    instance_template = google_compute_region_instance_template.todolist-back-template.self_link
  }

  update_policy {
    type = "PROACTIVE"
    minimal_action = "REPLACE"
    max_unavailable_fixed = 3
  }
}

resource "google_compute_region_instance_group_manager" "database-igm-p2" {
  name = "todolist-database-p2"
  base_instance_name = "todolist-database-p2"
  distribution_policy_zones = [ "europe-west9-a", "europe-west9-b", "europe-west9-c" ]

  version {
    name = "todolist-database-p2"
    instance_template = google_compute_region_instance_template.todolist-database-template.self_link
  }

  update_policy {
    type = "PROACTIVE"
    minimal_action = "REPLACE"
    max_unavailable_fixed = 3
  }

  target_size = 3
}