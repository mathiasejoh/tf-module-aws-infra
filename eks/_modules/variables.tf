variable "cluster_name" {
  type        = string
  description = "The name of the EKS cluster"
}

variable "k8s_version" {
  type        = string
  default     = "1.34"
  description = "The default Kubernetes version to use with this cluster."
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled."
  type        = bool
  default     = "true"
}

variable "cluster_service_ipv4_cidr" {
  description = "The CIDR block to assign Kubernetes service IP addresses."
  type        = string
  default     = "172.20.0.0/16"
}

variable "node_groups_config" {
  type = any
  default = {
    ng_1 = {

    }
  }
  description = "node groups configuration."
}

variable "create_cluster_security_group" {
  description = "Determines if a security group is created for the cluster. Note: the EKS service creates a primary security group for the cluster by default"
  type        = bool
  default     = false
}

variable "create_node_security_group" {
  description = "Determines whether to create a security group for the node groups or use the existing `node_security_group_id`"
  type        = bool
  default     = false
}
