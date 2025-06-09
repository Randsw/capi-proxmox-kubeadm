#!/usr/bin/env bash

set -e

# Get mgmt cluster kubeconfig
clusterctl get kubeconfig mgmt-proxmox > mgmt-proxmox.kubeconfig

# Deploy CNI
KUBECONFIG=mgmt-proxmox.kubeconfig kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

# Deploy CAPI workload to constant mgmt cluster
KUBECONFIG=mgmt-proxmox.kubeconfig clusterctl init --infrastructure proxmox --ipam in-cluster --config ./clusterctl.yaml

