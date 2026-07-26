# Authenticatie, Autorisatie en Secrets

## Inleiding

Beveiliging vormt een essentieel onderdeel van iedere moderne cloud-native applicatie. Binnen dit referentieplatform wordt gebruikgemaakt van open standaarden zoals OAuth 2.1, OpenID Connect (OIDC) en JWT om gebruikers en services veilig te authenticeren en autoriseren.

Door gebruik te maken van een centrale Identity Provider (IdP) wordt authenticatie losgekoppeld van de applicaties. Hierdoor ontstaat een uniforme, schaalbare en veilige beveiligingsarchitectuur.

Dit platform maakt gebruik van **Keycloak** als Identity & Access Management (IAM) oplossing.

---

# Architectuur

```text
                        Gebruiker
                            │
                            ▼
                     OpenID Connect
                            │
                            ▼
                     +---------------+
                     |   Keycloak    |
                     | Identity      |
                     | Provider      |
                     +---------------+
                            │
             Access Token (JWT)
                            │
        ┌───────────────────┼────────────────────┐
        ▼                   ▼                    ▼
 Vergunning Service   Zakenregistratie     Overige Services
                            │
                            ▼
                     PostgreSQL
```

---

# Doelstellingen

De beveiligingsarchitectuur is gebaseerd op de volgende uitgangspunten:

- Centrale authenticatie
- Centrale autorisatie
- Single Sign-On (SSO)
- Zero Trust Security
- Least Privilege
- Secrets buiten de applicatie
- End-to-End TLS
- Machine-to-Machine authenticatie
- Standaard OpenID Connect

---

# Authenticatie

Authenticatie bepaalt **wie** een gebruiker of applicatie is.

Binnen dit platform wordt authenticatie verzorgd door Keycloak.

Ondersteunde authenticatiemethoden:

- Gebruikersnaam en wachtwoord
- OpenID Connect (OIDC)
- OAuth 2.1
- Client Credentials
- Refresh Tokens
- Single Sign-On (SSO)

Na succesvolle authenticatie verstrekt Keycloak een digitaal ondertekend **JWT Access Token**.

---

# Autorisatie

Autorisatie bepaalt **wat** een gebruiker of service mag doen.

Binnen Keycloak worden hiervoor gebruikt:

- Realms
- Clients
- Roles
- Groups
- Scopes
- Claims

Voorbeelden:

| Rol | Toegang |
|------|----------|
| gebruiker | Alleen eigen vergunningen |
| behandelaar | Vergunningen behandelen |
| beheerder | Volledige administratie |
| service-account | Machine-to-machine communicatie |

Applicaties controleren uitsluitend de rollen en claims in het JWT-token.

---

# OpenID Connect (OIDC)

OpenID Connect is een identiteitslaag bovenop OAuth 2.1.

Voordelen:

- Gestandaardiseerde login
- Single Sign-On
- Veilige token-uitwisseling
- Breed ondersteund
- Integratie met Spring Security

Belangrijkste endpoints:

- Authorization Endpoint
- Token Endpoint
- UserInfo Endpoint
- JWKS Endpoint

---

# OAuth 2.1 Flows

Binnen dit platform worden twee OAuth-flows toegepast.

## Authorization Code Flow

Voor interactieve gebruikers.

```
Gebruiker
      │
      ▼
 Keycloak Login
      │
 Authorization Code
      │
      ▼
Spring Boot Applicatie
      │
      ▼
 Access Token
```

---

## Client Credentials Flow

Voor communicatie tussen microservices.

```
Service A
     │
 Client ID
 Client Secret
     │
     ▼
 Keycloak
     │
 JWT Token
     │
     ▼
Service B
```

Hiermee kunnen backend-services veilig met elkaar communiceren zonder gebruikersinteractie.

---

# JSON Web Tokens (JWT)

Na succesvolle authenticatie geeft Keycloak een JWT-token uit.

Een JWT bevat onder andere:

