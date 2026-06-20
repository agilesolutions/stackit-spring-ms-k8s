# STACKIT SpringBoot MicroServices referentie project
Ter evaluatie van E2E ontwikkeling, deployment en provisionering van enterprise SpringBoot applicaties op STACKIT SKE Kubernetes Engine.

Het uitgangspunt is het migreren van een bestaand Azure Spring Cloud referentie project naar STACKIT SKE, waarbij we de volgende aspecten in ogenschouw nemen:
- Applicatie architectuur en code migratie van Azure Spring Cloud naar STACKIT SKE.
- Integratie van STACKIT-specifieke services en faciliteiten, zoals STACKIT Secrets Manager, STACKIT Argus, en STACKIT Kubernetes Engine.
- Ondersteuning van OIDC flows en client credential flows met Keycloak als OIDC authentication provider.
- Implementatie van observability en monitoring oplossingen vergelijkbaar met Azure Log Analytics, gebruikmakend van de LGTM Grafana stack op STACKIT.
- Deployment en GitOps provisioning met FluxCD.
- Infrastructure as Code (IaC) provisioning met Terraform.
- CI/CD pipelines met GitLab CI/CD.

Production-grade cloud-native reference architecture:

- Spring Boot 4/ Spring Framework 6 / Java 24
- Gradle multi-module
- OIDC (Keycloak-ready)
- Kubernetes (STACKIT SKE)
- FluxCD GitOps
- Terraform IaC
- GitLab CI/CD

## Services
- citizen-service
- permit-service
- case-service
- gateway

## Security
OIDC JWT validation via Keycloak realm.

## Deploy
terraform apply
flux bootstrap
