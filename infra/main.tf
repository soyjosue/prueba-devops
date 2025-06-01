terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2_ssh_key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "local_file" "pem_private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${path.module}/ssh-key/devsu_ec2_key.pem"
  file_permission = "0400"
}


module "vpc" {
  source = "./modules/vpc"
}

module "k8s_control_plane_server" {
  source            = "./modules/k8s-control-plane"
  subnet_id         = module.vpc.private_subnet_id
  security_group_id = module.vpc.private_security_group_id
  key_pair_name     = aws_key_pair.ec2_key.key_name
}

module "k8s_worker_server" {
  source            = "./modules/k8s-workers"
  subnet_id         = module.vpc.private_subnet_id
  security_group_id = module.vpc.private_security_group_id
  key_pair_name     = aws_key_pair.ec2_key.key_name
}

module "infra_bridge_node" {
  source                  = "./modules/infra-bridge-node"
  security_group_id       = module.vpc.public_security_group_id
  subnet_id               = module.vpc.public_subnet_ids[0]
  key_pair_name           = aws_key_pair.ec2_key.key_name
  ssh_private_key_content = local_file.pem_private_key.content
  worker_ips               = module.k8s_worker_server.k8s_worker_private_ip
  control_plane_ip        = module.k8s_control_plane_server.k8s_control_plane_private_ip
}

module "alb" {
  source = "./modules/alb"
  
  private_instance_ids = {
    for idx, id in module.k8s_worker_server.k8s_worker_instance_id :
    "worker${idx + 1}" => id
  }
  vpc_id           = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  private_sg_id = module.vpc.private_security_group_id
}
