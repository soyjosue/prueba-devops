variable "subnet_id" {
  type        = string
  description = "The ID of the subnet where the Kubernetes worker nodes will be deployed."
}

variable "security_group_id" {
  type        = string
  description = "The ID of the security group to associate with the worker nodes."
}

variable "key_pair_name" {
  type        = string
  description = "The name of the EC2 key pair used for SSH access to the worker nodes."
}
