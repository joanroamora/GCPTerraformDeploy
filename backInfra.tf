 
resource "google_compute_subnetwork" "subnet-movie-a1-1-back" {
  name                  = "subnet-movie-a1-1-back"
  ip_cidr_range         = "${var.subnet-a1-2_cidr-back}"
  region                = "us-central1"
  private_ip_google_access = true
  stack_type            = "IPV4_ONLY"
  network               = var.network_name
  project                 = var.project_name
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
}

resource "google_compute_instance" "default-back" {
  name         = "vm-movie-a1-1-back"
  machine_type = "e2-standard-2"
  zone         = "us-central1-a"
  project      = var.project_name

  metadata = {
    startup-script        = "${file("./files/startup-script-back")}"
  }

  boot_disk {
    initialize_params {
      image     = "debian-cloud/debian-11"
      size      = "${var.disk-a1-1-size-back}"
      labels    = {
        my_label = "value"
      }
    }
  }

  tags = [
    #google_compute_firewall.movie-front-firewall.self_link
    #"movie-a1-terraform111-movie-back-firewall"
    #google_compute_firewall.movie-back-firewall.self_link
    "movie-a1-terraform111-movie-back-firewall"
  ]

  network_interface {
    network = google_compute_network.vpc-movie-a1-1.self_link
    subnetwork = google_compute_subnetwork.subnet-movie-a1-1-back.self_link
  }

}