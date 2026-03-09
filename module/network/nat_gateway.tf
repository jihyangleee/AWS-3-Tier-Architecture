# NAT Gateway (Public Subnet 2)
resource "aws_eip" "nat_eip" {
    domain = "vpc"

    lifecycle {
        create_before_destroy = true
    }

    tags = merge(
        var.tags,
        {
            "name" = "${var.environment}-nat-eip"
        }
    )
}

resource "aws_nat_gateway" "nat_gateway" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id     = aws_subnet.public_subnets[1].id

    lifecycle {
        create_before_destroy = true
    }

    tags = merge(
        var.tags,
        {
            "name" = "${var.environment}-nat-gateway"
        }
    )
}