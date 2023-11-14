terraform {
  backend "gcs" {
    bucket = "tfstate-p2"
    prefix = "terraform/state"
    credentials = "credentials.json"
  }
}