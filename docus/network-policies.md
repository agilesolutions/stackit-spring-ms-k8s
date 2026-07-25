# pod communication security policy matrix STACKIT Kubernetes Engine (SKE)

Dit document beschrijft de netwerkbeveiliging binnen de STACKIT Kubernetes Engine (SKE) met behulp van standaard Kubernetes `NetworkPolicies`.

## 🚀 Netwerkinfrastructuur in SKE

STACKIT maakt gebruik van **Cilium** als de onderliggende Container Network Interface (CNI). Cilium maakt gebruik van krachtige eBPF-technologie in de Linux-kernel om netwerkverkeer te routeren en te beveiligen.
Omdat Cilium de native Kubernetes-standaarden volledig ondersteunt, werken alle reguliere `NetworkPolicy`-bronnen direct en optimaal, zonder dat je vendor-specifieke software hoeft te installeren.
---

## Basisconcept: DNS Egress Toestaan
Wanneer je een *default-deny* (alles blokkeren) netwerkbeleid invoert voor een namespace, mislukken applicaties vaak omdat ze geen DNS-namen meer kunnen resolven.
Onderstaand manifest is het standaard Kubernetes-netwerkbeleid dat **uitgaand DNS-verkeer (Egress) naar de CoreDNS-pods in de `kube-system` namespace** expliciet toestaat voor alle pods binnen jouw namespace.

### Configuratie (`allow-dns-egress.yaml`)

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-dns-egress
  namespace: services # Alle microservices hosted hier
spec:
  podSelector: {} # {} selecteert ALLE pods in deze namespace
  policyTypes:
    - Egress
  egress:
    - to:
        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: kube-system
      ports:
        - port: 53
          protocol: UDP
        - port: 53
          protocol: TCP
```

### Hoe dit werkt

1. **`podSelector: {}`**: Dit beleid is direct actief voor elke pod binnen de opgegeven namespace.
2. **`policyTypes: [Egress]`**: Activeert de isolatie voor uitgaand verkeer. Al het uitgaande verkeer wordt geblokkeerd, *behalve* wat hieronder staat beschreven.
3. **`kubernetes.io/metadata.name: kube-system`**: Maakt gebruik van het ingebouwde, automatische Kubernetes-label om veilig de `kube-system` namespace te targeten.
4. **`ports 53 (UDP/TCP)`**: Dit opent poort 53, de universele poort voor DNS-aanvragen.

---
## Zero trust, deny all strategy. 
```
| Source                   | Destination              | Port | Allowed |
| ------------------------ | ------------------------ | ---- | ------- |
| Traefik                  | vergunning-service       | 8080 | ✅      |
| vergunning-service       | zakenregistratie-service | 8080 | ✅      |
| vergunning-service       | PostgreSQL               | ❌   |         |
| zakenregistratie-service | PostgreSQL               | 5432 | ✅      |
| vergunning-service       | Keycloak                 | 8443 | ✅      |
| zakenregistratie-service | Keycloak                 | 8443 | ✅      |
```
### Network topology simplified
```
                     Internet
                         │
                  Traefik Ingress
                         │
                         ▼
          vergunning-service (Spring Boot)
                         │
                HTTPS (8080)
                         │
                         ▼
       zakenregistratie-service (Spring Boot)
                         │
                     PostgreSQL
                       (5432)

All services
│
└──────────────► Keycloak (8443)
```