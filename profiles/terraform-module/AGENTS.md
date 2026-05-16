# AGENTS.md — Terraform/IaC Module

> Standard: AAIF/Linux Foundation AGENTS.md v1.0
> Profile: terraform-module | Org: FEMSA Digital
> Tool: Terraform 1.7+ / Terragrunt

## Identity

- Organization: FEMSA Digital
- Module type: Infrastructure as Code (Terraform/Terragrunt)
- Cloud: AWS (primary)
- State: S3 + DynamoDB locking
- Secrets: HashiCorp Vault + AWS Secrets Manager
- CI/CD: Jenkins + terraform plan/apply

## Build

```bash
terraform init           # Initialize providers
terraform fmt -check     # Format check
terraform validate       # Syntax validation
terraform plan           # Plan changes (NEVER auto-apply)
tflint                   # Linting
checkov -d .             # Security scanning
```

## Project Structure

```
.
├── main.tf              # Primary resources
├── variables.tf         # Input variables (all documented)
├── outputs.tf           # Output values
├── providers.tf         # Provider configuration
├── versions.tf          # Required providers + versions
├── data.tf              # Data sources
├── locals.tf            # Local values
├── modules/             # Child modules
├── environments/        # Per-environment tfvars
│   ├── dev.tfvars
│   ├── staging.tfvars
│   └── production.tfvars
└── tests/               # Terraform test files
```

## Conventions

### Terraform
- Terraform >= 1.7
- Provider versions pinned (exact or ~>)
- All variables MUST have `description` and `type`
- All outputs MUST have `description`
- Use `locals` for computed values (DRY)
- Module sources pinned to exact version/tag
- No `count` for complex conditional resources — use `for_each`

### Naming
- Resources: `snake_case` with service prefix
- Variables: `snake_case`, descriptive
- Outputs: `snake_case`, prefixed by resource type
- Tags: `Environment`, `Service`, `Team`, `ManagedBy=terraform`

### Security
- NEVER hardcode credentials in `.tf` files
- Use IAM roles (not access keys) for service auth
- Encrypt all storage at rest (S3, EBS, RDS)
- Security groups: least privilege, no `0.0.0.0/0` on ingress (except ALB)
- Enable VPC flow logs
- Enable CloudTrail
- KMS keys for sensitive data encryption

### State
- Remote state in S3 with versioning + encryption
- DynamoDB table for state locking
- Never commit `.terraform/` or `terraform.tfstate`
- Separate state file per environment

### Testing
- `terraform validate` on every PR
- `tflint` for best practices
- `checkov` / `tfsec` for security scanning
- Integration tests with Terratest (Go) for shared modules

### Branching & Commits
- Branch: `type/TICKET-descripcion-corta`
- Commits: `type(scope): descripción`
- PR: requires `terraform plan` output attached

## Constraints

- NEVER run `terraform apply` without human approval
- NEVER modify production state manually
- NEVER use `terraform taint` in production without approval
- Do NOT hardcode AMI IDs — use data sources or variables
- Do NOT create resources without proper tags
- Do NOT use default VPC or default security groups
- Do NOT disable encryption on any storage resource

## Agent Autonomy

- Level: restricted (infrastructure is HIGH-RISK)
- Allowed: read, validate, plan, lint, suggest changes
- Blocked: apply, destroy, import, state manipulation
- Approval: ALL changes to production, new resources, IAM policy changes
- Audit: every plan output logged
