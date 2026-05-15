variable "mongodbatlas_client_id" {
  type = string
}

variable "mongodbatlas_client_secret" {
  type      = string
  sensitive = true
}

variable "org_id" {
  description = "MongoDB Atlas Organization ID"
  type        = string
}


variable "project_name" {
  description = "Enter your MongoDB Atlas Project Name"
  type        = string
}

variable "cluster_name" {
  default = "M0-Cluster-MUG"
}

variable "instance_size" {
  default = "M10" # Free tier instance
}

variable "db_username" {
  default = "appuser"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "db_name" {
  default = "demo-db"
}

variable "ip_address" {
  description = "Your IP in CIDR format (e.g., 0.0.0.0/0 for demo)"
  default     = "0.0.0.0/0"
}