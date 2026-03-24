# Cloud SQL Example

This folder contains a lean Terraform example for Google Cloud SQL.

It is designed for learning, so the example stays intentionally small:

- one Cloud SQL instance
- one application database
- one database user

## What It Creates

- A Cloud SQL instance
- A database inside that instance
- A database user for application access

## Files

- `versions.tf`: Terraform and provider requirements
- `provider.tf`: Google provider configuration
- `variables.tf`: input variables
- `terraform.tfvars.example`: example values
- `main.tf`: Cloud SQL resources
- `outputs.tf`: useful outputs

## Prerequisites

- Terraform installed
- Google Cloud project
- Application Default Credentials configured:

```bash
gcloud auth application-default login
```

## Quick Start

1. Move into this folder:

```bash
cd cloudsql
```

2. Create your local variables file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

3. Update the values in `terraform.tfvars`, especially the password.

4. Initialize Terraform:

```bash
terraform init
```

5. Review the plan:

```bash
terraform plan
```

6. Apply:

```bash
terraform apply
```

## Example Variables

```hcl
project_id       = "your-gcp-project-id"
region           = "us-west1"
instance_name    = "cloudsql-demo-instance"
database_name    = "appdb"
db_tier          = "db-f1-micro"
db_user_name     = "appuser"
db_user_password = "change-me"
```

## Notes

- `db_user_password` is sensitive and should stay in your local `terraform.tfvars`.
- This example enables a public IP for simplicity. In a more secure setup, you would often use private IP instead.
- Cloud SQL resources can take a few minutes to create.

## Cleanup

Destroy the resources with:

```bash
terraform destroy
```
