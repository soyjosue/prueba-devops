output "k8s_worker_instance_id" {
  description = "The IDs of the Kubernetes worker EC2 instances"
  value       = aws_instance.k8s_worker_server[*].id
}

output "k8s_worker_private_ip" {
  description = "The private IP addresses of the Kubernetes worker instances"
  value       = aws_instance.k8s_worker_server[*].private_ip
}

output "k8s_worker_ami_id" {
  description = "The AMI IDs used for the Kubernetes worker instances"
  value       = aws_instance.k8s_worker_server[*].ami
}

output "k8s_worker_availability_zone" {
  description = "The availability zones of the Kubernetes worker instances"
  value       = aws_instance.k8s_worker_server[*].availability_zone
}

output "k8s_worker_key_name" {
  description = "The key pair names used for the Kubernetes worker instances"
  value       = aws_instance.k8s_worker_server[*].key_name
}
