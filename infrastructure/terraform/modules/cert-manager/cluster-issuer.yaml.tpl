apiVersion: cert-manager.io/v1

kind: ClusterIssuer

metadata:

  name: ${issuer_name}

spec:

  acme:

    email: ${email}

    server: ${acme_server}

    privateKeySecretRef:

      name: ${issuer_name}-account-key

    solvers:

      - http01:

          ingress:

            class: nginx