resource "google_compute_region_instance_group_manager" "front-igm-p2" {
  name = "todolist-front-igm"
  depends_on = [ google_compute_address.back-ip-p2 ]

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
  depends_on = [ data.google_compute_region_instance_group.dbs-ig ]

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

data "google_compute_region_instance_group" "dbs-ig" {
  depends_on = [ google_compute_region_instance_group_manager.database-igm-p2 ]
  self_link = google_compute_region_instance_group_manager.database-igm-p2.instance_group
}

output "test-instances" {
  depends_on = [ data.google_compute_region_instance_group.dbs-ig ]
  value = data.google_compute_region_instance_group.dbs-ig.instances.*
}

data "google_compute_instance" "dbs" {
  depends_on = [ data.google_compute_region_instance_group.dbs-ig, google_compute_region_instance_group_manager.database-igm-p2 ]
  for_each = toset(data.google_compute_region_instance_group.dbs-ig.instances.*.instance)
  self_link = each.key
}

# output "db-ips" {
#   depends_on = [ data.google_compute_instance.db-list ]
#   value = join(",", [ for db in data.google_compute_instance.db-list: join(":", [db.network_interface.0.network_ip, "27017"]) ])
# }