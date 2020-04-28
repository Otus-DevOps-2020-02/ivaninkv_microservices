terraform {
  required_version = "~> 0.12"
}

provider "google" {
  version = "~> 2.15"

  project = var.project
  region  = var.region
}

resource "google_compute_instance" "app" {
  count        = var.instances_qty
  name         = "docker-host${count.index + 1}"
  machine_type = "n1-standard-1"
  zone         = var.zone
  tags         = ["docker-machine"]
  boot_disk {
    initialize_params {
      image = var.disk_image
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

  connection {
    type  = "ssh"
    host  = self.network_interface[0].access_config[0].nat_ip
    user  = "appuser"
    agent = false
    private_key = file(var.private_key)
  }
}

resource "google_compute_firewall" "firewall_docker" {
  name = "docker-machines-rule"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["2376", "9292"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["reddit-machine"]
}
