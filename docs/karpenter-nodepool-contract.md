# Karpenter NodePool Contract

This document defines the label and taint contract for Karpenter-managed nodes. Application deploy repos must follow this contract to ensure pods are scheduled on the correct nodes.

---

## NodePool Overview

| NodePool | Node Label | Taint | Capacity Type | Instance Families |
|---|---|---|---|---|
| `default` | `role=workload` | none | spot + on-demand | c, m, r (gen > 2) |
| `api-public-read` | `role=api-public-read` | `workload=api-public-read:NoSchedule` | spot only | c, m (gen > 2) |

In addition, **system nodes** (Managed Node Group) carry `role=system` and are reserved for platform addons only (ALB Controller, Karpenter, ExternalDNS, ESO, Metrics Server). Application workloads must NOT target system nodes.

---

## NodePool: default

**Purpose**: General application workloads that can tolerate node replacement. Allows both spot and on-demand to reduce interruption risk.

**Node Labels applied by NodePool template:**
```yaml
role: workload
```

**Disruption policy**: `WhenEmptyOrUnderutilized` — nodes consolidate when pods can be moved elsewhere.

**How to target from a Deployment:**
```yaml
spec:
  template:
    spec:
      nodeSelector:
        role: workload
      # No tolerations needed — this NodePool has no taints
```

**Applicable workloads**: api-core, external-ingestion, async-worker

---

## NodePool: api-public-read

**Purpose**: Isolated nodes for the api-public-read service, which experiences unpredictable surge traffic. Spot-only to minimize cost during scale-out. Taint prevents other workloads from landing on these nodes.

**Node Labels applied by NodePool template:**
```yaml
role: api-public-read
```

**Taint applied to provisioned nodes:**
```yaml
workload=api-public-read:NoSchedule
```

**Disruption policy**: `WhenEmpty` — nodes are only removed when fully empty. `consolidateAfter: 5m` provides a grace period after traffic drops.

**How to target from a Deployment:**
```yaml
spec:
  template:
    spec:
      nodeSelector:
        role: api-public-read
      tolerations:
        - key: workload
          value: api-public-read
          operator: Equal
          effect: NoSchedule
```

**Applicable workloads**: api-public-read only

---

## NodePool: system (Managed Node Group)

**Purpose**: Platform addon workloads only. Provisioned by Terraform as a fixed-size Managed Node Group, not by Karpenter.

**Node Labels:**
```yaml
role: system
```

**Taint (applied via MNG launch template or userdata):**
```yaml
CriticalAddonsOnly=:NoSchedule   # operator: Exists
```

**How platform addons target these nodes** (set in each chart's values-dev.yaml):
```yaml
nodeSelector:
  role: system
tolerations:
  - key: CriticalAddonsOnly
    operator: Exists
```

**Application workloads must NOT target system nodes.** Application Deployments should use `role: workload` or `role: api-public-read`.

---

## EC2NodeClass

All NodePools reference the `default` EC2NodeClass defined in `terraform/addons/karpenter/ec2nodeclass-default.yaml`.

Key settings:
- **AMI**: AL2023 (latest alias — Karpenter resolves to the latest AL2023 EKS-optimized AMI)
- **Subnets**: selected by tag `kubernetes.io/cluster/safespot-dev-eks: owned`
- **Security Groups**: selected by tag `kubernetes.io/cluster/safespot-dev-eks: owned`
- **Node IAM Role**: `safespot-dev-karpenter-node`

---

## Limits

| NodePool | CPU Limit | Memory Limit |
|---|---|---|
| `default` | 100 vCPU | 400 Gi |
| `api-public-read` | 200 vCPU | 400 Gi |

When limits are reached, Karpenter will not provision new nodes for that pool. Monitor node count and set appropriate HPA max replicas to stay within pool limits.
