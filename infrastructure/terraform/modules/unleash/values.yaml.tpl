postgresql:
  enabled: false

service:
  type: ${service_type}

env:
  DATABASE_HOST: ${database_host}
  DATABASE_PORT: "5432"
  DATABASE_NAME: ${database_name}
  DATABASE_USERNAME: ${database_user}
  DATABASE_PASSWORD: ${database_password}

ingress:
  enabled: true
  ingressClassName: nginx

  hosts:
    - host: ${hostname}
      paths:
        - /