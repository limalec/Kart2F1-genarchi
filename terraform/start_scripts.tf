data "template_file" "startup_script_mongodb_server" {
  template = "${file("../todolist/database/gcp_start.sh")}"
  vars = {
    project = "gen-archi"
    cluster_name = "todolist-database-p2"
    replicaset_name = "rs1"
  }
}

data "template_file" "startup_script_backend" {
  template = "${file("../todolist/backend/gcp_start.sh")}"
  # vars = {
  #   db-ips = ""
  # }
  vars = {
    db-ips = join(",", [ for db in data.google_compute_instance.dbs : join(":", [db.network_interface.0.network_ip, "27017"]) ])
  }
}

data "template_file" "startup_script_frontend" {
  template = "${file("../todolist/frontend/gcp_start.sh")}"
  vars = {
    back-ip = google_compute_address.back-ip-p2.address
  }
}

output "file" {
  value = data.template_file.startup_script_backend.rendered
}