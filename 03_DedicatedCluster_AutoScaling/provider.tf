terraform {
  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "2.11.0"
    }
  }
}

provider "mongodbatlas" {
  client_id     = var.mongodbatlas_client_id
  client_secret = var.mongodbatlas_client_secret
}