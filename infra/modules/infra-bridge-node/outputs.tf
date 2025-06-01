output "infra_bridge_node_instance_id" {
  description = "The ID of the infra-bridge-node EC2 instance"
  value       = aws_instance.infra_bridge_node.id
}

output "infra_bridge_node_public_ip" {
  description = "The public IP address of the infra-bridge-node instance"
  value       = aws_instance.infra_bridge_node.public_ip
}

output "infra_bridge_node_private_ip" {
  description = "The private IP address of the infra-bridge-node instance"
  value       = aws_instance.infra_bridge_node.private_ip
}

output "infra_bridge_node_public_dns" {
  description = "The public DNS name of the infra-bridge-node instance"
  value       = aws_instance.infra_bridge_node.public_dns
}

output "infra_bridge_node_ami_id" {
  description = "The AMI ID used for the infra-bridge-node instance"
  value       = aws_instance.infra_bridge_node.ami
}

output "infra_bridge_node_availability_zone" {
  description = "The availability zone where the infra-bridge-node is deployed"
  value       = aws_instance.infra_bridge_node.availability_zone
}

output "infra_bridge_node_key_name" {
  description = "The key pair name associated with the infra-bridge-node instance"
  value       = aws_instance.infra_bridge_node.key_name
}
