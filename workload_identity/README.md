# Workload Identity Federation Example

This folder contains a lean Terraform example for Google Cloud Workload Identity Federation using GitHub Actions as the external identity provider.

It is designed for testing the common GitHub-to-GCP setup without storing long-lived service account keys in GitHub.

## What It Creates

- One Google service account for GitHub Actions
- One Workload Identity Pool
- One OIDC Workload Identity Provider that trusts GitHub Actions
- One `roles/iam.workloadIdentityUser` binding so the GitHub repository can impersonate the service account
- Optional `roles/iam.serviceAccountTokenCreator` binding
- Project roles attached to the service account

## Files

- `versions.tf`: Terraform and provider requirements
- `provider.tf`: Google provider configuration
- `variables.tf`: input variables
- `terraform.tfvars.example`: example values
- `main.tf`: Workload Identity Federation resources
- `outputs.tf`: useful outputs

## Prerequisites

- Terraform installed
- Google Cloud project
- `gcloud` CLI installed
- Logged into Google Cloud and Application Default Credentials configured:

```bash
gcloud auth login
gcloud config set project YOUR_PROJECT_ID
gcloud auth application-default login
```

- A GitHub repository that will run the workflow

## Quick Start

1. Move into this folder:

```bash
cd workload_identity
```

2. Create your local variables file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

3. Update `terraform.tfvars` with your project and repository values.

4. Confirm you are logged into the correct Google Cloud project:

```bash
gcloud auth list
gcloud config get-value project
```

5. Initialize Terraform:

```bash
terraform init
```

6. Review the plan:

```bash
terraform plan
```

7. Apply:

```bash
terraform apply
```

8. Capture the important outputs:

```bash
terraform output -raw workload_identity_provider_name
terraform output -raw service_account_email
```

## Example Variables

```hcl
project_id                         = "your-gcp-project-id"
pool_id                            = "github-pool"
provider_id                        = "github-provider"
service_account_id                 = "github-deployer"
github_repository                  = "your-org/your-repo"
github_branch                      = "main"
grant_service_account_token_creator = false
service_account_roles              = ["roles/viewer"]
```

## GitHub Actions Test

After `terraform apply`, add the provider name and service account email to GitHub repository secrets or variables, then run a workflow like this from the allowed branch:

For this repo, use these GitHub settings:

- Repository secret `GCP_WIF_PROVIDER` = `projects/675448468785/locations/global/workloadIdentityPools/github-pool/providers/github-provider`
- Repository secret `GCP_SERVICE_ACCOUNT` = `github-deployer@qwiklabs-gcp-03-6d4273bf43e2.iam.gserviceaccount.com`
- Repository variable `GCP_PROJECT_ID` = `qwiklabs-gcp-03-6d4273bf43e2`

This repository already includes the workflow at `.github/workflows/test-wif.yml`.

```yaml
name: test-wif

on:
  workflow_dispatch:

permissions:
  contents: read
  id-token: write

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - id: auth
        uses: google-github-actions/auth@v2
        with:
          workload_identity_provider: ${{ secrets.GCP_WIF_PROVIDER }}
          service_account: ${{ secrets.GCP_SERVICE_ACCOUNT }}

      - uses: google-github-actions/setup-gcloud@v2

      - run: gcloud auth list
      - run: gcloud projects get-iam-policy "${{ vars.GCP_PROJECT_ID }}" --limit=1
```

If the workflow authenticates successfully, federation is working.

## Notes

- `gcloud auth login` signs the CLI into Google Cloud, while `gcloud auth application-default login` gives Terraform local Application Default Credentials.
- This example is intentionally strict: it allows only one GitHub repository and one branch.
- If you need tags, pull requests, or multiple branches, adjust `attribute_condition`.
- The service account still needs project roles to do useful work after authentication.
- Some GitHub Actions use cases need `roles/iam.serviceAccountTokenCreator`; that is why the example exposes it as an option.

## Cleanup

Destroy the resources with:

```bash
terraform destroy
```
