---
inclusion: auto
---

# FEMSA Infrastructure Conventions — Terraform

## Approved Module Sources (Bitbucket)

- terraform-aws-eks: `git::https://bitbucket.org/digitaldifarma/terraform-aws-eks.git?ref=v3.x.x`
- terraform-aws-rds: `git::https://bitbucket.org/digitaldifarma/terraform-aws-rds.git?ref=v2.x.x`
- terraform-aws-elasticache: `git::https://bitbucket.org/digitaldifarma/terraform-aws-elasticache.git?ref=v1.x.x`
- terraform-k8s-stack: `git::https://bitbucket.org/digitaldifarma/terraform-k8s-stack.git?ref=v2.x.x`
- All module refs pinned to exact tag (no `main` or `HEAD`)
- Internal modules preferred over public registry

## Tagging Strategy (MANDATORY)

All resources MUST have these tags:

```hcl
locals {
  common_tags = {
    Environment = var.environment        # dev, staging, production
    Service     = var.service_name       # e.g., customer-service
    Team        = var.team_name          # e.g., platform, payments
    Country     = var.country            # cl, co, ec, mx
    ManagedBy   = "terraform"
  }
}
```

- Additional tags: `CostCenter`, `Project` (optional but recommended)
- Tags propagated to all child resources

## Multi-Account Deployment

- Management account: 907220922556 (state, pipelines, shared services)
- Workload account: 561041807907 (application resources)
- Cross-account access via `assume_role` in provider configuration:

```hcl
provider "aws" {
  alias  = "workload"
  region = var.aws_region
  assume_role {
    role_arn = "arn:aws:iam::561041807907:role/TerraformExecutionRole"
  }
}
```

- State bucket: S3 in management account (907220922556)
- DynamoDB lock table: in management account
- Workload resources deployed via assumed role

## Terragrunt Configuration

- `terragrunt.hcl` at root for remote state config
- Per-environment directories: `environments/{env}/terragrunt.hcl`
- DRY inputs via `include` blocks
- Dependencies declared via `dependency` blocks
- `generate` blocks for provider config

## Environment Structure

```
infrastructure/
├── terragrunt.hcl              # Root config (state, provider)
├── modules/                    # Shared modules
├── environments/
│   ├── dev/
│   │   ├── terragrunt.hcl
│   │   └── {service}/
│   ├── staging/
│   │   ├── terragrunt.hcl
│   │   └── {service}/
│   └── production/
│       ├── terragrunt.hcl
│       └── {service}/
└── _global/                    # Account-wide resources (IAM, VPC)
```

## Jenkins Pipeline for Terraform

- Plan: automatic on PR creation
- Apply: manual approval required
- Stages: init → validate → plan → (approval) → apply
- Plan output attached to PR as comment
- Drift detection: scheduled `terraform plan` (daily)
