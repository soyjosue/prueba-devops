variable "subnet_id" {
  type        = string
  description = "The ID of the subnet where the Kubernetes control plane node will be deployed."
}

variable "security_group_id" {
  type        = string
  description = "The ID of the security group to associate with the control plane node."
}

variable "key_pair_name" {
  type        = string
  description = "The name of the EC2 key pair used for SSH access to the control plane node."
}