- gebruiker
- issuer
- audience
- rollen
- scopes
- vervaltijd
- digitale handtekening

Spring Security valideert automatisch:

- digitale handtekening
- vervaldatum
- issuer
- audience

Hierdoor hoeft de applicatie geen sessies op te slaan.

---

# Spring Security

Iedere microservice fungeert als **OAuth2 Resource Server**.

Spring Security verzorgt automatisch:

- JWT-validatie
- Role Mapping
- Method Security
- Endpoint Security

Voorbeeld:

```java
@PreAuthorize("hasRole('BEHANDELAAR')")
public ResponseEntity<?> goedkeuren(...)
```

Hiermee wordt autorisatie declaratief geregeld binnen de applicatie.

---

# Machine-to-Machine Authenticatie

Microservices communiceren onderling via OAuth Client Credentials.

Voordelen:

- Geen gedeelde wachtwoorden
- Tijdelijke tokens
- Centrale autorisatie
- Veilige servicecommunicatie

Elke microservice beschikt over een eigen Client ID en Client Secret.

---

# Secrets Management

Gevoelige gegevens worden **nooit** opgeslagen in Git.

Voorbeelden van secrets:

- database wachtwoorden
- client secrets
- API keys
- TLS certificaten
- encryptiesleutels

---

# External Secrets Operator

Secrets worden automatisch gesynchroniseerd vanuit een externe Secret Store.

```text
Secret Store
      │
      ▼
External Secrets Operator
      │
      ▼
Kubernetes Secret
      │
      ▼
Spring Boot Pod
```

Voordelen:

- Geen secrets in Git
- Centrale rotatie
- Veilige distributie
- GitOps-vriendelijk

---

# ConfigMaps versus Secrets

| ConfigMap | Secret |
|------------|--------|
| Niet vertrouwelijk | Vertrouwelijke gegevens |
| Configuratie | Wachtwoorden |
| Feature Flags | API Keys |
| Logging instellingen | Client Secrets |

---

# TLS

Alle communicatie verloopt via TLS.

Beveiligde verbindingen:

- Browser → Ingress
- Ingress → Applicaties
- Applicaties → Keycloak
- Applicaties → PostgreSQL

Certificaten worden automatisch beheerd door **cert-manager**.

---

# Network Security

Naast authenticatie wordt netwerkverkeer beperkt met Kubernetes Network Policies.

Toegestane verbindingen:

- Frontend → Backend
- Backend → PostgreSQL
- Services → Keycloak
- Monitoring → Applicaties

Alle overige verbindingen worden geweigerd.

---

# GitOps Security

FluxCD beheert uitsluitend declaratieve configuratie.

De Git-repository bevat:

- Deployments
- Services
- Ingress
- ConfigMaps
- Network Policies

Niet opgenomen in Git:

- wachtwoorden
- tokens
- certificaten
- client secrets
- API keys

Hierdoor blijft de repository veilig deelbaar.

---

# Best Practices

Binnen dit platform worden de volgende beveiligingsmaatregelen toegepast:

- OpenID Connect (OIDC)
- OAuth 2.1
- Keycloak Identity Provider
- JWT Access Tokens
- OAuth2 Resource Server
- Client Credentials Flow
- Role Based Access Control (RBAC)
- TLS voor alle verbindingen
- External Secrets Operator
- Geen secrets in Git
- Kubernetes Network Policies
- Principle of Least Privilege
- Zero Trust Security

---

# Conclusie

Door Keycloak, OpenID Connect, OAuth 2.1, Spring Security en de External Secrets Operator te combineren ontstaat een moderne, veilige en onderhoudbare beveiligingsarchitectuur. Authenticatie en autorisatie worden centraal beheerd, terwijl gevoelige gegevens veilig buiten de applicaties en Git-repository blijven. Deze aanpak sluit aan bij Cloud Native best practices en biedt een solide basis voor veilige microservices op STACKIT SKE.