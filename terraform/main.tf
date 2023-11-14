terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.2.0"
    }
  }
}

provider "google" {
  credentials = file("credentials.json")

  project = "gen-archi"
  region = "europe-west9"
  zone = "europe-west9-c"
}