# Skill: Code Review — Terraform Module

## Trigger
When reviewing pull requests or code changes in Terraform/Terragrunt infrastructure code.

## Checks

### Module Standards
- All variables have `description` and `type`
- All outputs have `description`
- Module sources pinned to exact version tag
- Only approved FEMSA modules from Bitbucket (no unapproved public registry)
- `for_each` preferred over `count` for conditional resources

### Tagging Compliance
- All resources have mandatory tags: Environment, Service, Team, Country, ManagedBy
- Tags use correct casing (PascalCase keys)
- No resources without tags (except data sources)

### Security
- No credentials hardcoded in .tf files
- IAM policies follow least privilege
- No `0.0.0.0/0` on SSH/RDP ingress
- All storage encrypted at rest (S3, EBS, RDS)
- Security groups have explicit descriptions
- KMS keys for sensitive data

### State & Backend
- Remote state in S3 with encryption + versioning
- DynamoDB lock configured
- Separate state per environment
- No local state committed

### Multi-Account
- Cross-account access uses assume_role (not access keys)
- Resources deployed to correct account (workload vs management)
- IAM roles scoped appropriately per account

### Naming Conventions
- Resources: `snake_case` with service prefix
- Variables/Outputs: `snake_case`, descriptive
- Locals used for computed values (DRY)
