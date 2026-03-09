resource "aws_vpc" "vpc" {
    cidr_block           = var.vpc_cidr_block
    enable_dns_hostnames = true
    enable_dns_support   = true

    tags = merge(
        var.tags,
        {
            "name" = "${var.environment}-vpc"
        }
    )
}
