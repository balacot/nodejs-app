output "alb_dns_name" {
  description = "DNS público del Application Load Balancer"
  value       = aws_lb.app_lb.dns_name
}

output "ecr_repository_url" {
  description = "URL del repositorio de contenedores en ECR"
  value       = aws_ecr_repository.nodejs_app.repository_url
}

output "ecs_cluster_name" {
  description = "Nombre del ECS Cluster"
  value       = aws_ecs_cluster.nodejs_cluster.name
}
