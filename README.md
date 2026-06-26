# STACKIT SpringBoot MicroServices referentie project
Ter evaluatie van E2E ontwikkeling, deployment en provisionering van enterprise SpringBoot applicaties op STACKIT SKE Kubernetes Engine.
Terraform bouwt STACKIT op, FluxCD beheert de volledige Kubernetes-configuratie en Spring Boot microservices worden volledig GitOps-gedreven uitgerold.

## Waarom STACKIT
In 2026 hebben KPN en STACKIT (onderdeel van Schwarz Digits) een samenwerking aangekondigd waarbij STACKIT-cloudservices vanuit Nederlandse KPN-datacenters worden aangeboden.
Deze samenwerking biedt een aantrekkelijk alternatief voor Azure Spring Cloud, met voordelen zoals:
- Lagere kosten en transparante prijsmodellen.
- Volledige datalocatie binnen Nederland, wat kan helpen bij compliance met lokale regelgeving.
- Toegang tot een breed scala aan STACKIT-services, zoals STACKIT Secrets Manager, STACKIT Argus, en STACKIT Kubernetes Engine, die naadloos integreren met de SpringBoot applicatie.
- Ondersteuning voor moderne cloud-native architecturen en DevOps-praktijken, inclusief GitOps provisioning met FluxCD, Infrastructure as Code (IaC) met Terraform, en CI/CD pipelines met GitLab CI/CD.

## Doelgroep
- Nederlandse overheden
- Gemeenten
- Provincies
- Zorginstellingen
- Financiële instellingen
- Vitale infrastructuur

De Nederlandse rijksoverheid heeft STACKIT bovendien geselecteerd als een Europees cloudalternatief binnen een raamovereenkomst.


## Doelstelling dit referentie project
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

- Spring Boot 4/ Spring Framework 6 / Java 25
- Gradle multi-module
- OIDC (Keycloak-ready)
- Kubernetes (STACKIT SKE)
- FluxCD GitOps
- Terraform IaC
- GitLab CI/CD

