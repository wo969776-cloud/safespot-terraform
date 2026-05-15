# Metrics Server

## Chart

- **Repository**: https://kubernetes-sigs.github.io/metrics-server/
- **Chart**: metrics-server
- **Chart Version**: 3.12.2

## Purpose

Metrics Server provides resource usage metrics (CPU and memory) for nodes and pods. It is required by:

- **HorizontalPodAutoscaler (HPA)** — CPU/memory-based autoscaling for application workloads
- `kubectl top nodes` and `kubectl top pods` commands

Without Metrics Server, HPA cannot function and `kubectl top` will return an error.

## No IRSA Required

Metrics Server does not interact with AWS APIs and does not require an IAM Role for Service Accounts.

## High Availability

Two replicas are configured with a PodDisruptionBudget allowing at most one unavailable replica. Both pods are scheduled on system nodes via `nodeSelector: role: system`.

## ServiceMonitor

`serviceMonitor.enabled` is set to `false`. Enable it if Prometheus Operator (kube-prometheus-stack) is deployed in the cluster and you want to scrape metrics-server metrics.

## Deployment

This chart is deployed via ArgoCD. See `argocd/metrics-server.yaml`.
