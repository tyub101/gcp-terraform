output "load_balancer_ip" {
  description = "Global IP address of the HTTP load balancer"
  value       = google_compute_global_address.default.address
}
