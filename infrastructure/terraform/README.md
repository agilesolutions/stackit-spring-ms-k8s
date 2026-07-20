# Overview

The recommended Terraform strategy is to maintain **one infrastructure codebase** while deploying it into multiple environments by changing only the **configuration**, not the infrastructure implementation.

The infrastructure should be implemented as reusable modules, while each environment (development, testing, QA, staging, production) contains only the configuration required to instantiate those modules.

---

# Recommended Repository Structure

```text
terraform/
├── modules/
│   ├── alloy/
│   ├── cert-manager/
│   ├── external-secrets/
│   ├── fluxcd/
│   ├── ingress-nginx/
│   ├── keycloak/
│   ├── postgresql/
│   ├── ske/
│   └── unleash/
│
└── environments/
    ├── dev/
    │   ├── backend.tf
    │   ├── providers.tf
    │   ├── variables.tf
    │   ├── terraform.tfvars
    │   └── main.tf
    │
    ├── test/
    ├── qa/
    ├── stage/
    └── prod/
```

## Design Principles

* Infrastructure logic exists only once.
* Every reusable component becomes a Terraform module.
* Every environment has its own configuration.
* No duplicated infrastructure code.
* Every environment maintains its own Terraform state.

---

# Reusable Modules

Typical module layout:

```text
modules/
    alloy/
        main.tf
        outputs.tf
        variables.tf

    fluxcd/
    keycloak/
    postgresql/
    ske/
```

Example module invocation:

```terraform
module "alloy" {
    source = "../../modules/alloy"

    namespace   = var.namespace
    loki_url    = var.loki_url
}
```

Modules should represent one logical infrastructure component.

Examples:

* OIDC
* SKE Cluster
* FluxCD GitOps
* PostgreSQL Database
* External Secrets

Avoid creating very large "mega modules."

---

# Environment Configuration

## Development

```terraform
module "alloy" {
    source = "../../modules/ally"

    loki_url = var.loki_url
    tempo_endpoint = var.tempo_endpoint
}

# Variable Files

Example:

```text
variables.tf
terraform.tfvars

dev.tfvars
test.tfvars
qa.tfvars
stage.tfvars
prod.tfvars
```

Example values:

Development

```terraform
environment = "dev"

location = "westeurope"

node_count = 2

vm_size = "Standard_B2s"
```

QA

```terraform
environment = "qa"

location = "westeurope"

node_count = 12

vm_size = "Standard_D8s_v5"
```

Deployment:

```bash
terraform plan -var-file=local.tfvars

terraform apply -var-file=local.tfvars
```

---

# Remote State

Each environment must use its own state.

```text
dev.tfstate
test.tfstate
qa.tfstate
stage.tfstate
prod.tfstate
```

Azure Storage backend example:

```terraform
terraform {

  backend "s3" {
  
      bucket = "terraform-state"

      endpoint = "https://object.storage.eu01.onstackit.cloud"

      region = "eu01"

      key = "dev.tfstate"

      access_key = ...

  }

}
```

Never share Terraform state across environments.

# Initialize the appropriate environment:

```bash
terraform init -backend-config=dev/backend.tf
```




