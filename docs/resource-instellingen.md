# Resource Instellingen Spring Boot Services

Deze pagina bevat praktische richtlijnen voor het configureren van **CPU Requests**, **CPU Limits**, **Memory Requests** en **Memory Limits** voor Spring Boot applicaties die draaien op Kubernetes.

De waarden zijn bedoeld als **uitgangspunt** voor Java 21+/25, Spring Boot 3.x/4.x, Actuator, Micrometer en REST API's. Na deployment dienen deze instellingen geoptimaliseerd te worden op basis van daadwerkelijke metingen met bijvoorbeeld **Prometheus**, **Grafana** of **Vertical Pod Autoscaler (VPA)**.
---

### Aanbevolen Resource Instellingen voor Spring Boot Services

| Type Service | CPU Request | CPU Limit | Memory Request | Memory Limit | QoS | Typisch Aantal Replica's | Opmerkingen |
|--------------|------------:|----------:|---------------:|-------------:|-----|-------------------------:|-------------|
| Kleine REST API | 100m | 500m | 256Mi | 512Mi | Burstable | 1-2 | Eenvoudige CRUD-service met weinig verkeer |
| Standaard Spring Boot Microservice | 250m | 750m | 512Mi | 1Gi | Burstable | 2-3 | Aanbevolen standaard voor de meeste business services |
| Bedrijfskritische API | 500m | 1 CPU | 1Gi | 2Gi | Burstable | 2-4 | Voor hogere belasting en lagere responstijden |
| Reactive WebFlux Service | 250m | 1 CPU | 512Mi | 1Gi | Burstable | 2-4 | Geschikt voor veel gelijktijdige verbindingen |
| GraphQL API | 500m | 1 CPU | 1Gi | 2Gi | Burstable | 2-3 | GraphQL-query's zijn vaak CPU-intensiever |
| Batch Processing Service | 500m | 2 CPU | 1Gi | 2Gi | Burstable | 1 | CPU-intensieve achtergrondverwerking |
| Kafka Consumer | 500m | 2 CPU | 1Gi | 2Gi | Burstable | Afhankelijk van partitions | Opschalen op basis van Kafka-partities |
| Kafka Producer | 250m | 1 CPU | 512Mi | 1Gi | Burstable | 2 | Meestal minder zwaar dan consumers |
| Scheduled Job (CronJob) | 250m | 1 CPU | 512Mi | 1Gi | Burstable | Op aanvraag | Draait alleen tijdens geplande uitvoering |
| Spring Cloud Gateway | 500m | 2 CPU | 512Mi | 1Gi | Burstable | 2-4 | API Gateway met veel gelijktijdige requests |
| Spring Authorization Server | 500m | 2 CPU | 1Gi | 2Gi | Burstable | 2-3 | OAuth2- en authenticatieserver |

---

### Aanbevolen Instellingen voor Platform Componenten

Voor een referentieplatform met **FluxCD**, **Traefik**, **Keycloak**, **Spring Boot**, **PostgreSQL** en de **LGTM-stack** zijn onderstaande instellingen een goed uitgangspunt.

| Component | CPU Request | CPU Limit | Memory Request | Memory Limit |
|-----------|------------:|----------:|---------------:|-------------:|
| Traefik | 100m | 500m | 128Mi | 512Mi |
| Keycloak | 500m | 2 CPU | 1Gi | 2Gi |
| PostgreSQL | 500m | 2 CPU | 1Gi | 2Gi |
| cert-manager | 100m | 250m | 128Mi | 256Mi |
| External Secrets Operator | 100m | 250m | 128Mi | 256Mi |
| Prometheus | 500m | 2 CPU | 2Gi | 4Gi |
| Grafana | 250m | 1 CPU | 512Mi | 1Gi |
| Loki | 500m | 2 CPU | 1Gi | 2Gi |
| Tempo | 500m | 2 CPU | 1Gi | 2Gi |
| OpenTelemetry Collector | 200m | 1 CPU | 256Mi | 512Mi |
| Spring Boot Business Service | **250m** | **750m** | **512Mi** | **1Gi** |

---

### Aanbevolen Configuratie voor vergunning-service

Voor de **vergunning-service** wordt de volgende configuratie aanbevolen.

