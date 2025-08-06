data "aws_caller_identity" "current" {}

#####################################
# ROLE para AWS CodeBuild
#####################################
resource "aws_iam_role" "codebuild_role" {
  name = "${var.project_name}-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "codebuild.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_admin_policy" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy" "codebuild_logs" {
  name = "${var.project_name}-codebuild-logs-policy"
  role = aws_iam_role.codebuild_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy" "codebuild_s3_artifact_access" {
  name = "${var.project_name}-codebuild-s3-artifact-access"
  role = aws_iam_role.codebuild_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning"
      ],
      Resource = [
        "arn:aws:s3:::${var.artifact_bucket}",
        "arn:aws:s3:::${var.artifact_bucket}/*"
      ]
    }]
  })
}

resource "aws_iam_role_policy" "codebuild_ecr_permissions" {
  name = "${var.project_name}-codebuild-ecr-policy"
  role = aws_iam_role.codebuild_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload"
      ],
      Resource = "*"
    }]
  })
}

#####################################
# ROLE para AWS CodePipeline
#####################################
resource "aws_iam_role" "codepipeline_role" {
  name = "${var.project_name}-codepipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "codepipeline.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codepipeline_policies" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess"
}

resource "aws_iam_role_policy" "codepipeline_artifact_permissions" {
  name = "${var.project_name}-codepipeline-artifact-policy"
  role = aws_iam_role.codepipeline_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:GetBucketVersioning"
      ],
      Resource = [
        "arn:aws:s3:::${var.artifact_bucket}",
        "arn:aws:s3:::${var.artifact_bucket}/*"
      ]
    }]
  })
}

resource "aws_iam_role_policy" "codepipeline_startbuild" {
  name = "${var.project_name}-startbuild-policy"
  role = aws_iam_role.codepipeline_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "codebuild:StartBuild",
        "codebuild:BatchGetBuilds"
      ],
      Resource = "arn:aws:codebuild:${var.aws_region}:${data.aws_caller_identity.current.account_id}:project/${var.project_name}-build"
    }]
  })
}

#####################################
# PERMISOS PARA ECS DESDE CODEPIPELINE
#####################################
resource "aws_iam_role_policy" "codepipeline_ecs_permissions" {
  name = "${var.project_name}-codepipeline-ecs-policy"
  role = aws_iam_role.codepipeline_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecs:RegisterTaskDefinition",
          "ecs:DescribeServices",
          "ecs:DescribeTaskDefinition",
          "ecs:UpdateService",
          "ecs:RunTask",
          "iam:PassRole"
        ],
        Resource = "*"
      }
    ]
  })
}
