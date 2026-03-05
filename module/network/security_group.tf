resource "aws_security_group" "bastion_security_group"{
    name= "ec2_bastion_security_group"
    vpc_id= aws_vpc.vpc.id


    ingress {
        from_port =  22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.access_ip]
    }

    egress{
        from_port = 0
        to_port = 0
        protocol="-1"
        cidr_blocks = [var.entire_cidr_block]
    }
}

resource "aws_security_group" "lb_security_group"{
    name = "alb_security_group"
    vpc_id = aws_vpc.vpc.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [var.entire_cidr_block]
    }

    ingress{
        from_port = 443
        to_port =443
        protocol = "tcp"
        cidr_blocks = [var.entire_cidr_block]
    }

    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [var.entire_cidr_block]
    }

}


resource "aws_security_group" "application_security_group" {
  name   = "ec2_application_security_group"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_security_group.id]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.entire_cidr_block]
  }
}

resource "aws_security_group" "rds_security_group" {
  name   = "rds_security_group"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.application_security_group.id, aws_security_group.bastion_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.entire_cidr_block]
  }
}