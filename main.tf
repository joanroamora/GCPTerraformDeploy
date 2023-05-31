provider "google" {
  region      = "us-central1"
  zone                  = "us-central1-a"
}

resource "google_compute_network" "vpc-movie-a1-1" {
  project                 = "movie-a1-terraform111"
  name                    = "vpc-movie-a1-1"
  auto_create_subnetworks = false
  
}
 
resource "google_compute_subnetwork" "subnet-movie-a1-1" {
  name                  = "subnet-movie-a1-1"
  ip_cidr_range         = "${var.subnet-a1-1_cidr}"
  region                = "us-central1"
  #zone                  = "us-central1-a"
  private_ip_google_access = true
  stack_type            = "IPV4_ONLY"
  network               = google_compute_network.vpc-movie-a1-1.name
  project                 = "movie-a1-terraform111"
  
}

resource "google_compute_firewall" "movie-front-firewall" {
  name                    = "movie-front-firewall"
  network                 = google_compute_network.vpc-movie-a1-1.name
  project                 = "movie-a1-terraform111"

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
}

resource "google_compute_instance" "default" {
  name         = "vm-movie-a1-1"
  machine_type = "e2-standard-2"
  zone         = "us-central1-a"
  project      = "movie-a1-terraform111"

  metadata_startup_script = "${file("./files/startup-script")}"

  boot_disk {
    initialize_params {
      image     = "debian-cloud/debian-11"
      size      = "${var.disk-a1-1-size}"
      labels    = {
        my_label = "value"
      }
    }
  }

  tags = [
    #google_compute_firewall.movie-front-firewall.self_link
    "movie-a1-terraform111-movie-front-firewall"
  ]

  network_interface {
    network = google_compute_network.vpc-movie-a1-1.self_link
    subnetwork = google_compute_subnetwork.subnet-movie-a1-1.self_link
    access_config {
      // Ephemeral public IP
    }
  }

}