| Instelling | Waarde |
|------------|--------:|
| CPU Request | **250m** |
| CPU Limit | **750m** |
| Memory Request | **512Mi** |
| Memory Limit | **1Gi** |
| Kubernetes QoS Klasse | **Burstable** |
| Aantal Replica's (Productie) | **2** |
| Aantal Replica's (Docker Desktop) | **1** |
| HPA CPU Target | **70%** |
| HPA Minimum Replica's | **2** (Productie) / **1** (Lokaal) |
| HPA Maximum Replica's | **5-10** |

Deze configuratie biedt een goede balans tussen:

- voorspelbare scheduling
- voldoende JVM-geheugen tijdens startup
- ruimte voor tijdelijke piekbelasting
- efficiënt gebruik van clusterresources

---

### Waarom Burstable?

De meeste Spring Boot applicaties hebben tijdens startup aanzienlijk meer CPU en geheugen nodig dan tijdens normaal gebruik.

Daarom wordt meestal gekozen voor:

- **Requests** die overeenkomen met het gemiddelde resourcegebruik.
- **Limits** die voldoende ruimte bieden voor tijdelijke pieken.

Voorbeeld:

```yaml
resources:
  requests:
    cpu: 250m
    memory: 512Mi

  limits:
    cpu: 750m
    memory: 1Gi
```

Hierdoor reserveert Kubernetes voldoende resources voor de scheduler, terwijl de applicatie indien nodig tijdelijk extra CPU en geheugen mag gebruiken.

---

# Algemene Best Practices

## Definieer altijd Requests én Limits

Elke productie-workload zou expliciet CPU- en geheugeninstellingen moeten bevatten.

---

## Meet voordat je optimaliseert

Gebruik observability-tools zoals:

- Prometheus
- Grafana
- Micrometer
- OpenTelemetry
- Vertical Pod Autoscaler (VPA)

om het daadwerkelijke resourcegebruik te analyseren.

---

## Houd Requests realistisch

Een te hoge **Request** leidt tot:

- slechtere clusterbenutting
- minder Pods per Node
- hogere infrastructuurkosten

---

## Houd Limits ruim genoeg

Een te lage **Memory Limit** vergroot de kans op:

- Out Of Memory (OOM) kills
- herstartende Pods
- instabiele applicaties

---

## Gebruik Horizontal Pod Autoscaler

Schaal bij voorkeur horizontaal door extra replica's toe te voegen in plaats van één Pod steeds groter te maken.

Typische instellingen:

- Minimum Replica's: **2**
- Maximum Replica's: **5-10**
- CPU Target: **70%**

---

## Gebruik verschillende instellingen per omgeving

Pas resources aan op basis van de omgeving.

| Omgeving | CPU Request | Memory Request | CPU Limit | Memory Limit |
|-----------|------------:|---------------:|----------:|-------------:|
| Docker Desktop | 250m | 512Mi | 750m | 1Gi |
| Ontwikkeling | 250m | 512Mi | 1 CPU | 1Gi |
| Test | 500m | 1Gi | 1 CPU | 2Gi |
| Acceptatie | 500m | 1Gi | 2 CPU | 2Gi |
| Productie | 1 CPU | 2Gi | 2 CPU | 4Gi |

Met **Kustomize-overlays** of **Helm values** kunnen deze instellingen eenvoudig per omgeving worden beheerd.

---

## Samenvatting

Voor de meeste Spring Boot microservices is onderstaande configuratie een uitstekend uitgangspunt.

| Eigenschap | Aanbevolen Waarde |
|------------|------------------:|
| CPU Request | **250m** |
| CPU Limit | **750m** |
| Memory Request | **512Mi** |
| Memory Limit | **1Gi** |
| QoS Klasse | **Burstable** |
| Replica's (Productie) | **2** |
| Replica's (Lokaal) | **1** |
| HPA CPU Target | **70%** |

Door Requests, Limits, HPA, ResourceQuota en LimitRange samen toe te passen ontstaat een Kubernetes-platform dat:

- efficiënt gebruikmaakt van resources;
- stabiel blijft onder belasting;
- eenvoudig kan opschalen;
- kosten beheersbaar houdt;
- en geschikt is voor zowel lokale ontwikkeling als productieomgevingen.