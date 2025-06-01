resource "aws_instance" "infra_bridge_node" {
  ami                         = "ami-084568db4383264d4"
  instance_type               = "t2.medium"
  subnet_id                   = var.subnet_id
  key_name                    = var.key_pair_name
  associate_public_ip_address = true

  vpc_security_group_ids = [var.security_group_id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y software-properties-common

              # Install Ansible
              sudo add-apt-repository --yes --update ppa:ansible/ansible
              sudo apt install -y ansible
              EOF

  tags = {
    Name = "infra_bridge_node"
  }
}

locals {
  hosts_ini = templatefile("${path.module}/templates/hosts.tmpl", {
    control_plane_ip = var.control_plane_ip
    worker_ips       = var.worker_ips
  })
}

resource "null_resource" "upload_and_apply_ansible_folder" {
  depends_on = [aws_instance.infra_bridge_node]

  triggers = {
    ansible_checksum = filesha256("${path.module}/../../../ansible/main.yml")
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = aws_instance.infra_bridge_node.public_ip
    private_key = var.ssh_private_key_content
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for ansible-playbook to be available...'",
      "while ! command -v ansible-playbook >/dev/null 2>&1; do sleep 5; done",
      "echo 'ansible-playbook is now installed.'"
    ]
  }

  provisioner "file" {
    source      = "${path.module}/../../ssh-key/devsu_ec2_key.pem"
    destination = "/home/ubuntu/.ssh/id_rsa"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 /home/ubuntu/.ssh/id_rsa"
    ]
  }

  provisioner "file" {
    source      = "${path.module}/../../../ansible"
    destination = "/home/ubuntu/ansible"
  }

  provisioner "remote-exec" {
    inline = [
      "echo \"${replace(local.hosts_ini, "\"", "\\\"")}\" > /home/ubuntu/ansible/hosts.ini",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "cd /home/ubuntu/ansible",
      "ansible-playbook main.yml -i hosts.ini"
    ]
  }
}
