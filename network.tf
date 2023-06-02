provider "google" {
  region      = "us-central1"
  zone                  = "us-central1-a"
}

resource "google_compute_network" "vpc-movie-a1-1" {
  project                 = var.project_name
  name                    = "vpc-movie-a1-1"
  auto_create_subnetworks = false
  
}

resource "google_compute_subnetwork" "subnet-movie-a1-1-back" {
  name                  = "subnet-movie-a1-1-back"
  ip_cidr_range         = "${var.subnet-a1-2_cidr-back}"
  region                = "us-central1"
  private_ip_google_access = true
  stack_type            = "IPV4_ONLY"
  network               = var.network_name
  project                 = var.project_name

  depends_on = [
    google_compute_network.vpc-movie-a1-1
  ]
}

resource "google_compute_subnetwork" "subnet-movie-a1-1" {
  name                  = "subnet-movie-a1-1"
  ip_cidr_range         = "${var.subnet-a1-1_cidr}"
  region                = "us-central1"
  private_ip_google_access = true
  stack_type            = "IPV4_ONLY"
  network               = var.network_name
  project                 = var.project_name

  depends_on = [
    google_compute_network.vpc-movie-a1-1
  ]
}

resource "google_compute_subnetwork" "subnet-movie-a1-1-db" {
  name                  = "subnet-movie-a1-1-db"
  ip_cidr_range         = "${var.subnet-a1-2_cidr-db}"
  region                = "us-central1"
  private_ip_google_access = true
  stack_type            = "IPV4_ONLY"
  network               = var.network_name
  project                 = var.project_name

  depends_on = [
    google_compute_network.vpc-movie-a1-1
  ]
}

resource "google_compute_firewall" "movie-back-firewall" {
  name                    = "movie-back-firewall"
  network                 = var.network_name
  project                 = var.project_name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "3030", "3000","3306"]
  }

  source_tags = ["web"]
  source_ranges = ["0.0.0.0/0"]

  target_tags   = ["movie-a1-terraform111-movie-back-firewall"]

  depends_on = [
    google_compute_network.vpc-movie-a1-1
  ]
}

resource "google_compute_firewall" "movie-front-firewall" {
  name                    = "movie-front-firewall"
  network                 = var.network_name
  project                 = var.project_name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "22", "3030", "3000", "1000-2000"]
  }

  source_tags = ["web"]
  source_ranges = ["0.0.0.0/0"]

  target_tags   = ["movie-a1-terraform111-movie-front-firewall"]

  depends_on = [
    google_compute_network.vpc-movie-a1-1
  ]
}

resource "google_compute_firewall" "movie-db-firewall" {
  name                    = "movie-db-firewall"
  network                 = var.network_name
  project                 = var.project_name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "3030", "3000","3306"]
  }

  source_tags = ["web"]
  source_ranges = ["0.0.0.0/0"]

  target_tags   = ["movie-a1-terraform111-movie-db-firewall"]

  depends_on = [
    google_compute_network.vpc-movie-a1-1
  ]
}

 ## Create Cloud Router

resource "google_compute_router" "movie-router-1" {
  project = var.project_name
  name    = "movie-router-1"
  network = var.network_name
  region  = "us-central1"

  depends_on = [
    google_compute_network.vpc-movie-a1-1
  ]
}

## Create Nat Gateway

resource "google_compute_router_nat" "movie-nat-1" {
  project                            = var.project_name
  name                               = "my-router-nat"
  router                             = google_compute_router.movie-router-1.name
  region                             = "us-central1"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }

  depends_on = [
    google_compute_network.vpc-movie-a1-1
  ]
}