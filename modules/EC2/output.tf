output "public_ipv4_adress" {
  value = aws_instance.ec2_instance.*.public_ip
}
output "instance_ids" {
  value = aws_instance.ec2_instance.*.id
}
