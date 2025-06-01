variable "subnet_id" {
  type        = string
  description = "The ID of the subnet where the bridge node will be deployed."
}

variable "key_pair_name" {
  type        = string
  description = "The name of the EC2 key pair used for SSH access to the bridge node."
}

variable "security_group_id" {
  type        = string
  description = "The ID of the security group to associate with the bridge node."
}

variable "control_plane_ip" {
  type        = string
  description = "The private IP address of the control plane node to which the bridge node will connect."
}

variable "worker_ips" {
  type        = list(string)
  description = "List of private IP addresses of worker nodes that will be accessed or configured by the bridge node."
}

variable "ssh_private_key_content" {
  type        = string
  description = "The contents of the SSH private key used to connect to the control plane and worker nodes."
}
