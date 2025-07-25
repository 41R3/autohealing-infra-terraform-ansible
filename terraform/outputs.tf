output "load_balancer_dns" {
  description = "DNS público del Load Balancer"
  value       = aws_lb.web.dns_name
}

output "asg_name" {
  description = "Nombre del Auto Scaling Group"
  value       = aws_autoscaling_group.web.name
}

output "instance_security_group_id" {
  description = "ID del Security Group asignado a las instancias"
  value       = aws_security_group.web.id
}

output "vpc_id" {
  description = "ID de la VPC creada"
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "IDs de las subnets públicas"
  value       = aws_subnet.public[*].id
}

output "launch_template_name" {
  description = "Nombre del Launch Template"
  value       = aws_launch_template.web.name
}

output "lb_target_group_arn" {
  description = "ARN del Target Group del Load Balancer"
  value       = aws_lb_target_group.web.arn
}
