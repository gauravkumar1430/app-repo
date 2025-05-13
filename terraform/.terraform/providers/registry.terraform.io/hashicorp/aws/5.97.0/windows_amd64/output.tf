output "eks_cluster_endpoint" {
  value = aws_eks_cluster.app_cluster.endpoint
}
output "rds_endpoint" {
  value = aws_db_instance.app_db.endpoint
}