#Setting project variable
variable "project_name" {
  default = "movie-a1-terraform1111"
}

variable "credentials" {
  default = "/home/cassius/Downloads/terraformCredentials/movie-a1-terraform1111-6c324e632b85.json"
}

variable "network_name" {
  default = "vpc-movie-a1-1"
}
# Defining CIDR Block for 1st Subnet
variable "subnet-a1-1_cidr" {
  default = "10.0.0.0/24"
}

variable "disk-a1-1-size" {
  default = 10
}

variable "subnet-a1-2_cidr-back" {
  default = "10.0.1.0/24"
}

variable "disk-a1-1-size-back" {
  default = 10
}

variable "subnet-a1-2_cidr-db" {
  default = "10.0.2.0/24"
}