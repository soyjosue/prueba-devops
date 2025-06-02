variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the Application Load Balancer (ALB) will be deployed."
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs where the ALB listeners will be placed."
}

variable "private_instance_ids" {
  type        = map(string)
  description = "Map of private instance IDs that will receive traffic from the ALB."
}

variable "private_sg_id" {
  type        = string
  description = "The ID of the security group to associate with the private instances behind the ALB."
}

variable "alb_security_group_id" {
  type        = string
  description = "The ID of the alb security group"
}
