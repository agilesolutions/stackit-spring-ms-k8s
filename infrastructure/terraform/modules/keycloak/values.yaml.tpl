auth:
  adminUser: ${admin_user}
  adminPassword: ${admin_password}

production: true

proxy: edge

ingress:

  enabled: true

  ingressClassName: nginx

  hostname: ${hostname}

postgresql:
  enabled: false

externalDatabase:

  host: ${postgres_host}

  database: ${postgres_database}

  user: ${postgres_username}

  password: ${postgres_password}

resources:

  requests:
    cpu: 500m
    memory: 1Gi

  limits:
    cpu: "2"
    memory: 2Gi