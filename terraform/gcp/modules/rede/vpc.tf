resource "google_compute_network" "main" {
  name                    = "fiap-vpc-rm562093"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "main" {
  name          = "fiap-subnet-rm562093"
  region        = var.regiao
  ip_cidr_range = var.rede_cidr
  network       = google_compute_network.main.id
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "fiap-allow-ssh-rm562093"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_http" {
  name    = "fiap-allow-http-rm562093"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_icmp" {
  name    = "fiap-allow-icmp-rm562093"
  network = google_compute_network.main.name

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_wireguard" {
  name    = "fiap-allow-wg-rm562093"
  network = google_compute_network.main.name

  allow {
    protocol = "udp"
    ports    = ["51820"]
  }

  source_ranges = ["0.0.0.0/0"]
}
