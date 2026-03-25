variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "pool_id" {
  description = "Workload Identity Pool ID"
  type        = string
  default     = "github-pool"
}

variable "provider_id" {
  description = "Workload Identity Pool provider ID"
  type        = string
  default     = "github-provider"
}

variable "service_account_id" {
  description = "Service account ID used by GitHub Actions"
  type        = string
  default     = "github-deployer"
}

variable "service_account_display_name" {
  description = "Display name for the GitHub Actions service account"
  type        = string
  default     = "GitHub Actions Deployer"
}

variable "github_repository" {
  description = "GitHub repository allowed to federate, in owner/repo format"
  type        = string
}

variable "github_branch" {
  description = "Git branch allowed to impersonate the service account"
  type        = string
  default     = "main"
}

variable "grant_service_account_token_creator" {
  description = "Grant roles/iam.serviceAccountTokenCreator to the federated principal set"
  type        = bool
  default     = false
}

variable "service_account_roles" {
  description = "Project roles granted to the service account after federation succeeds"
  type        = list(string)
  default     = ["roles/viewer"]
}
