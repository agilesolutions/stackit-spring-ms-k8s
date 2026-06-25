controller:
  replicaCount: ${replica_count}
  ingressClassResource:
    name: nginx
    enabled: true
    default: true
  service:
    type: LoadBalancer
  metrics:
    enabled: ${enable_metrics}
  config:
    use-forwarded-headers: "true"
    enable-real-ip: "true"
    proxy-body-size: "50m"
    ssl-redirect: "true"
    hsts: "true"
    hsts-max-age: "31536000"
    server-tokens: "false"
    enable-modsecurity: "${enable_modsecurity}"
defaultBackend:
  enabled: true