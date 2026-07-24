# workload settings for most common SpringBoot services and PaaS workloads
```
| Workload                 | CPU Request |  CPU Limit | Memory Request | Memory Limit |
| ------------------------ | ----------: | ---------: | -------------: | -----------: |
| Small REST API           |        100m |       500m |          256Mi |        512Mi |
| Spring Boot Microservice |        250m | 750m–1 CPU |          512Mi |          1Gi |
| Keycloak                 |        500m |      2 CPU |            1Gi |          2Gi |
| PostgreSQL               |        500m |      2 CPU |            1Gi |          2Gi |
| Kafka Broker             |       1 CPU |    2–4 CPU |            2Gi |          4Gi |
| Traefik                  |        100m |       500m |          128Mi |        512Mi |
| cert-manager             |        100m |       250m |          128Mi |        256Mi |
| External Secrets         |        100m |       250m |          128Mi |        256Mi |

```
## Spring Boot service
The table below provides practical starting points for typical Spring Boot services. These values assume Java 21+/25, Spring Boot 3.x/4.x, Actuator, Micrometer, and REST APIs. They are intended as initial sizing and should be refined using real monitoring data (Prometheus/Grafana or VPA recommendations).
```
| Service Type                      | CPU Request | CPU Limit | Memory Request | Memory Limit | QoS       |      Typical Replicas | Notes                                            |
| --------------------------------- | ----------: | --------: | -------------: | -----------: | --------- | --------------------: | ------------------------------------------------ |
| Lightweight REST API              |        100m |      500m |          256Mi |        512Mi | Burstable |                   1–2 | Simple CRUD service with low traffic             |
| Standard Spring Boot Microservice |        250m |      750m |          512Mi |          1Gi | Burstable |                   2–3 | Recommended default for most business services   |
| Business-Critical API             |        500m |     1 CPU |            1Gi |          2Gi | Burstable |                   2–4 | Higher throughput and lower latency requirements |
| Reactive WebFlux Service          |        250m |     1 CPU |          512Mi |          1Gi | Burstable |                   2–4 | Better CPU utilization under high concurrency    |
| GraphQL API                       |        500m |     1 CPU |            1Gi |          2Gi | Burstable |                   2–3 | GraphQL queries can be CPU-intensive             |
| Batch Processing Service          |        500m |     2 CPU |            1Gi |          2Gi | Burstable |                     1 | CPU-intensive background processing              |
| Kafka Consumer                    |        500m |     2 CPU |            1Gi |          2Gi | Burstable | Depends on partitions | Scale based on Kafka partitions                  |
| Kafka Producer                    |        250m |     1 CPU |          512Mi |          1Gi | Burstable |                     2 | Usually less resource-intensive than consumers   |
| Scheduled Job (CronJob)           |        250m |     1 CPU |          512Mi |          1Gi | Burstable |             On demand | Runs only during scheduled execution             |
| Spring Cloud Gateway              |        500m |     2 CPU |          512Mi |          1Gi | Burstable |                   2–4 | API Gateway handling many concurrent requests    |
| Spring Authorization Server       |        500m |     2 CPU |            1Gi |          2Gi | Burstable |                   2–3 | Authentication and OAuth2 token issuance         |
```
## SpringBoot basic service
### Memory example
```
requests:
  memory: 512Mi

limits:
  memory: 1Gi
```
### CPU example
```
requests:
  cpu: 250m

limits:
  cpu: 750m
```
