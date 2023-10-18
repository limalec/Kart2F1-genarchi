terraform {
  backend "gcs" {
    bucket = "781228c9e0cff8aa-bucket-tfstate"
    prefix = "terraform/state"
    credentials = "credentials.json"
  }
}