## Op basis van een simple Use Case - Digitaal Vergunningenportaal
Dit is een herkenbare use case voor gemeenten. Een digitaal vergunningenportaal waar burgers en bedrijven online vergunningen kunnen aanvragen, inzien en beheren. De applicatie bestaat uit 2 microservices:
1. Vergunning service: Behandelt de core business logica rondom vergunningen, inclusief aanvraagverwerking, statusbeheer en communicatie met tweede Microservice.
2. Zakenregister service: Exposeert een API voor het beheren van zaken (vergunningaanvragen) en fungeert als een client van de Vergunning service. Deze service is ook verantwoordelijk voor genereren van Zaaknummer, registrerenen en status beheer.
3. Keycloak: De Identity Provider (IdP) die draait op het STACKIT SKE cluster. Keycloak beheert gebruikers, rollen en clientconfiguraties. De Zaakregistratie service is geconfigureerd als een OAuth2 Resource Server die JWT tokens valideert, terwijl de Vergunning service fungeert als een OAuth2 Client die tokens aanvraagt bij Keycloak voor authenticatie en autorisatie. 
4. STACKIT SKE: De Kubernetes Engine waarop alle services draaien. De applicatie wordt gecontaineriseerd met Docker en gedeployed als Kubernetes Deployments. Ingress controllers worden gebruikt voor externe toegang, en ConfigMaps/Secrets voor configuratiebeheer. Horizontal Pod Autoscaling (HPA) is ingesteld op basis van CPU/memory metrics.
5. Observability stack: Prometheus voor metrics scraping, Grafana voor dashboarding, en Loki voor log-aggregatie. De Spring Boot applicaties exposen actuator endpoints voor metrics en health checks, die worden gescraped door Prometheus. Grafana dashboards bieden inzicht in de performance en gezondheid van de services, terwijl Loki gestructureerde logs verzamelt voor troubleshooting en monitoring.
6. Helm chart: Alle Kubernetes resources worden beheerd via een Helm chart, inclusief Deployments, Services, Ingress, ConfigMaps, Secrets en HPA. De chart is parametriseerbaar via values.yaml, waardoor het eenvoudig is om verschillende omgevingen (development, staging, production) te ondersteunen.
7. Terraform: De infrastructuur voor het STACKIT SKE cluster wordt geprovisioned via Terraform, inclusief de cluster zelf, nodepools, VPC, subnets en LoadBalancer services. Terraform zorgt voor een herhaalbare en consistente provisioning van de benodigde infrastructuur resources.
8. CI/CD pipeline: GitLab CI/CD pipeline die de volgende stappen omvat: Maven build en unit tests → Docker image bouwen en pushen naar STACKIT Container Registry → Helm upgrade op het SKE cluster → integratietests. Deze pipeline zorgt voor een geautomatiseerde en gestroomlijnde deployment van de applicatie naar het STACKIT SKE cluster, met ingebouwde kwaliteitschecks en rollback mogelijkheden.
9. Security: Keycloak is geconfigureerd met de juiste realm, clients, en gebruikers/rollen om zowel de Vergunning service als de Zakenregister service te beveiligen. De Vergunning service valideert JWT tokens die door Keycloak worden uitgegeven, terwijl de Zakenregister service tokens aanvraagt bij Keycloak om toegang te krijgen tot beveiligde endpoints van de Vergunning service. Deze setup zorgt voor een veilige communicatie tussen de services en een robuuste authenticatie- en autorisatie flow.
9. Observability: De applicatie is instrumented met Micrometer, waardoor belangrijke metrics zoals request rates, latency, en JVM performance worden verzameld. Prometheus scrapt deze metrics via een ServiceMonitor, en Grafana dashboards bieden inzicht in de gezondheid en performance van de services. Loki verzamelt gestructureerde logs voor troubleshooting en monitoring, waardoor een volledig observability stack is opgezet voor de applicatie.
10. GitOps provisioning: FluxCD wordt gebruikt voor het beheren van de Kubernetes resources via GitOps. Alle Kubernetes manifests worden opgeslagen in een Git repository, en FluxCD zorgt voor een automatische synchronisatie van deze resources naar het STACKIT SKE cluster. Dit zorgt voor een declaratieve en versiebeheerbare aanpak voor het beheren van de infrastructuur en applicatie resources.

## Workflow
```
Burger
|
POST /vergunningen
|
Vergunning Service
|
OIDC Client Credentials
|
POST /zaken
|
Zakenregistratie Service
|
PostgreSQL
```

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
## observability stack op STACKIT
Volledige observability stack uitgerold d.m.v. 4 Terraform modules, zie sources...

```
modules/
│
├── kube-prometheus-stack
│
├── loki
│
├── tempo
│
└── opentelemetry
```
Equivalenten voor wat je normaliter aantreft in Azure clusters, ja ik roep maar wat (-;

```
| Azure Monitor Stack  | STACKIT/Kubernetes Stack |
| -------------------- | ------------------------ |
| Azure Monitor        | Prometheus               |
| Application Insights | OpenTelemetry            |
| Log Analytics        | Loki                     |
| Distributed Tracing  | Tempo                    |
| Workbooks            | Grafana Dashboards       |
| Azure AD             | Keycloak                 |
| Azure Monitor Alerts | AlertManager             |
| Managed Grafana      | Grafana Helm             |

```


## GITOPS - manage applicaties met FluxCD.
[Central idea is to show how to use GitOps](./docus/GitOps.md) (FluxCD) to manage the deployment of a microservices application on Kubernetes.
1. How to bootstrap FluxCD in your Kubernetes cluster:
```
flux bootstrap github --owner=agilesolutions --repository=stackit-spring-ms-k8s --branch=master --path=clusters/dev --personal
```
Read full instructions in [docus/fluxcd.md](./docus/fluxcd.md)

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
