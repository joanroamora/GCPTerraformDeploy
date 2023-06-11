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

resource "google_compute_instance" "default" {
  name         = "vm-movie-a1-1"
  machine_type = "e2-standard-2"
  zone         = "us-central1-a"
  project      = var.project_name
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

resource "google_compute_instance" "default-db" {
  name         = "vm-movie-a1-1-db"
  machine_type = "e2-standard-2"
  zone         = "us-central1-a"
  project      = var.project_name

  metadata = {
    startup-script        = "${file("./files/startup-script-db")}"
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
    "movie-a1-terraform111-movie-db-firewall"
  ]

  network_interface {
    network = google_compute_network.vpc-movie-a1-1.self_link
    subnetwork = google_compute_subnetwork.subnet-movie-a1-1-db.self_link
    access_config {
      // Ephemeral public IP
    }
  }
/* 
  provisioner "file" {
  source      = "/home/cassius/Desktop/REPOSITORIOS LOCALES/PORTFOLIO/3.GCPTerraformDeploy/codigo/files"
    destination = "/boot"

  connection {
    type     = "ssh"
    user     = "root"
    password = ""
    host     = "vm-movie-a1-1-db"
  }
 } */
}