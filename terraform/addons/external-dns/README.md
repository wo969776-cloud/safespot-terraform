# ExternalDNS

## Chart

- **Repository**: https://kubernetes-sigs.github.io/external-dns/
- **Chart**: external-dns
- **Chart Version**: 1.15.0

## IRSA Requirement

ExternalDNS requires an IAM Role for Service Accounts (IRSA) provisioned by Terraform in:

```
terraform/environments/dev/api-service/eks-addons-irsa/
```

The role `safespot-dev-external-dns-irsa` grants permission to manage Route53 records in the `safespot.site` hosted zone.

## Domain Filter

ExternalDNS is configured to manage only the `safespot.site` hosted zone. Records from other zones are ignored.

The `txtOwnerId` is set to `safespot-dev-eks` to namespace TXT ownership records. Do not change this value once DNS records are live, as it will cause ExternalDNS to lose track of existing records.

## Policy

Policy is set to `sync` — ExternalDNS will **create and delete** DNS records to match the cluster state. Ensure Ingress and Service objects have correct hostnames before enabling sync.

## IRSA Role ARN

Run the init script after Terraform apply to populate the role ARN in `values-dev.yaml`:

```bash
bash scripts/init-addon-values.sh
```

Source: `terraform -chdir=terraform/environments/dev/api-service/eks-addons-irsa output -raw external_dns_irsa_role_arn`

See `docs/irsa-contract.md` for the full binding table.

## Deployment

This chart is deployed via ArgoCD. See `argocd/external-dns.yaml`.
