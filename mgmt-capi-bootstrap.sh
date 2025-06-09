#!/usr/bin/env bash

set -e

# Deploy CAPI workload on KIND cluster
clusterctl init --infrastructure proxmox --ipam in-cluster --config ./clusterctl.yaml

# Create our future constant mgmt cluster on proxmox manifests
clusterctl generate cluster mgmt-proxmox --config mgmt-cluster.yaml\
    --infrastructure proxmox \
    --kubernetes-version v1.32.4 \
    --control-plane-machine-count 1 \
    --worker-machine-count 2 > mgmt-cluster-deploy.yaml

# Edit manifest if you want add extra args in kube api server(for OIDC for example) or enable feature gates
# Refer to https://doc.crds.dev/github.com/kubernetes-sigs/cluster-api/controlplane.cluster.x-k8s.io/KubeadmControlPlane/v1beta1@v1.6.2
#          https://cluster-api.sigs.k8s.io/tasks/control-plane/kubeadm-control-plane

# Apply manifest in KIND cluster
kubectl apply -f mgmt-cluster-deploy.yaml