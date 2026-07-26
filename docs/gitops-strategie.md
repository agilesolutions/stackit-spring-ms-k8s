# Strategie
Terraform provisioneert de infrastructuur en bootstrapt FluxCD. FluxCD wordt de Kubernetes Control Plane voor Platform Services en Applications. FluxCD beheert de declaratieve configuratie van de Kubernetes resources via GitOps.
```
Terraform
    │
    ├── STACKIT SKE
    ├── GitHub
    └── FluxCD bootstrap
            │
            ▼
          FluxCD
            │
            ▼
     HelmRepositories
            │
            ▼
       HelmReleases
            │
            ├── KEDA
            ├── Traefik
            ├── cert-manager
            └── Keycloak
                    │
                    ▼
              Applications
```
