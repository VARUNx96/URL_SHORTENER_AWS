resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "eks-pod-identity-agent"
}

resource "aws_iam_role" "url_shortener_pod_role" {
  name = "url-shortener-pod-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "pod_dynamodb" {
  role       = aws_iam_role.url_shortener_pod_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_eks_pod_identity_association" "shortener_sa" {
  cluster_name    = aws_eks_cluster.main.name
  namespace       = "default"
  service_account = "shortener-sa"
  role_arn        = aws_iam_role.url_shortener_pod_role.arn
}

resource "aws_eks_pod_identity_association" "redirect_sa" {
  cluster_name    = aws_eks_cluster.main.name
  namespace       = "default"
  service_account = "redirect-sa"
  role_arn        = aws_iam_role.url_shortener_pod_role.arn
}