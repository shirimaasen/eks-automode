# Persistent Admin IAM Role
resource "aws_iam_role" "eks_admin_role" {
  name = "eks-admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "eks_admin_policy" {
  role       = aws_iam_role.eks_admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# EKS Access Entry (register admin role with cluster)
resource "aws_eks_access_entry" "eks_admin" {
  cluster_name = local.cluster_name
  principal_arn = aws_iam_role.eks_admin_role.arn

  type = "STANDARD"

  depends_on = [aws_eks_cluster.this]
}

resource "aws_eks_access_policy_association" "eks_admin_cluster_admin" {
  cluster_name = local.cluster_name
  principal_arn = aws_iam_role.eks_admin_role.arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  access_scope {
    type = "cluster"
  }

  depends_on = [
    aws_eks_cluster.this,
    aws_eks_access_entry.eks_admin
  ]
}

# GitHub OIDC Role Access
resource "aws_eks_access_entry" "github_oidc" {
  cluster_name  = local.cluster_name
  principal_arn = aws_iam_role.github_oidc_role.arn

  type = "STANDARD"

  depends_on = [aws_eks_cluster.this]
}

resource "aws_eks_access_policy_association" "github_oidc_cluster_admin" {
  cluster_name  = local.cluster_name
  principal_arn = aws_iam_role.github_oidc_role.arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  access_scope {
    type = "cluster"
  }

  depends_on = [
    aws_eks_cluster.this,
    aws_eks_access_entry.github_oidc
  ]
}
