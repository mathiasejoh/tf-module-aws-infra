This is to provision the AWS Infra i.e. EKS Cluster on AWS Environment.
Change
To Setup your own infra, you need to make the following changes in the repository:

1. Look for account.hcl file and update your account_id and account_region.
2. Look for environments/dev folder and rename the skillupwithsachin-eks-demo cluster name to your choice and also update the terragrunt.hcl with the subnet-id's.
3. We are using defualt vpc and subnet-id here so you can use the same.
4. You need to create the OIDC provider in AWS IAM under Identity Provider for the github, please add Provider as : token.actions.githubusercontent.com and  Audience: sts.amazonaws.com
5. You need to create IAM role to run the github actions i.e. <cluster-name>-gha-terraform-svc-role" with the IAM Trust Policy and Permissions as Power User and IAMFullAccess permissions.

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::<your-account-id>:oidc-provider/token.actions.githubusercontent.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                },
                "StringLike": {
                    "token.actions.githubusercontent.com:sub": "repo:skillupwithsachin/tf-module-aws-infra:*"
                }
            }
        }
    ]
}

You can refer the actions repo from here: https://github.com/skillupwithsachin/actions/tree/main

For any queries, reach out to contact@skillupwithsachin.com

Watch full video here: 


