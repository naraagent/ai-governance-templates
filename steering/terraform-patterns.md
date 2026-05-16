---
inclusion: fileMatch
fileMatchPattern: "**/*.tf,**/*.tfvars,**/terragrunt.hcl"
---

# Terraform / IaC Patterns

> Activates when working with Terraform/Terragrunt files.

## Required

- Terraform >= 1.7
- Provider versions pinned (exact or `~>` minor)
- All variables MUST have `description` and `type`
- All outputs MUST have `description`
- All resources MUST have required tags

## Required Tags

```hcl
tags = {
  Environment = var.environment
  Service     = var.service_name
  Team        = var.team
  ManagedBy   = "terraform"
}
```

## Naming

- Resources: `snake_case` with service prefix
- Variables: `snake_case`, descriptive
- Outputs: `snake_case`, prefixed by resource type
- Modules: `snake_case`, descriptive

## Security Rules

- NEVER hardcode credentials, account IDs, or ARNs in `.tf` files
- Use IAM roles (not access keys) for service auth
- Encrypt ALL storage at rest (S3, EBS, RDS, DynamoDB)
- Security groups: least privilege, no `0.0.0.0/0` on SSH/RDP
- Enable VPC flow logs for production
- Enable CloudTrail for audit
- KMS keys for sensitive data

## State Management

- Remote state: S3 with versioning + encryption + DynamoDB locking
- Never commit `.terraform/` or `*.tfstate`
- Separate state per environment
- Never modify state manually without team approval

## Patterns

```hcl
# ✅ Variable with full definition
variable "instance_type" {
  description = "EC2 instance type for the service"
  type        = string
  default     = "t3.medium"

  validation {
    condition     = can(regex("^t3\\.", var.instance_type))
    error_message = "Only t3 instance types are approved."
  }
}

# ✅ Resource with proper tags and encryption
resource "aws_s3_bucket" "data" {
  bucket = "${var.project}-${var.environment}-data"
  tags   = local.common_tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "data" {
  bucket = aws_s3_bucket.data.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.data.arn
    }
  }
}
```

## NEVER

- `terraform apply` without human review
- Resources without tags
- Storage without encryption
- Default VPC or default security groups
- Hardcoded AMI IDs (use data sources)
- `count` for complex conditionals (use `for_each`)
