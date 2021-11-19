# This repo contain IaC (Terraform) code example for course - https://www.linkedin.com/learning/creating-a-dev-environment-in-aws-with-terraform

### We are created AWS Lambda function and AWS SQS in specific Terraform workspace using
```bash
 [terraform.workspace]
```
### let's create specific Terraform workspace and named it "dev"

```bash
terraform workspace new dev
```
### To switch to specific workspace
```bash
terraform workspace select [name workspace]
```
