output "rds_writer_endpoint" {
  value = aws_rds_cluster_instance.cluster_instances[0].endpoint
}
