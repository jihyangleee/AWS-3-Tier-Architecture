variable "security_group_ids" {}
variable "subnet_ids" {}
variable "database_password" {}

variable "tags" {
    default ={ 
        method = "terraform"
    }
}

variable "environment" {}
