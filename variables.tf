variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
  default     = "nodejs-app"
}

variable "aws_region" {
  description = "Región AWS"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "ID de la VPC existente"
  type        = string
  default     = "vpc-0c6a74aa08b14c7b4"
}

variable "subnet_ids" {
  description = "Lista de subnets públicas"
  type        = list(string)
  default     = [
    "subnet-0c37fdb4505dc80c4",
    "subnet-0956a34a44c43dbc5",
    "subnet-0d629d64a250c6219",
    "subnet-0acacfd70113623ff"
  ]
}

variable "github_owner" {
  description = "Dueño del repositorio GitHub"
  type        = string
  default     = "balacot"
}

variable "github_repo" {
  description = "Nombre del repositorio"
  type        = string
  default     = "nodejs-app"
}

variable "github_branch" {
  description = "Rama principal del repositorio"
  type        = string
  default     = "main"
}

variable "container_port" {
  description = "Puerto donde corre la app Node.js"
  type        = number
  default     = 3000
}

variable "github_oauth_token" {
  description = "Token de autenticación de GitHub (no debe tener default por seguridad)"
  type        = string
  sensitive   = true
}
