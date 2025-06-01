# ──────── VPC MODULE ────────
output "network" {
  description = "Network-related outputs including VPC, subnets, NAT gateways, and security groups"
  value = {
    vpc_id                  = module.vpc.vpc_id
    public_subnet_ids       = module.vpc.public_subnet_ids
    private_subnet_id       = module.vpc.private_subnet_id
    nat_gateway_ids         = module.vpc.nat_gateway_ids
    public_security_group_id  = module.vpc.public_security_group_id
    private_security_group_id = module.vpc.private_security_group_id
  }
}

# ──────── ALB MODULE ────────
output "alb" {
  description = "Application Load Balancer outputs including DNS name, listener and target group ARNs"
  value = {
    dns_name          = module.alb.alb_dns_name
    target_group_arn  = module.alb.alb_target_group_arn
    listener_arn      = module.alb.alb_listener_arn
  }
}

# ──────── INFRA BRIDGE NODE ────────
output "infra_bridge_node" {
  description = "Public IP and DNS for the infra-bridge-node used for DevOps operations"
  value = {
    public_ip = module.infra_bridge_node.infra_bridge_node_public_ip
    dns_name  = module.infra_bridge_node.infra_bridge_node_public_dns
  }
}

# ──────── K8S CONTROL PLANE ────────
output "k8s_control_plane" {
  description = "Kubernetes control plane outputs including public IP and DNS"
  value = {
    private_ip = module.k8s_control_plane_server.k8s_control_plane_private_ip
  }
}

# ──────── K8S WORKER NODE ────────
output "k8s_worker_node" {
  description = "Kubernetes worker node outputs including public IP and DNS"
  value = {
    private_ips = module.k8s_worker_server.k8s_worker_private_ip
  }
}
