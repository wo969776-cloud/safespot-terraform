# cert-manager

## Chart

- **Repository**: https://charts.jetstack.io
- **Chart**: cert-manager
- **Chart Version**: v1.16.0

## Status: Optional

cert-manager is **optional** for this cluster. The decision depends on your TLS certificate strategy:

| Strategy | When to use | cert-manager needed? |
|---|---|---|
| **AWS ACM** (recommended) | ALB terminates TLS using ACM certificates; ACM handles renewal automatically | **No** |
| **Let's Encrypt** | In-cluster TLS termination (e.g., NGINX Ingress + cert-manager ACME) | **Yes** |

For the SafeSpot platform, ALB terminates TLS using ACM certificates provisioned via Terraform (`terraform/environments/dev/front-edge/`). cert-manager is included here for completeness but is **not required** by the current architecture.

## When to Enable

Enable cert-manager if:
- You switch from ALB TLS termination to in-cluster ingress controllers that need TLS
- You need internal mTLS certificates for service mesh use cases
- You need to issue certificates from an internal CA

## CRD Installation

`crds.enabled: true` installs cert-manager CRDs (`Certificate`, `CertificateRequest`, `Issuer`, `ClusterIssuer`, etc.) as part of the Helm release.

## No IRSA Required

cert-manager itself does not require IRSA. However, if using the Route53 DNS-01 ACME solver, a separate IRSA role with Route53 permissions is needed.

## Deployment

This chart is deployed via ArgoCD at sync-wave 0 (before other addons that may depend on cert-manager CRDs). See `argocd/cert-manager.yaml`.
