#ami
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

#EC2
resource "aws_launch_configuration" "EC2_instance" {
  name_prefix   = "${var.instance_name}-"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type

  security_groups      = var.security_group_ids
  iam_instance_profile = var.iam_instance #nog doen

  user_data = file("../modules/autoscaling_group/sonarqube_compute_engine.sh") # nog var maken

  lifecycle {
    create_before_destroy = true
  }
}

#asg
resource "aws_autoscaling_group" "example" {
  name                 = "${var.asg_name}-asg"
  launch_configuration = aws_launch_configuration.EC2_instance.name

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity

  target_group_arns = [var.target_group_arns]

}
