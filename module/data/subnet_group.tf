resource "aws_db_subnet_group" "private_db_subnet_group" {
    name ="private-db-subnet-group"
    subnet_ids = var.subnet_ids

    tags = merge(
        var.tags,
        {
            "name" = "${var.environment}-db-subnet-group"
        }
    )
}