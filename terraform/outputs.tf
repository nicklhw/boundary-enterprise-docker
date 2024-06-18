#------------------------------------------------------------------------------
# Network
#------------------------------------------------------------------------------
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.pre_req.vpc_id
}

output "region" {
  description = "The AWS region where the resources have been created"
  value       = module.pre_req.region
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = module.pre_req.vpc_arn
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.pre_req.vpc_cidr_block
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = module.pre_req.default_security_group_id
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = module.pre_req.private_subnet_ids
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = module.pre_req.private_subnet_arns
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = module.pre_req.private_subnets_cidr_blocks
}

output "private_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of private subnets in an IPv6 enabled VPC"
  value       = module.pre_req.private_subnets_ipv6_cidr_blocks
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = module.pre_req.public_subnet_ids
}

output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = module.pre_req.public_subnet_arns
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = module.pre_req.public_subnets_cidr_blocks
}

output "public_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of public subnets in an IPv6 enabled VPC"
  value       = module.pre_req.public_subnets_ipv6_cidr_blocks
}

output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = module.pre_req.public_route_table_ids
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = module.pre_req.private_route_table_ids
}

output "db_subnet_ids" {
  description = "List of IDs of database subnets"
  value       = module.pre_req.db_subnet_ids
}

output "db_subnet_arns" {
  description = "List of ARNs of database subnets"
  value       = module.pre_req.db_subnet_arns
}

output "db_subnets_cidr_blocks" {
  description = "List of cidr_blocks of database subnets"
  value       = module.pre_req.db_subnets_cidr_blocks
}

output "db_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of database subnets in an IPv6 enabled VPC"
  value       = module.pre_req.db_subnets_ipv6_cidr_blocks
}

output "db_subnet_group" {
  description = "ID of database subnet group"
  value       = module.pre_req.db_subnet_group
}

output "db_subnet_group_name" {
  description = "Name of database subnet group"
  value       = module.pre_req.db_subnet_group_name
}

#------------------------------------------------------------------------------
# KMS
#------------------------------------------------------------------------------
output "kms_key_infra_arn" {
  value       = module.pre_req.kms_key_infra_arn
  description = "KMS Key ARN created to encrypt AWS Infrastructure for module"
}

output "kms_key_infra_alias" {
  value       = module.pre_req.kms_key_infra_alias
  description = "KMS Key Alias created to encrypt AWS Infrastructure for module"
}

output "kms_key_infra_id" {
  value       = module.pre_req.kms_key_infra_id
  description = "KMS Key ID created to encrypt AWS Infrastructure for module"
}

output "kms_key_root_arn" {
  value       = module.pre_req.kms_key_root_arn
  description = "KMS Key ARN created to use as a KEK for the Boundary Deployment"
}

output "kms_key_root_alias" {
  value       = module.pre_req.kms_key_root_alias
  description = "KMS Key Alias created to use as a KEK for the Boundary Deployment"
}

output "kms_key_root_id" {
  value       = module.pre_req.kms_key_root_id
  description = "KMS Key ID created to use as a KEK for the Boundary Deployment"
}

output "kms_key_recovery_arn" {
  value       = module.pre_req.kms_key_recovery_arn
  description = "KMS Key ARN created to use for rescue and recovery operations with Boundary"
}

output "kms_key_recovery_alias" {
  value       = module.pre_req.kms_key_recovery_alias
  description = "KMS Key Alias created to use for rescue and recovery operations with Boundary"
}

output "kms_key_recovery_id" {
  value       = module.pre_req.kms_key_recovery_id
  description = "KMS Key ID created to use for rescue and recovery operations with Boundary"
}

output "kms_key_worker_auth_arn" {
  value       = module.pre_req.kms_key_worker_auth_arn
  description = "KMS Key ARN created to share between Controller and worker to authenticate a worker"
}

output "kms_key_worker_auth_alias" {
  value       = module.pre_req.kms_key_worker_auth_alias
  description = "KMS Key Alias created to share between Controller and worker to authenticate a worker"
}

output "kms_key_worker_auth_id" {
  value       = module.pre_req.kms_key_worker_auth_id
  description = "KMS Key ID created to share between Controller and worker to authenticate a worker"
}

output "kms_key_bsr_arn" {
  value       = module.pre_req.kms_key_bsr_arn
  description = "KMS Key ARN created to encrypt Boundary Session Recordings"
}

output "kms_key_bsr_alias" {
  value       = module.pre_req.kms_key_bsr_alias
  description = "KMS Key Alias created to encrypt Boundary Session Recordings"
}

output "kms_key_bsr_id" {
  value       = module.pre_req.kms_key_bsr_id
  description = "KMS Key ID created to encrypt Boundary Session Recordings"
}


#------------------------------------------------------------------------------
# Secrets Manager
#------------------------------------------------------------------------------
output "boundary_secrets_arn" {
  value       = module.pre_req.boundary_secrets_arn
  description = "AWS Secrets Manager Boundary secrets ARN."
}

