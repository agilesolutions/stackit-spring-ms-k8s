# STACKIT SpringBoot MicroServices referentie project
Ter evaluatie van E2E ontwikkeling, deployment en provisionering van enterprise SpringBoot applicaties op STACKIT SKE Kubernetes Engine. 
Het accent ligt op de volgende punten.
1. Ondersteunen van Secrets, Faults, Configuration management en hoe dat te intergreren in SB applicaties, faciliteiten als feature flagging. Soortgelijke ondersteuning als Azure Spring cloud starters voor app configuration.
- STACKIT Secrets Manager is onder de motorkap gebaseerd op HashiCorp Vault. Azure Key Vault maakt gebruik van specifieke Azure-SDK's, terwijl STACKIT Vault-compatibele clients vereist.
- Directe equivalent voor Azure App Configuration op STACKIT is STACKIT Argus. Een ander veelgebruikt cloud-native alternatief binnen het STACKIT-ecosysteem (specifiek wanneer u STACKIT Kubernetes Engine (SKE) gebruikt) is het combineren van Kubernetes ConfigMaps met de STACKIT Secrets Manager.
Spring Boot koppening Azure is azure-spring-cloud-starter-appconfiguration-config. Voor STACKIT kan dat zijn spring-cloud-starter-config OF spring-cloud-starter-kubernetes-client-config. Dit project zal dat uitwijzen.
2. Ondersteuning OIDC flows, client credential, equivalent MS Extra ID/AD d.m.v. Keycloak OIDC authentication provider.
3. Observability, gelijk Azure loganalitics and monitoring. STACKIT provisioning LGTM Grafana stack provisioned met Terraform en FluxCD.
4. Deployment en GITOPS provisioning met FluxCD.
5. etc... meer nog te speciferen.
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
