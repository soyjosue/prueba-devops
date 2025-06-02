resource "aws_instance" "k8s_worker_server" {
  ami                    = "ami-084568db4383264d4"
  instance_type          = "t2.medium"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_pair_name
  count                  = 1

  user_data = <<-EOF
              #!/bin/bash
              mkdir -p /mnt/data
              chown -R 1000:1000 /mnt/data
              chmod -R 755 /mnt/data
              EOF

  tags = {
    Name = "k8s_worker_server-${count.index + 1}"
  }
}
