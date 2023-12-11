resource "google_compute_region_instance_template" "todolist-front-template" {
  name_prefix = "todolist-front-p2"
  description = "Template for the instance group of the front in platform 2"
  machine_type = "e2-small"
  tags = ["platform2"]
  can_ip_forward = false

  disk {
    disk_type = "pd-ssd"
    source_image = "debian-12"
    auto_delete = true
    boot = true
    disk_size_gb = 20
    type = "PERSISTENT"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  network_interface {
    network = "default" #google_compute_network.vpc_network.name
    access_config {
      #nat_ip = google_compute_address.static.address
    }
  }
  
  service_account {
    email = "read-storage-p2@gen-archi.iam.gserviceaccount.com"
    scopes = [ "cloud-platform" ]
  }

  metadata = {
    startup-script = "${data.template_file.startup_script_frontend.rendered}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_instance_template" "todolist-back-template" {
  name_prefix = "todolist-back-p2"
  description = "Template for the instance group of the back in platform 2"
  machine_type = "e2-small"
  tags = ["platform2"]
  can_ip_forward = false
  depends_on = [ data.google_compute_region_instance_group.dbs-ig ]

  disk {
    disk_type = "pd-ssd"
    source_image = "debian-12"
    auto_delete = true
    boot = true
    disk_size_gb = 20
    type = "PERSISTENT"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  network_interface {
    network = "default" #google_compute_network.vpc_network.name
    access_config {
      #nat_ip = google_compute_address.static.address
    }
  }

  metadata = {
    startup-script = "${data.template_file.startup_script_backend.rendered}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_instance_template" "todolist-database-template" {
  name_prefix = "todolist-db-p2"
  description = "Template for the instance group of the DB in platform 2"
  machine_type = "e2-small"
  tags = [ "platform2" ]
  #can_ip_forward = false

  disk {
    disk_type = "pd-ssd"
    source_image = "debian-11"
    auto_delete = true
    boot = true
    disk_size_gb = 20
    type = "PERSISTENT"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    startup-script = "${data.template_file.startup_script_mongodb_server.rendered}"
  }

  lifecycle {
    create_before_destroy = true
  }

  service_account {
    email = "database-p2@gen-archi.iam.gserviceaccount.com"
    scopes = [ "cloud-platform" ]
  }
}
