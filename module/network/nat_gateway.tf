# NAT Gateway 1 (AZ 1)
resource "aws_eip" "nat_eip_1" {
    domain = "vpc"

    lifecycle {
        create_before_destroy = true
    }

    tags = merge(
        var.tags,
        {
            "name" = "${var.environment}-nat-eip-1"
        }
    )
}

resource "aws_nat_gateway" "nat_gateway_1" {
    allocation_id = aws_eip.nat_eip_1.id
    subnet_id     = aws_subnet.public_subnets[0].id

    lifecycle {
        create_before_destroy = true
    }

    tags = merge(
        var.tags,
        {
            "name" = "${var.environment}-nat-gateway-1"
        }
    )
}

# NAT Gateway 2 (AZ 2)
resource "aws_eip" "nat_eip_2" {
    domain = "vpc"

    lifecycle {
        create_before_destroy = true
    }

    tags = merge(
        var.tags,
        {
            "name" = "${var.environment}-nat-eip-2"
        }
    )
}

resource "aws_nat_gateway" "nat_gateway_2" {
    allocation_id = aws_eip.nat_eip_2.id
    subnet_id     = aws_subnet.public_subnets[1].id

    lifecycle {
        create_before_destroy = true
    }

    tags = merge(
        var.tags,
        {
            "name" = "${var.environment}-nat-gateway-2"
        }
    )
}