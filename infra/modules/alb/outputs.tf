output "alb_security_group_id" {
  description = "The ID of the ALB security group"
  value       = aws_security_group.alb_sg.id
}

output "alb_arn" {
  description = "The ARN of the Application Load Balancer"
  value       = aws_lb.alb.arn
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.alb.dns_name
}

output "alb_name" {
  description = "The name of the Application Load Balancer"
  value       = aws_lb.alb.name
}

output "alb_listener_arn" {
  description = "The ARN of the ALB listener"
  value       = aws_lb_listener.listener.arn
}

output "alb_target_group_arn" {
  description = "The ARN of the target group associated with the ALB"
  value       = aws_lb_target_group.tg.arn
}

output "alb_target_group_name" {
  description = "The name of the target group associated with the ALB"
  value       = aws_lb_target_group.tg.name
}
