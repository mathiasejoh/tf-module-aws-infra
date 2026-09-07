module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.31.3"
  providers = {
    aws = aws.aws-no-tags
  }
  cluster_name                    = var.cluster_name
  cluster_version                 = var.k8s_version
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  cluster_endpoint_private_access = true
  cluster_service_ipv4_cidr       = var.cluster_service_ipv4_cidr
  create_cluster_security_group   = var.create_cluster_security_group
  create_node_security_group      = var.create_node_security_group
  bootstrap_self_managed_addons   = false
  create_cloudwatch_log_group     = false
  cluster_enabled_log_types       = []

  create_kms_key            = false
  cluster_encryption_config = {}
  enable_irsa               = false
  cluster_addons = {
    coredns = {
      configuration_values = jsonencode({
        replicaCount = 2
      })
    }
    kube-proxy = {
      configuration_values = jsonencode({
        resources = {
          limits = {
            cpu    = "100m"
            memory = "128Mi"
          }
          requests = {
            cpu    = "15m"
            memory = "64Mi"
          }
        }
      })
    }
    vpc-cni = {
      before_compute = true
    }
    aws-ebs-csi-driver  = {}
    snapshot-controller = {}
  }

  vpc_id     = data.aws_vpc.vpc.id
  subnet_ids = data.aws_subnets.private_subnets.ids

  iam_role_use_name_prefix = false
  iam_role_name            = "${var.cluster_name}-service-role"

  eks_managed_node_group_defaults = {
    create_launch_template     = true
    use_custom_launch_template = true
    enable_bootstrap_user_data = true
    iam_role_attach_cni_policy = true
    iam_role_use_name_prefix   = false
    use_name_prefix            = false
    iam_role_name              = "${var.cluster_name}-node-role"
    iam_role_additional_policies = {
      ebs = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    }
    update_config = {
      max_unavailable = 1
    }
    ami_type       = "AL2023_x86_64_STANDARD"
    capacity_type  = "ON_DEMAND"
    instance_types = ["c6a.2xlarge"]
    min_size       = 1
    desired_size   = 1
    max_size       = 1
    disk_size      = 40
  }

  eks_managed_node_groups = local.node_groups_with_block_devices

  authentication_mode = "API_AND_CONFIG_MAP"

  access_entries = {
    # One access entry with a policy associated
    cluster_admin = {
      kubernetes_groups = []
      principal_arn     = "arn:aws:iam::${data.aws_caller_identity.current.id}:user/eks-cli-user"
      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
    terraform_user = {
      kubernetes_groups = []
      principal_arn     = "arn:aws:iam::${data.aws_caller_identity.current.id}:role/skillupwithsachin-gha-terraform-svc-role"
      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }
}