output "cert_pem_secret_arn" {
  value       = module.pre_req.cert_pem_secret_arn
  description = "AWS Secrets Manager Boundary BYO CA certificate private key secret ARN."
}

output "cert_pem_private_key_secret_arn" {
  value       = module.pre_req.cert_pem_private_key_secret_arn
  description = "AWS Secrets Manager Boundary BYO CA certificate private key secret ARN."
}

output "secret_arn_list" {
  value       = module.pre_req.secret_arn_list
  description = "A list of AWS Secrets Manager Arns produced by the module"
}

output "optional_secrets" {
  value       = module.pre_req.optional_secrets
  description = "A map of optional secrets that have been created if they were supplied during the time of execution. Output is a single map where the key of the map for the secret is the key and the ARN is the value."
}

#------------------------------------------------------------------------------
# CloudWatch
#------------------------------------------------------------------------------
output "cloudwatch_log_group_name" {
  value       = module.pre_req.cloudwatch_log_group_name
  description = "AWS CloudWatch Log Group Name."
}

#------------------------------------------------------------------------------
# Boundary Key Pair
#------------------------------------------------------------------------------
output "ssh_keypair_name" {
  value       = module.pre_req.ssh_keypair_name
  description = "Name of the keypair that was created (if specified)."
}

output "ssh_keypair_arn" {
  value       = module.pre_req.ssh_keypair_arn
  description = "ARN of the keypair that was created (if specified)."
}

output "ssh_keypair_id" {
  value       = module.pre_req.ssh_keypair_id
  description = "ID of Boundary SSH Key Pair."
}

output "ssh_keypair_fingerprint" {
  value       = module.pre_req.ssh_keypair_fingerprint
  description = "Fingerprint of Boundary SSH Key Pair."
}

#------------------------------------------------------------------------------
# Databases
#------------------------------------------------------------------------------

output "db_cluster_arn" {
  description = "Amazon Resource Name (ARN) of cluster"
  value       = module.pre_req.db_cluster_arn
}

output "db_cluster_id" {
  description = "The RDS Cluster Identifier"
  value       = module.pre_req.db_cluster_id
}

output "db_cluster_resource_id" {
  description = "The RDS Cluster Resource ID"
  value       = module.pre_req.db_cluster_resource_id
}

output "db_cluster_members" {
  description = "List of RDS Instances that are a part of this cluster"
  value       = module.pre_req.db_cluster_members
}

output "db_cluster_endpoint" {
  description = "Writer endpoint for the cluster"
  value       = module.pre_req.db_cluster_endpoint
}

output "db_cluster_reader_endpoint" {
  description = "A read-only endpoint for the cluster, automatically load-balanced across replicas"
  value       = module.pre_req.db_cluster_reader_endpoint
}

output "db_cluster_engine_version_actual" {
  description = "The running version of the cluster database"
  value       = module.pre_req.db_cluster_engine_version_actual
}

output "db_cluster_database_name" {
  description = "Name for an automatically created database on cluster creation"
  value       = module.pre_req.db_cluster_database_name
}

output "db_cluster_port" {
  description = "The database port"
  value       = module.pre_req.db_cluster_port
}

output "db_password" {
  description = "The database master password"
  value       = module.pre_req.db_password
  sensitive   = true
}

output "db_username" {
  description = "The database master username"
  value       = module.pre_req.db_username
  sensitive   = true
}

output "db_cluster_instances" {
  description = "A map of cluster instances and their attributes"
  value       = module.pre_req.db_cluster_instances
}

output "db_additional_cluster_endpoints" {
  description = "A map of additional cluster endpoints and their attributes"
  value       = module.pre_req.db_additional_cluster_endpoints
}

output "db_cluster_role_associations" {
  description = "A map of IAM roles associated with the cluster and their attributes"
  value       = module.pre_req.db_cluster_role_associations
}

output "db_enhanced_monitoring_iam_role_name" {
  description = "The name of the enhanced monitoring role"
  value       = module.pre_req.db_enhanced_monitoring_iam_role_name
}

output "db_enhanced_monitoring_iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the enhanced monitoring role"
  value       = module.pre_req.db_enhanced_monitoring_iam_role_arn
}

output "db_enhanced_monitoring_iam_role_unique_id" {
  description = "Stable and unique string identifying the enhanced monitoring role"
  value       = module.pre_req.db_enhanced_monitoring_iam_role_unique_id
}

output "db_security_group_id" {
  description = "The security group ID of the cluster"
  value       = module.pre_req.db_security_group_id
}

output "db_global_cluster_id" {
  description = "ID of the global cluster that has been created (if specified.)"
  value       = module.pre_req.db_global_cluster_id
}

output "db_cluster_cloudwatch_log_groups" {
  description = "Map of CloudWatch log groups created and their attributes"
  value       = module.pre_req.db_cluster_cloudwatch_log_groups
}
#------------------------------------------------------------------------------
# Boundary IAM Resources
#------------------------------------------------------------------------------
output "iam_role_arn" {
  value       = module.pre_req.iam_role_arn
  description = "ARN of IAM Role in use by Boundary Instances"
}

