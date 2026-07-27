# Kubernetes DNS, Ingress & Certificate Management Strategy

## Overview

Deze pagina beschrijft de strategie voor automatische:

- DNS hostname resolution
- Kubernetes Ingress routing
- TLS certificaat provisioning
- Let's Encrypt integratie
- DNS lifecycle management
- GitOps gebaseerde networking configuratie

De oplossing is gebaseerd op:

- STACKIT Sovereign Kubernetes Engine (SKE)
- STACKIT DNS
- Terraform
- FluxCD
- Traefik Ingress Controller
- ExternalDNS
- cert-manager
- Let's Encrypt
- Kubernetes Ingress resources

---

# Architecture Overview

De platform architectuur volgt het principe:

> Terraform beheert cloud infrastructuur, FluxCD beheert Kubernetes resources.

```text
                         Internet
                             |
                             |
                       DNS Resolution
                             |
                             |
                 +-----------+-----------+
                 |
                 v

          STACKIT DNS Zone

          overheid.example.nl

                 |
                 |
                 v

     keycloak.apps.overheid.example.nl
     grafana.apps.overheid.example.nl
     vergunning.apps.overheid.example.nl

                 |
                 |
                 v

          STACKIT LoadBalancer

                 |
                 |
                 v

        Traefik Ingress Controller

                 |
                 |
                 v

          Kubernetes Ingress

                 |
                 |
                 v

          Kubernetes Services

                 |
                 |
                 v

                Pods
````

---

# Design Principles

## Infrastructure vs Application Ownership

Een belangrijk uitgangspunt:

| Component        | Managed by         |
| ---------------- | ------------------ |
| STACKIT Project  | Terraform          |
| STACKIT DNS Zone | Terraform          |
| SKE Cluster      | Terraform          |
| Flux Bootstrap   | Terraform          |
| Traefik          | FluxCD             |
| ExternalDNS      | FluxCD             |
| DNS Records      | ExternalDNS        |
| cert-manager     | FluxCD             |
| Certificates     | cert-manager       |
| Applications     | FluxCD HelmRelease |

---

# DNS Strategy

## STACKIT DNS Zone

Terraform beheert alleen de DNS zone.

Voorbeeld:

```hcl
resource "stackit_dns_zone" "platform" {

  project_id = var.project_id

  name = "Platform DNS Zone"

  dns_name = "overheid.example.nl"
}
```

Terraform creëert:

```text
overheid.example.nl
```

---

# Waarom Terraform geen DNS Records beheert

Een traditionele aanpak zou zijn:

```text
Terraform
    |
    |
    +--> Create Kubernetes Cluster
    |
    +--> Install Traefik
    |
    +--> Read LoadBalancer IP
    |
    +--> Create DNS Record
```

Maar in een GitOps architectuur ontstaat een dependency probleem:

```text
Terraform

    |
    |
    v

Flux Bootstrap

    |
    |
    v

Traefik HelmRelease

    |
    |
    v

STACKIT LoadBalancer

    |
    |
    v

External IP
```

Het externe IP bestaat pas nadat Flux Traefik heeft uitgerold.

Daarom:

* Terraform beheert DNS zones
* Kubernetes beheert DNS records via ExternalDNS

---

# ExternalDNS Architecture

ExternalDNS is een Kubernetes controller die automatisch DNS records creëert op basis van Kubernetes resources.

Architectuur:

```text
              Kubernetes API
                    |
                    |
                    v

               ExternalDNS

                    |
                    |
                    v

              STACKIT DNS API

                    |
                    |
                    v

        DNS Records automatisch beheerd
```

---

# ExternalDNS Responsibilities

ExternalDNS:

* monitort Kubernetes Ingress resources
* monitort Services
* leest hostname configuratie
* maakt DNS records
* verwijdert oude records
* houdt DNS state synchroon

---

# Application DNS Convention

Alle applicaties gebruiken een centraal application domain:

```text
apps.overheid.example.nl
```

Voorbeelden:

| Component                | DNS naam                                  |
| ------------------------ | ----------------------------------------- |
| Keycloak                 | keycloak.apps.overheid.example.nl         |
| Grafana                  | grafana.apps.overheid.example.nl          |
| Loki                     | loki.apps.overheid.example.nl             |
| Tempo                    | tempo.apps.overheid.example.nl            |
| Vergunning service       | vergunning.apps.overheid.example.nl       |
| Zakenregistratie service | zakenregistratie.apps.overheid.example.nl |

---

# Ingress Routing Strategy

Traefik is de centrale Kubernetes ingress controller.

Traffic flow:

```text
Client

  |
  |
  v

DNS lookup

  |
  |
  v

STACKIT LoadBalancer

  |
  |
  v

Traefik

  |
  |
  v

Ingress Rule

  |
  |
  v

Service

  |
  |
  v

Pod
```

---

# Traefik Ingress Configuration

Iedere applicatie gebruikt:

```yaml
spec:

  ingressClassName: traefik
```

Voorbeeld:

```yaml
apiVersion: networking.k8s.io/v1

kind: Ingress

metadata:

  name: vergunning-service

  annotations:

    external-dns.alpha.kubernetes.io/hostname:
      vergunning.apps.overheid.example.nl


    cert-manager.io/cluster-issuer:
      letsencrypt-production


