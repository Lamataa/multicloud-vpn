output "subnet_id" {
  description = "Self-link da subnet GCP"
  value       = google_compute_subnetwork.main.self_link
}

output "network_name" {
  description = "Self-link da rede GCP"
  value       = google_compute_network.main.self_link
}
