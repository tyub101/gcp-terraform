# HTTP Load Balancer Example

This folder contains a lean Terraform example for a Google Cloud external HTTP load balancer.

It is intentionally small, but it still includes the core resources required to understand how traffic flows from a public IP to a healthy backend VM.

## What It Creates

- Custom VPC
- Custom subnet
- Firewall rule for Google health checks
- One backend Compute Engine VM
- Unmanaged instance group with named port `http`
- HTTP health check
- Backend service
- URL map
- Target HTTP proxy
- Global IP address
- Global forwarding rule

## Files

- `versions.tf`: Terraform and provider requirements
- `provider.tf`: Google provider configuration
- `variables.tf`: input variables
- `terraform.tfvars.example`: example input values
- `main.tf`: infrastructure resources
- `outputs.tf`: useful outputs after apply

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
cd lb
```

2. Create your local variables file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

3. Initialize Terraform:

```bash
terraform init
```

4. Review the plan:

```bash
terraform plan
```

5. Apply the infrastructure:

```bash
terraform apply
```

6. Get the public IP:

```bash
terraform output -raw load_balancer_ip
```

7. Test the load balancer:

```bash
curl http://$(terraform output -raw load_balancer_ip)
```

## Example Variables

```hcl
project_id = "your-gcp-project-id"
region     = "us-west1"
zone       = "us-west1-a"
```

## Notes

- This example uses Python's built-in HTTP server on the backend instead of installing `nginx`.
- That choice keeps the demo lightweight and avoids failures in environments where the VM does not have outbound internet access.
- Some projects restrict allowed regions with organization policies, so adjust `region` and `zone` if needed.

## Cleanup

Destroy the resources with:

```bash
terraform destroy
```
