# Workload Resilience Strategie

## Inleiding

Een moderne Kubernetes-applicatie moet bestand zijn tegen verstoringen zoals pod-crashes, node-uitval, rolling updates en onderhoud aan het cluster. Kubernetes biedt hiervoor verschillende mechanismen waarmee de beschikbaarheid van workloads zoveel mogelijk gewaarborgd blijft.

Binnen dit referentieplatform wordt een combinatie van Kubernetes best practices toegepast om een hoge beschikbaarheid (High Availability), automatische self-healing en zero-downtime deployments te realiseren.

---

# Doelstellingen

De workload resilience strategie is gebaseerd op de volgende uitgangspunten:

- Hoge beschikbaarheid van applicaties
- Automatisch herstel bij storingen
- Zero-downtime deployments
- Gelijke spreiding van workloads
- Veilige cluster upgrades
- Gecontroleerde onderhoudswerkzaamheden
- Optimale benutting van cluster resources

---

# Replica's

Iedere bedrijfskritische Spring Boot service draait minimaal met twee replicas.

```yaml
spec:
  replicas: 2
```

Hierdoor blijft de applicatie beschikbaar wanneer een Pod of Node uitvalt.

Voordelen:

- automatische failover
- rolling updates zonder downtime
- hogere beschikbaarheid

---

# Rolling Updates

Deployments maken gebruik van Rolling Updates.

```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxUnavailable: 0
    maxSurge: 1
```

Hiermee wordt eerst een nieuwe Pod gestart voordat een oude Pod wordt verwijderd. Hierdoor blijft de applicatie gedurende een deployment beschikbaar.

---

# Health Probes

Iedere Spring Boot service beschikt over drie soorten health checks.

## Startup Probe

Controleert of de applicatie volledig is opgestart voordat Kubernetes verdere controles uitvoert.

Voorkomt onnodige herstarts van langzaam opstartende applicaties.

## Readiness Probe

Geeft aan of een Pod daadwerkelijk verzoeken kan verwerken.

Wanneer de readiness probe faalt wordt de Pod automatisch uit de Service verwijderd totdat deze weer gezond is.

## Liveness Probe

Controleert of de applicatie nog correct functioneert.

Wanneer een Pod vastloopt zal Kubernetes deze automatisch opnieuw starten.

---

# PodDisruptionBudget (PDB)

Een PodDisruptionBudget voorkomt dat tijdens gepland onderhoud te veel Pods tegelijkertijd worden beëindigd.

Voorbeeld:

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
spec:
  minAvailable: 1
```

Hiermee blijft altijd minimaal één Pod beschikbaar tijdens:

- node upgrades
- cluster onderhoud
- drain commando's
- rolling updates

Een PDB beschermt uitsluitend tegen vrijwillige verstoringen. Bij een onverwachte node-uitval grijpt Kubernetes automatisch in via ReplicaSets.

---

# Topology Spread Constraints

Topology Spread Constraints zorgen ervoor dat Pods zo gelijkmatig mogelijk over de beschikbare worker nodes worden verdeeld.

Voorbeeld:

```yaml
topologySpreadConstraints:
- maxSkew: 1
  topologyKey: kubernetes.io/hostname
  whenUnsatisfiable: DoNotSchedule
```

Hierdoor worden Pods niet allemaal op dezelfde worker node geplaatst.

Voordelen:

- betere belastingverdeling
- hogere beschikbaarheid
- minder impact bij node-uitval
- betere schaalbaarheid

---

# Pod Anti Affinity

Pod Anti Affinity voorkomt dat meerdere replicas van dezelfde applicatie op dezelfde worker node terechtkomen.

Voorbeeld:

```yaml
podAntiAffinity:
  preferredDuringSchedulingIgnoredDuringExecution:
```

Hierdoor wordt het risico verkleind dat meerdere replicas tegelijk verloren gaan.

---

# Resource Requests en Limits

Iedere workload definieert CPU- en geheugenreserveringen.

```yaml
resources:
  requests:
    cpu: 250m
    memory: 512Mi
  limits:
    cpu: 1000m
    memory: 1Gi
```

Hiermee krijgt Kubernetes voldoende informatie om Pods efficiënt te plannen en wordt voorkomen dat één applicatie alle beschikbare resources gebruikt.

---

# Graceful Shutdown

Spring Boot ondersteunt gecontroleerd afsluiten van applicaties.

```properties
server.shutdown=graceful
spring.lifecycle.timeout-per-shutdown-phase=30s
```

Daarnaast gebruikt Kubernetes een voldoende lange `terminationGracePeriodSeconds`, zodat lopende verzoeken netjes kunnen worden afgerond voordat een Pod wordt beëindigd.

---

# Self-Healing

Kubernetes beschikt standaard over uitgebreide self-healing functionaliteit.

Wanneer zich één van onderstaande situaties voordoet zal Kubernetes automatisch herstelacties uitvoeren.

| Situatie | Automatisch herstel |
|----------|---------------------|
| Pod crasht | ReplicaSet start nieuwe Pod |
| Applicatie loopt vast | Liveness Probe herstart Pod |
| Node valt uit | Pods worden opnieuw ingepland |
| Deployment | Rolling Update |
| Pod niet beschikbaar | Readiness verwijdert Pod uit Service |

---

# Monitoring

De gezondheid van workloads wordt continu bewaakt met:

- Spring Boot Actuator
- Micrometer
- Prometheus
- Grafana
- OpenTelemetry
- Loki
- Tempo

Hiermee kunnen problemen vroegtijdig worden gedetecteerd en geanalyseerd.

---

# Best Practices

Binnen dit referentieplatform worden de volgende Kubernetes best practices toegepast:

- minimaal twee replicas
- Rolling Updates
- Startup Probe
- Readiness Probe
- Liveness Probe
- PodDisruptionBudget
- Topology Spread Constraints
- Pod Anti Affinity
- Resource Requests
- Resource Limits
- GitOps met FluxCD
- Infrastructure as Code met Terraform
- Continue monitoring en observability

---

# Conclusie

Door ReplicaSets, Rolling Updates, Health Probes, PodDisruptionBudgets, Topology Spread Constraints en Pod Anti Affinity te combineren ontstaat een robuuste en veerkrachtige Kubernetes-omgeving. Deze strategie zorgt ervoor dat applicaties beschikbaar blijven tijdens onderhoud, deployments en onverwachte storingen, terwijl Kubernetes automatisch herstelacties uitvoert waar mogelijk.

Deze aanpak sluit aan bij de Cloud Native principes en vormt een solide basis voor productieomgevingen op STACKIT SKE.