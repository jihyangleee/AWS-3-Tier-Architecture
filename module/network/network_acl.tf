# Network ACL for Private Subnets (Application Tier)
resource "aws_network_acl" "private_nacl" {
    vpc_id     = aws_vpc.vpc.id
    subnet_ids = aws_subnet.private_subnets_application.*.id

    # Inbound: Allow HTTP from ALB
    ingress {
        protocol   = "tcp"
        rule_no    = 100
        action     = "allow"
        cidr_block = var.vpc_cidr_block
        from_port  = 80
        to_port    = 80
    }

    # Inbound: Allow SSH from Bastion
    ingress {
        protocol   = "tcp"
        rule_no    = 110
        action     = "allow"
        cidr_block = var.vpc_cidr_block
        from_port  = 22
        to_port    = 22
    }

    # Inbound: Allow ephemeral ports (return traffic)
    ingress {
        protocol   = "tcp"
        rule_no    = 120
        action     = "allow"
        cidr_block = var.entire_cidr_block
        from_port  = 1024
        to_port    = 65535
    }

    # Outbound: Allow all traffic
    egress {
        protocol   = "-1"
        rule_no    = 100
        action     = "allow"
        cidr_block = var.entire_cidr_block
        from_port  = 0
        to_port    = 0
    }

    tags = merge(
        var.tags,
        {
            "name" = "${var.environment}-private-nacl"
        }
    )
}
