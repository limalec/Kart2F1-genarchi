data "template_file" "startup_script_mongodb_server" {
  template = "${file("../todolist/database/gcp_start.sh")}"
  vars = {
    project = "gen-archi"
    cluster_name = "todolist-database-p2"
    replicaset_name = "rs1"
  }
}