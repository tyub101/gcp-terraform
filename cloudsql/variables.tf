variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "Region for the Cloud SQL instance"
  type        = string
  default     = "us-west1"
}

variable "database_version" {
  description = "Cloud SQL database engine version"
  type        = string
  default     = "MYSQL_8_0"
}

variable "instance_name" {
  description = "Cloud SQL instance name"
  type        = string
  default     = "cloudsql-demo-instance"
}

variable "database_name" {
  description = "Initial database name"
  type        = string
  default     = "appdb"
}

variable "db_tier" {
  description = "Machine tier for the Cloud SQL instance"
  type        = string
  default     = "db-f1-micro"
}

variable "db_user_name" {
  description = "Application database username"
  type        = string
  default     = "appuser"
}

variable "db_user_password" {
  description = "Application database password"
  type        = string
  sensitive   = true
}
