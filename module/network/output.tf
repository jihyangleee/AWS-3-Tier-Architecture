output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnets_ids" {
  value = aws_subnet.public_subnets.*.id
}
output "private_subnets_application_ids" {
  value = aws_subnet.private_subnets_application.*.id
}
output "private_subnets_data_ids" {
  value = aws_subnet.private_subnets_data.*.id
}

output "bastion_security_group_ids" {
  value = aws_security_group.bastion_security_group.*.id
}
output "lb_security_group_ids" {
  value = aws_security_group.lb_security_group.*.id
}
output "application_security_group_ids" {
  value = aws_security_group.application_security_group.*.id
}
output "rds_security_group_ids" {
  value = aws_security_group.rds_security_group.*.id
}