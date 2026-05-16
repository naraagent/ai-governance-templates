# AGENTS.md — Terraform / IaC Module (Full Template)

> Standard: AAIF/Linux Foundation AGENTS.md v1.0
> Compatible: Codex, Copilot, Cursor, Kiro, OpenClaw, Devin, Amp
> Profile: terraform-module | Org: FEMSA Digital

## Identity

- Organization: FEMSA Digital
- Module: {{MODULE_NAME}}
- Tool: Terraform 1.7+ / Terragrunt
- Cloud: AWS
- State: S3 + DynamoDB locking
- CI/CD: Jenkins (plan on PR, apply on merge with approval)

## Build

```bash
terraform init
terraform fmt -check
terraform validate
tflint
checkov -d .
```

## Plan

```bash
terraform plan -var-file=environments/${ENV}.tfvars -out=tfplan
```

## Structure

```
.
├── main.tf           # Primary resources
├── variables.tf      # Input variables (all documented)
├── outputs.tf        # Outputs (all documented)
├── providers.tf      # Provider config
├── versions.tf       # Required providers + versions
├── data.tf           # Data sources
├── locals.tf         # Computed locals
├── modules/          # Child modules
├── environments/     # Per-env tfvars
└── tests/            # Terraform tests
```

## Conventions

- All variables: `description` + `type` required
- All outputs: `description` required
- All resources: tagged (Environment, Service, Team, ManagedBy)
- Provider versions pinned
- Module sources pinned to exact tag
- `for_each` over `count` for conditional resources
- `locals` for computed values (DRY)
- Snake_case naming throughout

## Security

- No credentials in .tf files
- IAM roles (not access keys)
- All storage encrypted at rest
- Security groups: least privilege
- VPC flow logs enabled (production)
- CloudTrail enabled
- KMS for sensitive data

## Constraints

- NEVER `terraform apply` without human approval
- NEVER modify state manually
- NEVER use default VPC or default security groups
- NEVER create resources without required tags
- NEVER disable encryption

## Agent Governance

- Mode: restricted (HIGH-RISK infrastructure)
- Allowed: read, init, validate, plan, fmt, lint
- Blocked: apply, destroy, import, state operations
- Approval: ALL production changes, new resources, IAM policies
- Audit: every plan output logged and reviewed
