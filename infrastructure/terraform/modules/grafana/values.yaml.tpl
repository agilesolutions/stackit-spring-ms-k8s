adminPassword: ${admin_password}
ingress:
  enabled: true
  ingressClassName: nginx
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt
  hosts:
    - ${hostname}
  tls:
    - secretName: grafana-tls
      hosts:
        - ${hostname}

datasources:
  datasources.yaml:
    apiVersion: 1
    datasources:
      - name: Prometheus
        type: prometheus
        access: proxy
        url: ${prometheus_url}
        isDefault: true
      - name: Loki
        type: loki
        access: proxy
        url: ${loki_url}
      - name: Tempo
        type: tempo
        access: proxy
        url: ${tempo_url}
        jsonData:
          tracesToLogs:
            datasourceUid: Loki

 grafana.ini:
    auth.generic_oauth:
      enabled = true
      name = Keycloak
      allow_sign_up = true
      client_id = grafana
      client_secret = $__env{GF_CLIENT_SECRET}
      scopes = openid profile email
      auth_url =
       https://keycloak.platform.example.nl/realms/overheid/protocol/openid-connect/auth
      token_url =
       https://keycloak.platform.example.nl/realms/overheid/protocol/openid-connect/token
      api_url =
       https://keycloak.platform.example.nl/realms/overheid/protocol/openid-connect/userinfo