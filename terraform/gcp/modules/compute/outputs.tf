output "public_ip" {
  description = "IP público da VM GCP"
  value       = google_compute_instance.main.network_interface[0].access_config[0].nat_ip
}

output "private_ip" {
  description = "IP privado da VM GCP"
  value       = google_compute_instance.main.network_interface[0].network_ip
}

output "instance_name" {
  description = "Nome da instância GCP"
  value       = google_compute_instance.main.name
}
