variable "vpc_id" {}
variable "public_subnet_ids" {}
variable "private_subnet_ids" {}

variable "bastion_security_group_ids"{}
variable "lb_security_group_ids" {}
variable "application_security_group_ids" {}

variable "tags" {
    default = {
        method="terraform"
    }
}

variable "environment" {}
