resource "aws_lb" "load_balancer" {
  name               = var.load_balancer_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups_id
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false

  #tijdelijk logs gedisabled => later verder uitzoeken
  #access_logs {
  #  bucket  = aws_s3_bucket.lb_logs.id
  #  prefix  = "test-lb"
  #  enabled = true
  #}

  tags = {
    Name = "${var.load_balancer_name} load balancer"
  }
}

#alb target group
resource "aws_lb_target_group" "alb_target_group" {
  name        = "${var.load_balancer_name}-tg"
  target_type = "instance"
  port        = 80 #miss ook checken voor https ik denk aanpassen naar 9000 voor sonar maar we zullen dit aanpassen na de push als fout
  protocol    = "HTTP" #dit moet dan ook naar TCP denk ik
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
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
  /*
  default_action {
    type = "redirect"
    
    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  
  }
  */
}
#commented untill i figure out if i need a certificate and how to get one 
/*
# create a listener on port 443 with forward action
resource "aws_lb_listener" "alb_https_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn    = #acm fixen

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}
*/
