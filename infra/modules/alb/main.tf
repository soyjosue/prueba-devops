# ---- Application Load Balancer ----
resource "aws_lb" "alb" {
  name               = "devsu-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_ids

  idle_timeout = 120

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
    path                = "/_health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 70
    timeout             = 60
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