spec:

  ingressClassName: traefik


  rules:

    - host:
        vergunning.apps.overheid.example.nl

      http:

        paths:

          - path: /

            pathType: Prefix

            backend:

              service:

                name:
                  vergunning-service

                port:

                  number:
                    8080
```

---

# ExternalDNS Flow

Wanneer een nieuwe Ingress wordt gedeployed:

```text
HelmRelease

      |
      |
      v

Ingress Resource

      |
      |
      v

ExternalDNS detects hostname

      |
      |
      v

STACKIT DNS API

      |
      |
      v

DNS Record created
```

Resultaat:

```text
vergunning.apps.overheid.example.nl

        |

        v

Traefik LoadBalancer IP
```

---

# Certificate Management Strategy

TLS certificaten worden automatisch beheerd door:

* cert-manager
* Let's Encrypt
* Kubernetes Secrets

Architectuur:

```text
Ingress

   |
   |
   v

cert-manager annotation

   |
   |
   v

ClusterIssuer

   |
   |
   v

Let's Encrypt

   |
   |
   v

TLS Secret

   |
   |
   v

Traefik HTTPS
```

---

# cert-manager Deployment

cert-manager wordt via FluxCD geïnstalleerd:

```text
FluxCD

   |

   v

HelmRelease cert-manager

   |

   v

cert-manager controller

   |

   v

Certificate resources
```

---

# ClusterIssuer Configuration

De ClusterIssuer is cluster-wide beschikbaar.

Voorbeeld:

```yaml
apiVersion: cert-manager.io/v1

kind: ClusterIssuer

metadata:

  name: letsencrypt-production


spec:

  acme:

    email:
      platform@example.nl


    server:

      https://acme-v02.api.letsencrypt.org/directory


    privateKeySecretRef:

      name:
        letsencrypt-production


    solvers:

      - http01:

          ingress:

            ingressClassName:

              traefik
```

---

# Certificate Request Flow

Wanneer een Ingress wordt aangemaakt:

```text
Ingress created

      |
      |
      v

cert-manager detects:

cert-manager.io/cluster-issuer

      |
      |
      v

Certificate resource

      |
      |
      v

ACME HTTP01 challenge

      |
      |
      v

Let's Encrypt validation

      |
      |
      v

Certificate issued

      |
      |
      v

TLS Secret created

      |
      |
      v

Traefik serves HTTPS
```

---

# HTTP01 Challenge

Let's Encrypt valideert:

```text
http://application.apps.overheid.example.nl/.well-known/acme-challenge/*
```

Flow:

```text
Let's Encrypt

       |

       v

STACKIT DNS

       |

       v

Traefik

       |

       v

cert-manager solver

       |

       v

Validation successful
```

---

# Helm Chart Strategy

Alle applicaties gebruiken dezelfde ingress standaard.

Voorbeeld:

```yaml
ingress:

  enabled: true


  className: traefik


  host:

    vergunning.apps.overheid.example.nl


  clusterIssuer:

    letsencrypt-production


  tlsSecretName:

    vergunning-service-tls
```

---

# Traefik Migration Notes

Wanneer wordt gemigreerd van NGINX naar Traefik:

Verwijderen:

```yaml
nginx.ingress.kubernetes.io/rewrite-target: /
```

Deze annotation is alleen geldig voor NGINX.

Gebruik voor Traefik:

* Kubernetes Middleware resources
* StripPrefix middleware
* Redirect middleware
* Headers middleware

---

# FluxCD Deployment Order

De volgorde wordt beheerd met Flux dependencies:

```text
1. Traefik

        |

        v

2. cert-manager

        |

        v

3. ClusterIssuer

        |

        v

4. ExternalDNS

        |

        v

5. Applications

        |

        v

6. Certificates
```

---

# Security

## DNS Credentials

STACKIT DNS credentials worden nooit opgeslagen in Git.

Gebruik:

* STACKIT Secret Manager
* External Secrets Operator
* Kubernetes Secrets

Flow:

```text
STACKIT Secret Manager

          |

          v

External Secrets Operator

          |

          v

Kubernetes Secret

          |

          v

ExternalDNS
```

---

# Operational Commands

## Check Ingress

```bash
kubectl get ingress -A
```

---

## Check Certificates

```bash
kubectl get certificate -A
```

---

## Check Certificate Status

```bash
kubectl describe certificate <name>
```

---

## Check ExternalDNS

```bash
kubectl logs -n external-dns deployment/external-dns
```

---

## Check Traefik

```bash
kubectl get svc -n traefik
```

---

# Final Platform Architecture

```text
                    Terraform

                        |
        +---------------+---------------+

        |                               |

 STACKIT SKE                    STACKIT DNS Zone


        |

        |

        v


                    FluxCD


        |

        +-------------------------------+

        |                               |

        v                               v


    Traefik                       cert-manager


        |                               |

        v                               v


 ExternalDNS                  Let's Encrypt


        |

        v


 STACKIT DNS Records


        |

        v


Applications


        |

        v


HTTPS endpoints
```

---

# Benefits

Deze strategie levert:

✅ volledig geautomatiseerde DNS provisioning
✅ automatische TLS certificaten
✅ automatische certificate renewal
✅ GitOps gebaseerde lifecycle
✅ duidelijke ownership boundaries
✅ schaalbare Kubernetes platform architectuur
✅ geschikt voor STACKIT SKE productieomgevingen
