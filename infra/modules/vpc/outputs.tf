output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.devsu_vpc.id
}

output "public_subnet_ids" {
  description = "The list of IDs for public subnets A and B"
  value       = [
    aws_subnet.public_subnet_a.id,
    aws_subnet.public_subnet_b.id
  ]
}

output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = aws_subnet.private_subnet.id
}

output "nat_gateway_ids" {
  description = "The list of NAT Gateway IDs for public subnet A and B"
  value       = [
    aws_nat_gateway.devsu_nat_gateway_a.id,
    aws_nat_gateway.devsu_nat_gateway_b.id
  ]
}

output "public_security_group_id" {
  description = "The ID of the security group used for public instances"
  value       = aws_security_group.public_sg.id
}

output "private_security_group_id" {
  description = "The ID of the security group used for private instances"
  value       = aws_security_group.private_sg.id
}


output "alb_security_group_id" {
  description = "The ID of the security group used for alb"
  value       = aws_security_group.alb_sg.id
}