output "iam_role_name" {
  value       = module.pre_req.iam_role_name
  description = "Name of IAM Role in use by Boundary Instances"
}

output "iam_managed_policy_arn" {
  value       = module.pre_req.iam_managed_policy_arn
  description = "ARN of IAM Managed Policy for Boundary Instance Role"
}

output "iam_managed_policy_name" {
  value       = module.pre_req.iam_managed_policy_name
  description = "Name of IAM Managed Policy for Boundary Instance Role"
}

output "iam_instance_profile" {
  value       = module.pre_req.iam_instance_profile
  description = "ARN of IAM Instance Profile for Boundary Instance Role"
}

output "iam_asg_service_role" {
  value       = module.pre_req.iam_asg_service_role
  description = "ARN of AWS Service Linked Role for AWS EC2 AutoScaling"
}

output "iam_worker_role_arn" {
  value       = module.pre_req.iam_worker_role_arn
  description = "ARN of IAM Role in use by Boundary Worker Instances"
}

output "iam_worker_role_name" {
  value       = module.pre_req.iam_worker_role_name
  description = "Name of IAM Role in use by Boundary Worker Instances"
}

output "iam_worker_managed_policy_arn" {
  value       = module.pre_req.iam_worker_managed_policy_arn
  description = "ARN of IAM Managed Policy for Boundary Worker Instance Role"
}

output "iam_worker_managed_policy_name" {
  value       = module.pre_req.iam_worker_managed_policy_name
  description = "Name of IAM Managed Policy for Boundary Worker Instance Role"
}

output "iam_worker_instance_profile" {
  value       = module.pre_req.iam_worker_instance_profile
  description = "ARN of IAM Instance Profile for Boundary Worker Instance Role"
}
#------------------------------------------------------------------------------
# Boundary Ingress Resources
#------------------------------------------------------------------------------
output "lb_arn" {
  value       = module.pre_req.lb_arn
  description = "The Resource Identifier of the LB"
}

output "lb_name" {
  value       = module.pre_req.lb_name
  description = "Name of the LB"
}

output "lb_dns_name" {
  value       = module.pre_req.lb_dns_name
  description = "The DNS name created with the LB"
}

output "lb_zone_id" {
  value       = module.pre_req.lb_zone_id
  description = "The Zone ID of the LB"
}

output "lb_internal" {
  value       = module.pre_req.lb_internal
  description = "Boolean value of the internal/external status of the LB.  Determines if the LB gets Elastic IPs assigned"
}

output "lb_security_group_ids" {
  value       = module.pre_req.lb_security_group_ids
  description = "List of security group IDs in use by the LB"
}

output "lb_tg_arns" {
  value       = module.pre_req.lb_tg_arns
  description = "List of target group ARNs for LB"
}

output "lb_type" {
  value       = module.pre_req.lb_type
  description = "Type of LB created (ALB or NLB)"
}

output "acm_certificate_arn" {
  value       = module.pre_req.acm_certificate_arn
  description = "The ARN of the certificate"
}

output "acm_certificate_status" {
  value       = module.pre_req.acm_certificate_status
  description = "Status of the certificate"
}

output "acm_distinct_domain_names" {
  value       = module.pre_req.acm_distinct_domain_names
  description = "List of distinct domains names used for the validation"
}

output "acm_validation_domains" {
  value       = module.pre_req.acm_validation_domains
  description = "List of distinct domain validation options. This is useful if subject alternative names contain wildcards"
}

output "acm_validation_route53_record_fqdns" {
  value       = module.pre_req.acm_validation_route53_record_fqdns
  description = "List of FQDNs built using the zone domain and name"
}

output "route53_regional_record_name" {
  value       = module.pre_req.route53_regional_record_name
  description = "Name of the regional LB Route53 record name"
}

output "route53_regional_fqdn" {
  value       = module.pre_req.route53_regional_fqdn
  description = "FQDN of regional LB Route53 record"
}

output "route53_failover_record_name" {
  value       = module.pre_req.route53_failover_record_name
  description = "Name of the failover LB Route53 record name"
}

output "route53_failover_fqdn" {
  value       = module.pre_req.route53_failover_fqdn
  description = "FQDN of failover LB Route53 record"
}

output "asg_hook_value" {
  value       = module.pre_req.asg_hook_value
  description = "Value for the `asg-hook` tag that will be attatched to the Boundary instance in the other module. Use this value to ensure the lifecycle hook is updated during deployment."
}

output "s3_log_bucket_name" {
  value       = module.pre_req.s3_log_bucket_name
  description = "Name of S3 'logging' bucket."
}

output "s3_log_bucket_arn" {
  value       = module.pre_req.s3_log_bucket_arn
  description = "ARN of S3 'logging' bucket."
}
