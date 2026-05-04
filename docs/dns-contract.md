# DNS Contract

This document defines how DNS records are managed in the SafeSpot dev environment using ExternalDNS and Route53.

---

## Overview

ExternalDNS is a Kubernetes controller that watches Ingress and Service resources and automatically creates/updates/deletes DNS records in Route53. Application teams do not interact with Route53 directly.

---

## Managed Zone

| Property | Value |
|---|---|
| Hosted Zone | `safespot.site` |
| Zone Type | Public |
| ExternalDNS txtOwnerId | `safespot-dev-eks` |
| ExternalDNS Policy | `sync` |
| Sources | `ingress`, `service` |

---

## TXT Ownership Records

ExternalDNS creates TXT records alongside each DNS record to track ownership. The `txtOwnerId` value `safespot-dev-eks` is embedded in the TXT record value.

**Important**: Do not change `txtOwnerId` after DNS records are live. If the value changes, ExternalDNS will lose track of all records it previously created and will not clean them up on deletion.

---

## Policy: sync

`sync` policy means ExternalDNS will:
- **Create** DNS records when an Ingress/Service with a matching hostname appears
- **Update** DNS records if the target IP/hostname changes
- **Delete** DNS records when the Ingress/Service is removed

Use `upsert-only` policy in a new environment if you want to avoid accidental deletions during initial testing.

---

## How App Deploy Repos Use ExternalDNS

Application teams set the hostname in their Ingress manifest. ExternalDNS reconciles the hostname to Route53.

**Example Ingress annotation (for ALB Ingress):**
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: api-core
  namespace: api-core
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
spec:
  rules:
    - host: api.safespot.site
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: api-core
                port:
                  number: 8080
```

ExternalDNS will create an A record (ALIAS to ALB) or CNAME for `api.safespot.site` pointing to the ALB DNS name.

---

## Naming Convention

| Service | Hostname |
|---|---|
| api-core | `api.safespot.site` |
| api-public-read | `read.safespot.site` |
| external-ingestion | `ingest.safespot.site` |

All subdomains must be under `safespot.site`. ExternalDNS ignores hostnames outside the `domainFilters` list.

---

## IRSA

ExternalDNS uses the IRSA role `safespot-dev-external-dns-irsa` to authenticate with Route53.

**Permissions granted:**
- `route53:ChangeResourceRecordSets` on `arn:aws:route53:::hostedzone/*`
- `route53:ListHostedZones`, `route53:ListResourceRecordSets`, `route53:ListTagsForResource` on `*`

See `docs/irsa-contract.md` for the full IRSA binding details.

---

## Troubleshooting

```bash
# Check ExternalDNS logs
kubectl logs -n external-dns -l app.kubernetes.io/name=external-dns --tail=50

# Verify DNS record was created
aws route53 list-resource-record-sets \
  --hosted-zone-id <HOSTED_ZONE_ID> \
  --query "ResourceRecordSets[?Name=='api.safespot.site.']"

# Confirm the Ingress has the correct hostname
kubectl get ingress -A -o custom-columns='NS:.metadata.namespace,NAME:.metadata.name,HOST:.spec.rules[*].host'
```
