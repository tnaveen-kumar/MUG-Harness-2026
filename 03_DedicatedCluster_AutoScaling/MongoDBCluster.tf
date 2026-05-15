resource "mongodbatlas_project" "project" {
  name   = var.project_name
  org_id = var.org_id
}


resource "mongodbatlas_advanced_cluster" "cluster" {
  project_id             = mongodbatlas_project.project.id
  name                   = var.cluster_name
  cluster_type           = "REPLICASET"
  mongo_db_major_version = "7.0"
    replication_specs = [
    {
      region_configs = [
        {
          provider_name = "AWS"
          region_name   = "AP_SOUTH_1"
          priority      = 7

          electable_specs = {
            instance_size = "M10"
            node_count    = 3
          }

          auto_scaling = {
            compute_enabled            = true
            compute_scale_down_enabled = true
            compute_min_instance_size  = "M10"
            compute_max_instance_size  = "M20"
          }
        }
      ]
    }
  ]
}


resource "mongodbatlas_database_user" "db_user" {
  username           = var.db_username
  password           = var.db_password
  project_id         = mongodbatlas_project.project.id
  auth_database_name = "admin"

  roles {
    role_name     = "readWrite"
    database_name = var.db_name
  }
}


resource "mongodbatlas_project_ip_access_list" "ip_access" {
  project_id = mongodbatlas_project.project.id
  cidr_block = var.ip_address
  comment    = "Allow access from office/home"
}