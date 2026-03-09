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
    source = "../module/application"
    vpc_id = module.network.vpc_id
    public_subnet_ids = module.network.public_subnets_ids
    private_subnet_ids = module.network.private_subnets_application_ids
    application_security_group_ids = module.network.application_security_group_ids
    bastion_security_group_ids = module.network.bastion_security_group_ids
    lb_security_group_ids = module.network.lb_security_group_ids
    environment = var.environment
}

