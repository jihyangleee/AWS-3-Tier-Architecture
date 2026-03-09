# RDS MySQL Instance
resource "aws_db_instance" "rds_mysql" {
    identifier             = "${var.environment}-rds-mysql"
    engine                 = "mysql"
    engine_version         = "8.0"
    instance_class         = local.database_instance_class
    allocated_storage      = 20
    storage_type           = "gp2"
    
    db_name                = "appdb"
    username               = "admin"
    password               = var.database_password
    
    db_subnet_group_name   = aws_db_subnet_group.private_db_subnet_group.name
    vpc_security_group_ids = var.security_group_ids
    
    multi_az               = false
    publicly_accessible    = false
    skip_final_snapshot    = true

    tags = merge(
        var.tags,
        {
            "name" = "${var.environment}-rds-mysql"
        }
    )
}
