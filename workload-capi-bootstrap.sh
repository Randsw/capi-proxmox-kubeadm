#!/usr/bin/env bash

set -e

# Create our workload cluster manifests
KUBECONFIG=mgmt-proxmox.kubeconfig clusterctl generate cluster workload-proxmox --config work-cluster.yaml\
    --infrastructure proxmox \
    --kubernetes-version v1.32.4 \
    --control-plane-machine-count 1 \
    --worker-machine-count 1 > workload-cluster-deploy.yaml

# Edit manifest if you want add extra args in kube api server(for OIDC for example) or enable feature gates
# Refer to https://doc.crds.dev/github.com/kubernetes-sigs/cluster-api/controlplane.cluster.x-k8s.io/KubeadmControlPlane/v1beta1@v1.6.2
#          https://cluster-api.sigs.k8s.io/tasks/control-plane/kubeadm-control-plane

# Apply manifest in proxmox mgmt-cluster
KUBECONFIG=mgmt-proxmox.kubeconfig  kubectl apply -f workload-cluster-deploy.yaml