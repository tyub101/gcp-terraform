# Lean GCP HTTP Load Balancer with Terraform

This repository contains a lean, production-style example of an external Google Cloud HTTP load balancer built with Terraform.

The project was created as a step-by-step learning exercise, but the final structure is professional enough to use as a reference for:

- Terraform project layout
- Google Cloud provider configuration
- External HTTP load balancer components
- Backend health checks
- Troubleshooting regional policy constraints and backend readiness

## Architecture

The Terraform in `lb/` creates:

- A custom VPC
- A custom subnet
- A firewall rule allowing Google health check ranges to reach the backend on port `80`
- A backend VM in Compute Engine
- An unmanaged instance group with a named port
- An HTTP health check
- A backend service
- A URL map
- A target HTTP proxy
- A reserved global IP address
- A global forwarding rule

The backend serves a simple static HTML page using Python's built-in HTTP server, which keeps the demo lightweight and avoids package installation dependencies.

## Repository Structure

```text
.
├── README.md
└── lb
    ├── main.tf
    ├── outputs.tf
    ├── provider.tf
    ├── terraform.tfvars.example
    ├── variables.tf
    └── versions.tf
```

## Prerequisites

- Terraform `>= 1.5`
- A Google Cloud project
- Application Default Credentials configured with:

```bash
gcloud auth application-default login
```

## Usage

1. Move into the Terraform directory:

```bash
cd lb
```

2. Copy the example variables file and adjust values:

```bash
cp terraform.tfvars.example terraform.tfvars
```

3. Initialize Terraform:

```bash
terraform init
```

4. Review the execution plan:

```bash
terraform plan
```

5. Apply the infrastructure:

```bash
terraform apply
```

6. Retrieve the public IP:

```bash
terraform output load_balancer_ip
```

7. Test the load balancer:

```bash
curl http://$(terraform output -raw load_balancer_ip)
```

## Example Variables

Example values:

```hcl
project_id = "your-gcp-project-id"
region     = "us-west1"
zone       = "us-west1-a"
```

## Notes

- Some lab or enterprise projects restrict allowed regions with `constraints/gcp.resourceLocations`.
- If your backend VM does not have outbound internet access, package-based startup scripts may fail.
- This demo intentionally uses a simple Python HTTP server to keep the backend self-contained.

## Cleanup

Destroy all created resources with:

```bash
cd lb
terraform destroy
```

## What This Project Demonstrates

- How Google Cloud load balancer resources connect together
- How Terraform state behaves during partial applies and recovery
- How to verify backend health from both Terraform and Google Cloud
- How to debug startup scripts and unhealthy backends methodically
