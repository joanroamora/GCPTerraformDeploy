# Defining CIDR Block for 1st Subnet
variable "subnet-a1-1_cidr" {
  default = "10.0.0.0/24"
}

variable "disk-a1-1-size" {
  default = 10
}

# variable "subnet-movie-a1-1-subnet" {
#   default = 10
# }

variable "subnet-a1-2_cidr-back" {
  default = "10.0.1.0/24"
}

variable "disk-a1-1-size-back" {
  default = 10
}