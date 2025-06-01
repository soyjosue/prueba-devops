output "k8s_control_plane_instance_id" {
  description = "The ID of the Kubernetes control plane EC2 instance"
  value       = aws_instance.k8s_control_plane_server.id
}

output "k8s_control_plane_private_ip" {
  description = "The private IP address of the Kubernetes control plane instance"
  value       = aws_instance.k8s_control_plane_server.private_ip
}

output "k8s_control_plane_ami_id" {
  description = "The AMI ID used for the Kubernetes control plane instance"
  value       = aws_instance.k8s_control_plane_server.ami
}

output "k8s_control_plane_az" {
  description = "The availability zone of the Kubernetes control plane instance"
  value       = aws_instance.k8s_control_plane_server.availability_zone
}

output "k8s_control_plane_key_name" {
  description = "The key pair name used for the Kubernetes control plane instance"
  value       = aws_instance.k8s_control_plane_server.key_name
}
