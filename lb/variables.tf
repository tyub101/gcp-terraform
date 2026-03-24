variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "Primary region for regional resources"
  type        = string
  default     = "us-west1"
}

variable "zone" {
  description = "Zone for the demo backend VM"
  type        = string
  default     = "us-west1-a"
}
