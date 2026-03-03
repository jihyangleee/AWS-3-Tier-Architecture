variable "vpc_id" {}
variable "subnet_ids" {}

variable "tags" {
    default = {
        method= "terraform"
    }
}

variable "environment" {}

