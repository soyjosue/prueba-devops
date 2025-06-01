# ---- Load Balancer Security Group ----
resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Allow HTTP traffic for the Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb_sg"
  }
}

# ---- Application Load Balancer ----
resource "aws_lb" "alb" {
  name               = "devsu-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "devsu-alb"
  }
}

# Target Group (to route traffic to EC2 instance in private subnet)
resource "aws_lb_target_group" "tg" {
  name     = "devsu-tg"
  port     = 31567
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    port                = "traffic-port"
  }

  tags = {
    Name = "devsu-tg"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

# Attach EC2 Instances to the Target Group
resource "aws_lb_target_group_attachment" "tg_attachments" {
  for_each = var.private_instance_ids

  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = each.value
  port             = 31567
}

resource "aws_security_group_rule" "allow_alb_to_targets" {
  type                     = "ingress"
  from_port                = 31567
  to_port                  = 31567
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb_sg.id
  security_group_id        = var.private_sg_id
  description              = "Allow ALB access to private instances on port 31567"
}
