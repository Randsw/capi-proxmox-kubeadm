#!/usr/bin/env bash

set -e

# Get workload cluster kubeconfig
KUBECONFIG=mgmt-proxmox.kubeconfig clusterctl get kubeconfig workload-proxmox > workload-proxmox.kubeconfig

# Deploy CNI
KUBECONFIG=workload-proxmox kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml