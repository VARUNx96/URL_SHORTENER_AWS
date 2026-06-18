data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "my-tf-state-url-shortener"
    key    = "VPC/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_eks_cluster" "main" {
  name     = "url-shortener-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  vpc_config {
    subnet_ids = [
      data.terraform_remote_state.vpc.outputs.subnet_1_id,
      data.terraform_remote_state.vpc.outputs.subnet_2_id
    ]
  }
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}

resource "aws_eks_node_group" "nodes" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "url-shortener-nodes"
  node_role_arn   = aws_iam_role.eks_node_role.arn

  subnet_ids = [
    data.terraform_remote_state.vpc.outputs.subnet_1_id,
    data.terraform_remote_state.vpc.outputs.subnet_2_id
  ]
  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }
  instance_types = ["t3.small"]
  capacity_type  = "ON_DEMAND"
  depends_on = [
    aws_iam_role_policy_attachment.node_policy_1,
    aws_iam_role_policy_attachment.node_policy_2,
    aws_iam_role_policy_attachment.node_policy_3
  ]
}
