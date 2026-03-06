variable "database_password" {}

variable "tags" {
    default = {
        method = "terraform"
    }
}

variable "environment" {
    default = "develop"
}

