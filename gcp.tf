# project a
provider "google" {
  credentials = file("learn-terraform-280319-5a33b9c3f558.json")
  project = "learn-terraform-280319"
  region  = "us-west1"
  zone    = "us-west1-b"
}
resource "google_compute_instance" "vm_instance_projec_a" {
  name         = "project-a"
  machine_type = "f1-micro"
  tags = ["http-server", "https-server", "docker-api"]

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-lts"
    }
  }

  network_interface {
    network = google_compute_network.network_project_a.id
    subnetwork = google_compute_subnetwork.subnetwork_internal_project_a.id
    # network = "default"
    access_config {
    }
  }
}
resource "google_compute_network" "network_project_a" {
  name = "network-project-a"
  auto_create_subnetworks = "false"
  routing_mode = "REGIONAL"
}
resource "google_compute_subnetwork" "subnetwork_internal_project_a" {
  name          = "subnetwork-project-a"
  region        = "us-west1"
  ip_cidr_range = "10.0.1.0/28"
  private_ip_google_access = "true"
  network       = google_compute_network.network_project_a.id
}
resource "google_compute_network_peering" "peering1" {
  name         = "peering1"
  network      = google_compute_network.network_project_a.id
  peer_network = google_compute_network.network_project_b.id
}
resource "google_compute_firewall" "allow_ssh_firewall_project_a" {
  name    = "allow-ssh-project-a"
  network = google_compute_network.network_project_a.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  direction = "INGRESS"
}
resource "google_compute_firewall" "allow_icmp_firewall_project_a" {
  name    = "allow-icmp-project-a"
  network = google_compute_network.network_project_a.id
  
  allow {
    protocol = "icmp"
  }
  direction = "INGRESS"
}

resource "google_compute_firewall" "allow_http_firewall_project_a" {
  name    = "allow-http-project-a"
  network = google_compute_network.network_project_a.id
  
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  direction = "INGRESS"
  target_tags = ["http-server"]
}
resource "google_compute_firewall" "allow_https_firewall_project_a" {
  name    = "allow-https-project-a"
  network = google_compute_network.network_project_a.id
  
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  direction = "INGRESS"
  target_tags = ["https-server"]
}
resource "google_compute_firewall" "allow_docker_api_firewall_project_a" {
  name    = "allow-docker-tcp-project-a"
  network = google_compute_network.network_project_a.id
  
  allow {
    protocol = "tcp"
    ports    = ["2376"]
  }
  direction = "INGRESS"
  target_tags = ["docker-api"]
}



# project b
provider "google" {
  credentials = file("project-2-280200-d268b006b0a4.json")
  alias = "projectb"
  project = "project-2-280200"
  region  = "us-west1"
  zone    = "us-west1-b"
}
resource "google_compute_instance" "vm_instance_projec_b" {
  name         = "project-b"
  machine_type = "f1-micro"
  tags = ["http-server", "https-server", "docker-api"]
  provider = google.projectb

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-lts"
    }
  }

  network_interface {
    network = google_compute_network.network_project_b.id
    subnetwork = google_compute_subnetwork.subnetwork_internal_project_b.id
    access_config {
    }
  }
}

resource "google_compute_network" "network_project_b" {
  provider = google.projectb
  auto_create_subnetworks = "false"
  name = "network-project-b"
  project = "project-2-280200"
}
resource "google_compute_subnetwork" "subnetwork_internal_project_b" {
  provider = google.projectb
  name          = "subnetwork-project-b"
  region        = "us-west1"
  ip_cidr_range = "10.8.2.0/24"
  private_ip_google_access = "true"
  network       = google_compute_network.network_project_b.id
}
resource "google_compute_network_peering" "peering2" {
  name         = "peering2"
  provider = google.projectb
  network      = google_compute_network.network_project_b.id
  peer_network = google_compute_network.network_project_a.id
}
resource "google_compute_firewall" "allow_ssh_firewall_project_b" {
  provider = google.projectb
  name    = "allow-ssh-project-b"
  network = google_compute_network.network_project_b.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  direction = "INGRESS"
}
resource "google_compute_firewall" "allow_icmp_firewall_project_b" {
  provider = google.projectb
  name    = "allow-icmp-project-b"
  network = google_compute_network.network_project_b.id
  
  allow {
    protocol = "icmp"
  }
  direction = "INGRESS"
}

resource "google_compute_firewall" "allow_http_firewall_project_b" {
  provider = google.projectb
  name    = "allow-http-project-b"
  network = google_compute_network.network_project_b.id
  
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  direction = "INGRESS"
  target_tags = ["http-server"]
}
resource "google_compute_firewall" "allow_https_firewall_project_b" {
  provider = google.projectb
  name    = "allow-https-project-b"
  network = google_compute_network.network_project_b.id
  
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  direction = "INGRESS"
  target_tags = ["https-server"]
}
resource "google_compute_firewall" "allow_docker_api_firewall_project_b" {
  provider = google.projectb
  name    = "allow-docker-tcp-project-b"
  network = google_compute_network.network_project_b.id
  
  allow {
    protocol = "tcp"
    ports    = ["2376"]
  }
  direction = "INGRESS"
  target_tags = ["docker-api"]
}