module "network"{
    source = "../module/network"
    environment = var.environment
}

module "data" {
    source ="../module/data"
    security_group_ids =module.network.rds_security_group_ids
    subnet_ids = module.network.private_subnets_data_ids
    database_password = var.database_password
    environment = var.environment
}

module "application" {
    source ="../module/container"
    subnet_ids= module.network.private_subnets_application_ids
    vpc_id = module.network.vpc_id
    environment = var.environment
}

