# terraform-module

## Commands
- Init: `terraform init`
- Format Check: `terraform fmt -check`
- Validate: `terraform validate`
- Plan: `terraform plan`
- Lint: `tflint`
- Security Scan: `checkov -d .`

## Testing
- Run `terraform validate` and `tflint` before marking any task as done
- Run `checkov` security scan on all changes
- All variables must have `description` and `type`
- All outputs must have `description`

## Do Not
- Do not run `terraform apply` without human approval
- Do not modify production state manually
- Do not hardcode credentials in `.tf` files
- Do not hardcode AMI IDs — use data sources or variables
- Do not create resources without proper tags
- Do not use default VPC or default security groups
- Do not disable encryption on any storage resource
- Do not use `0.0.0.0/0` on security group ingress (except ALB)
