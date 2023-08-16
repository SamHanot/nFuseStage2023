output "alb_target_group_arn" {
  value = aws_lb_target_group.alb_target_group.arn
}
output "load_balancer_dns_name" {
  value = aws_lb.load_balancer.dns_name
}
output "load_balancer_zone_id" {
  value = aws_lb.load_balancer.zone_id
}
