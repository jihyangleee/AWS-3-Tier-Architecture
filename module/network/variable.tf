variable "vpc_cidr_block"{
    default = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  default = "10.0.x.0/24"
}

variable "entire_cidr_block" {
  default = "0.0.0.0/0"
}

variable "public_subnet_count"{
    default = 2
}

variable "private_subnet_application_count" {
  default = 2
}

variable "private_subnet_data_count" {
  default = 2
}

variable "access_ip" {
    default=  "0.0.0.0/0"
}

variable "tags"{
    default = {
        method="terraform"
    }
}

variable "environment" {}
