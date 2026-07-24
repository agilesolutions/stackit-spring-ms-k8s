# pod communication security policy matrix
Zero trust, deny all strategy. 
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
communication topology simplified
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