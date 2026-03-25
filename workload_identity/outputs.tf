output "service_account_email" {
  description = "Email of the service account used by GitHub Actions"
  value       = google_service_account.github_actions.email
}

output "workload_identity_pool_name" {
  description = "Full resource name of the Workload Identity Pool"
  value       = google_iam_workload_identity_pool.github.name
}

output "workload_identity_provider_name" {
  description = "Full resource name of the Workload Identity Provider"
  value       = google_iam_workload_identity_pool_provider.github.name
}

output "principal_set_member" {
  description = "Principal set granted impersonation on the service account"
  value       = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository/${var.github_repository}"
}
