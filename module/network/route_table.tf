#public route table
resource "aws_route_table" "public_route_table"{
    vpc_id= aws_vpc.vpc.id

    tags = merge(
        var.tags,
        {
            "name" = "${var.environment}-route-table-public"
        }
    )
}

resource "aws_route" "public_route"{
    route_table_id= aws_route_table.public_route_table.id
    destination_cidr_block = var.entire_cidr_block
    gateway_id= aws_internet_gateway.internet_gateway.id
}

resource "aws_route_table_association" "public_route_table_associations"{
    count = var.public_subnet_count
    subnet_id = aws_subnet.public_subnets.*.id[count.index]
    route_table_id = aws_route_table.public_route_table.id
}
# private route table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.tags,
    {
      "name" = "${var.environment}-route-table-private"
    }
  )
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = var.entire_cidr_block
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}

resource "aws_route_table_association" "private_route_table_associations" {
  count          = var.private_subnet_application_count
  subnet_id      = aws_subnet.private_subnets_application.*.id[count.index]
  route_table_id = aws_route_table.private_route_table.id
}