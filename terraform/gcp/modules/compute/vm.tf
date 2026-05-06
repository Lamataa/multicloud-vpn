resource "google_compute_instance" "main" {
  name         = "fiap-vm-rm562093"
  machine_type = var.tipo_maquina
  zone         = var.zona

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    subnetwork = var.subnet_id

    access_config {}
  }

  metadata = {
    ssh-keys = "${var.usuario_ssh}:${var.ssh_public_key}"
  }

  metadata_startup_script = file("${path.module}/cloud_init.sh")
}
