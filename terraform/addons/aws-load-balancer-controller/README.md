# AWS Load Balancer Controller

## Chart

- **Repository**: https://aws.github.io/eks-charts
- **Chart**: aws-load-balancer-controller
- **Chart Version**: 1.9.2
- **App Version**: v2.9.2

## IRSA

The IAM role is managed by Terraform (`eks-irsa` environment). Run the init script after Terraform apply to populate the role ARN in `values-dev.yaml`:

```bash
bash scripts/init-addon-values.sh
```

Source: `terraform -chdir=terraform/environments/dev/api-service/eks-irsa output -raw alb_controller_irsa_role_arn`

See `docs/irsa-contract.md` for the full binding table.

## VPC ID

Not set in `values-dev.yaml` — the controller auto-detects the VPC from EC2 instance metadata when running in-cluster.

## Deployment

Deployed via ArgoCD. See `argocd/aws-load-balancer-controller.yaml`.
