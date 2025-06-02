resource "aws_instance" "k8s_control_plane_server" {
  ami                    = "ami-084568db4383264d4"
  instance_type          = "t2.medium"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_pair_name

  tags = {
    Name = "k8s_control_plane_server"
  }
}
