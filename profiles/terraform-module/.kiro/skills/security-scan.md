# Skill: Security Scan — Terraform Module

## Trigger
When Terraform files are created or modified.

## Checks

### Credential Security
- No AWS access keys or secret keys in .tf files
- No passwords or tokens in variable defaults
- Sensitive variables marked with `sensitive = true`
- No secrets in terraform.tfvars committed to repo

### Network Security
- Security groups: no unrestricted ingress (0.0.0.0/0) except ALB port 443
- VPC flow logs enabled in production
- Private subnets for compute resources
- NAT gateway for outbound internet from private subnets
- No public IPs on EC2/ECS tasks unless explicitly justified

### Encryption
- S3 buckets: server-side encryption enabled (AES-256 or KMS)
- RDS instances: storage encryption enabled, encrypted snapshots
- EBS volumes: encrypted by default
- ElastiCache: in-transit and at-rest encryption
- KMS keys with proper rotation policy

### IAM Security
- No IAM policies with `*` actions on `*` resources
- Service roles scoped to minimum required permissions
- No inline policies (use managed policies)
- MFA required for console access (IAM users)
- Cross-account roles have conditions (external ID)

### Compliance
- CloudTrail enabled in all regions
- Config rules for compliance monitoring
- Backup plans for critical resources
- Resource deletion protection on production databases

### checkov/tfsec
- Run `checkov -d .` on all changes
- Run `tflint` for best practices
- Zero high-severity findings before merge
