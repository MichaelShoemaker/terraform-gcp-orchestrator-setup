locals {
  vm_name = "orchestrator-${var.orchestrator}"
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_compute_instance" "vm" {
  name         = locals.vm_name
  machine_type = var.vm_machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = var.vm_disk_size_gb
    }
  }

  network_interface {
    network       = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "gary:${file("~/.ssh/gcp.pub")}"

    user-data = templatefile("${path.module}/user-data.yaml", {
      orchestrator = var.orchestrator
    })
  }
}
