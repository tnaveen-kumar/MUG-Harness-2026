# Managing MongoDB Atlas with Terraform

Demo code from the **MongoDB User Group Bengaluru** meetup in collaboration with **Harness**.

📅 [Event Link](https://www.meetup.com/mongodb-usergroup-bengaluru/events/314441569/?eventOrigin=home_next_event_you_are_attending)

This repo walks through three progressive demos of managing MongoDB Atlas infrastructure using the [MongoDB Atlas Terraform Provider](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs).

---

## Demos

### 01 — Setup a Free Tier Cluster

**Folder:** `01-SetupCluster/`

Provisions a complete MongoDB Atlas setup from scratch:

- Creates a new Atlas **Project**
- Deploys a free tier **M0 cluster** on AWS `us-east-1` (Replica Set)
- Creates a **database user** with `readWrite` role
- Configures an **IP Access List** entry

This is the baseline demo — everything you need to get a cluster up and running with Terraform.

---

### 02 — Cluster with HashiCorp Vault Integration

**Folder:** `02-Cluster-VaultIntegration/`

Builds on demo 01 by removing hardcoded credentials. Database username and password are pulled from **HashiCorp Vault** (KV v2 secrets engine) at apply time.

- Uses the `vault` Terraform provider to read secrets from `secret/demo`
- MongoDB Atlas credentials are never stored in `.tfvars` or state in plaintext
- Vault is expected to be running locally at `http://127.0.0.1:8200`

This demo highlights a practical secrets management pattern for production-like setups.

---

### 03 — Dedicated Cluster with Auto Scaling

**Folder:** `03_DedicatedCluster_AutoScaling/`

Provisions a **dedicated M10 cluster** on AWS `ap-south-1` with compute auto scaling enabled.

- MongoDB 7.0, 3-node Replica Set
- Auto scaling configured between **M10** and **M20**
- Scale-down enabled to optimize costs
- Same project/user/IP access list pattern as demo 01

This demo shows how to move beyond free tier and configure production-ready clusters with dynamic sizing.

---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.x
- A [MongoDB Atlas](https://www.mongodb.com/cloud/atlas) account with an Organization
- A MongoDB Atlas [Service Account](https://www.mongodb.com/docs/atlas/api/service-accounts-overview/) (client ID + secret)
- For demo 02: A running [HashiCorp Vault](https://developer.hashicorp.com/vault/install) instance with a KV v2 secret at `secret/demo` containing `username` and `password` keys

---

## Usage

Each demo is an independent Terraform module. Navigate into the folder and run the standard Terraform workflow.

```bash
cd 01-SetupCluster   # or 02-Cluster-VaultIntegration / 03_DedicatedCluster_AutoScaling

terraform init
terraform plan
terraform apply
```

### Configuring Variables

Each module has a `terraform.tfvars` file. Update it with your own values before running:

```hcl
mongodbatlas_client_id     = "<your-service-account-client-id>"
mongodbatlas_client_secret = "<your-service-account-client-secret>"
org_id                     = "<your-atlas-org-id>"
project_name               = "<your-project-name>"
cluster_name               = "<your-cluster-name>"
db_username                = "appuser"
db_password                = "<a-strong-password>"
```

For demo 02, also provide your Vault token:

```hcl
vault_token = "<your-vault-token>"
```

> **Never commit real credentials to version control.** Add `terraform.tfvars` to your `.gitignore` or use environment variables / a secrets manager instead.

---

## Security Notes

- `mongodbatlas_client_secret`, `db_password`, and `vault_token` are all marked `sensitive = true` in the variable definitions — Terraform will redact them from plan/apply output.
- For production use, consider storing secrets in Vault (as shown in demo 02) or using Terraform Cloud's variable store.
- The `ip_address` variable defaults to `0.0.0.0/0` for demo convenience. Restrict this to your actual IP range in any real environment.

---

## Provider

All modules use the official MongoDB Atlas Terraform provider:

```hcl
source  = "mongodb/mongodbatlas"
version = "2.11.0"
```

---

## Resources

- [MongoDB Atlas Terraform Provider Docs](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs)
- [MongoDB Atlas Free Tier](https://www.mongodb.com/cloud/atlas/register)
- [HashiCorp Vault KV Secrets Engine](https://developer.hashicorp.com/vault/docs/secrets/kv/kv-v2)
- [MongoDB User Group Bengaluru](https://www.meetup.com/mongodb-usergroup-bengaluru/)
