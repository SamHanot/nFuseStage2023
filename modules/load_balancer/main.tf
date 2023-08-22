resource "aws_lb" "load_balancer" {
  name               = var.load_balancer_name
  internal           = false
  load_balancer_type = var.lb_type
  security_groups    = var.security_groups_id
  subnets            = var.subnet_ids

  enable_deletion_protection = false
  tags = {
    Name = "${var.load_balancer_name} load balancer"
  }
}

#alb target group
resource "aws_lb_target_group" "alb_target_group" {
  name        = "${var.load_balancer_name}-tg"
  target_type = "instance"
  port        = var.target_port
  protocol    = var.protocol
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    interval            = 300
    path                = "/"
    timeout             = 60
    matcher             = 200
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group_attachment" "app_tg_attachement" {
  count = length(var.target_ids)

  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = var.target_ids[count.index]
  port             = var.target_port
}

# create a listener on port 80 with forward action
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = var.listener_port
  protocol          = var.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}
