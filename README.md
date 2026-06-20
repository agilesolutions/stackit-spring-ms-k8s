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

<img title="Architecture" alt="Alt text" src="/docus/diagrams/stackit_ske_springboot_architecture.png" width="800">

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

De drie services werken als volgt samen: citizen-service is de publieke ingang met OIDC authorization code flow voor de eindgebruiker — het valideert de JWT van Keycloak en stuurt requests door. case-service is de orchestrerende gateway die via client credentials een eigen service-token ophaalt bij Keycloak voordat hij permit-service aanroept. permit-service is de beveiligde database-service die eveneens een inkomende client credentials JWT verwacht en verder niets naar buiten bloot stelt.

<img title="Use Case" alt="Alt text" src="/docus/diagrams/three_service_oauth2_architecture.png" width="800">



## Project structure
```
springboot-stackit-reference/
├── app/                              # SpringBoot applicatie
│   ├── src/main/java/com/example/
│   │   ├── api/                      # REST controllers + OpenAPI
│   │   ├── domain/                   # Entities, repositories (JPA)
│   │   ├── service/                  # Business logic
│   │   ├── security/                 # OAuth2/JWT configuratie
│   │   └── config/                   # App configuratie beans
│   ├── src/main/resources/
│   │   ├── application.yml
│   │   └── db/migration/             # Flyway scripts (V1__init.sql, …)
│   └── Dockerfile
│
├── helm/                             # Helm chart voor deployment
│   ├── Chart.yaml
│   ├── values.yaml
│   ├── values-prod.yaml
│   └── templates/
│       ├── deployment.yaml
│       ├── service.yaml
│       ├── ingress.yaml
│       ├── configmap.yaml
│       ├── secret.yaml
│       ├── hpa.yaml
│       └── servicemonitor.yaml       # Prometheus scraping
│
├── terraform/                        # STACKIT SKE provisioning
│   ├── main.tf                       # SKE cluster definitie
│   ├── nodepool.tf
│   ├── networking.tf                 # VPC, subnets, DNS
│   ├── variables.tf
│   └── outputs.tf
│
├── k8s/                              # Observability stack
│   ├── prometheus/
│   ├── grafana/
│   └── loki/
│
├── .github/workflows/               # CI/CD pipeline
│   ├── build.yml
│   ├── deploy.yml
│   └── e2e.yml
│
└── docs/
    ├── architecture.md
    └── runbook.md
```
## Layered structure
1. SpringBoot App
Spring Boot 4.x met Java 25. REST API gedocumenteerd via SpringDoc OpenAPI (Swagger UI). Domeinmodel met JPA/Hibernate, Flyway voor schema-migraties. Spring Security geconfigureerd als OAuth2 Resource Server die JWT tokens van Keycloak valideert.
2. Security — Keycloak op SKE
Keycloak draait als eigen Deployment in het cluster. De SpringBoot app valideert tokens via de spring-security-oauth2-resource-server dependency met de Keycloak JWKS endpoint als issuer-uri.
3. Observability
Micrometer + Prometheus actuator endpoint in de app. Prometheus scrapt via een ServiceMonitor (Prometheus Operator). Grafana dashboards voor JVM metrics, request rates en latency. Loki voor gestructureerde log-aggregatie via Promtail.
4. Helm chart
Alle Kubernetes resources parametriseerbaar via values.yaml. Secrets komen uit Kubernetes Secrets (of externe vault). HPA op CPU/memory voor auto-scaling. 
5. Terraform — STACKIT SKE
SKE cluster provisioning via de officiële STACKIT Terraform provider. Nodepool configuratie, VPC/subnet, LoadBalancer service voor de Ingress controller.
6. CI/CD
GitHub Actions (of GitLab CI) pipeline: Maven build + unit tests → Docker image bouwen en pushen naar STACKIT Container Registry → Helm upgrade op het SKE cluster → integratietests.
## Deploy
terraform apply
flux bootstrap
