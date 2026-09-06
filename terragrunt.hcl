locals {
  account_vars = read_terragrunt_config(
    find_in_parent_folders("account.hcl")
  ).locals
}


generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region = "${local.account_vars.aws_region}"
}

provider "aws" {
  alias  = "aws-no-tags"
  region = "${local.account_vars.aws_region}"

  ignore_tags {
    keys = ["kubernetes.io/cluster/*"]
  }
}
EOF
}


remote_state {
  backend = "s3"
  config = {
    encrypt               = true
  # bucket                = "${local.account_vars.account_id}-tf-state-${local.account_vars.aws_region}"
    bucket                = "devopsdemo-5erbjm"
    key                   = "skillupwithsachin-eks-cluster/${path_relative_to_include()}/terraform.tfstate"
    region                = local.account_vars.aws_region
    disable_bucket_update = true
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
