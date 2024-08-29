resource "google_compute_network" "vpc" {
  name                    = "hackathon-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet1" {
  name          = "subnet1"
  ip_cidr_range  = var.subnet1_cidr
  network        = google_compute_network.vpc.self_link
  region         = var.region
}

resource "google_compute_subnetwork" "subnet2" {
  name          = "subnet2"
  ip_cidr_range  = var.subnet2_cidr
  network        = google_compute_network.vpc.self_link
  region         = "us-east1"
}

resource "google_compute_instance" "vm_instance_01" {
  name         = "vm-instance-01"
  machine_type = var.instance_types["vm-instance-01"]
  zone         = var.zone
  tags         = ["web"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10-buster-v20210701"
    }
  }

  network_interface {
    network    = google_compute_network.vpc.self_link
    subnetwork = google_compute_subnetwork.subnet1.self_link
    access_config {
    }
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    systemctl start apache2
    systemctl enable apache2
  EOF
}

resource "google_compute_instance" "vm_instance_02" {
  name         = "vm-instance-02"
  machine_type = var.instance_types["vm-instance-02"]
  zone         = "us-east1-b"
  tags         = ["web"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10-buster-v20210701"
    }
  }

  network_interface {
    network    = google_compute_network.vpc.self_link
    subnetwork = google_compute_subnetwork.subnet2.self_link
    access_config {
    }
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    systemctl start apache2
    systemctl enable apache2
  EOF
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.vpc.self_link

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags = ["web"]
}

resource "google_compute_health_check" "http_health_check" {
  name = "http-health-check"

  http_health_check {
    port = 80
    request_path = "/"
  }

  check_interval_sec = 10
  timeout_sec         = 10
  healthy_threshold   = 2
  unhealthy_threshold = 2
}

resource "google_compute_backend_service" "backend_service" {
  name = "backend-service"

  backend {
    group = google_compute_instance_group.vm_group.self_link
  }

  health_checks = [google_compute_health_check.http_health_check.self_link]
}

resource "google_compute_instance_group" "vm_group" {
  name        = "vm-group"
  zone        = var.zone
  instances   = [
    google_compute_instance.vm_instance_01.self_link,
    google_compute_instance.vm_instance_02.self_link,
  ]
}

resource "google_compute_global_forwarding_rule" "http_rule" {
  name       = "http-forwarding-rule"
  target     = google_compute_backend_service.backend_service.self_link
  port_range  = "80"
}

resource "google_compute_url_map" "url_map" {
  name = "url-map"

  default_service = google_compute_backend_service.backend_service.self_link
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "http-proxy"
  url_map = google_compute_url_map.url_map.self_link
}

resource "google_compute_global_forwarding_rule" "http_forwarding_rule" {
  name    = "http-forwarding-rule"
  target  = google_compute_target_http_proxy.http_proxy.self_link
  port_range = "80"
}
