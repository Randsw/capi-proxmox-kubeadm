# STEPS

## Prerequisites

Prepate VM image using [image-builder](https://image-builder.sigs.k8s.io/capi/providers/proxmox)

## 1. Create temporary management cluster with KIND

Run `cluster-setup.sh`. Now you get your first mgmt cluster on KIND. But in on local machine so we need to transfer our mgmt cluster to Proxmox VE.

## 2. Install in KIND cluster CAPI workload and deploy mgmt cluster on Proxmox VE

Run `mgmt-capi-bootstrap.sh`. This script deploy future mgmt cluster on Proxmox VE.

Its take several minutes depending on the speed of the internet connection

### Check the status of the mgmt cluster

```bash
clusterctl describe cluster mgmt-proxmox
```

## 3. Deploy Calico CNI on mgmt cluster in Proxmox environment, get kubeconfig and deploy CAPI workload

Run `prepare-mgmt.sh`. This script deploy Calico CNI and CAPI workload in mgmt cluster on Proxmox.

### Check mgmt cluster nodes

```bash
KUBECONFIG=mgmt-proxmox.kubeconfig kubectl get nodes
```

After this KIND cluster can be deleted

```bash
kind delete cluster
```

## 4. Deploy workload cluster on Proxmox VE

Run `workload-capi-bootstrap.sh`. This script deploy workload cluster on Proxmox VE.

### Check the status of the  workloadcluster

```bash
KUBECONFIG=mgmt-proxmox.kubeconfig  clusterctl describe cluster workload-proxmox
```

## 5. Deploy Calico CNI on wokload cluster in Proxmox environment and get kubeconfig

Run `prepare-workload.sh`. This script deploy Calico CNI in workload cluster on Proxmox.

### Check workload cluster nodes

```bash
KUBECONFIG=workload-proxmox.kubeconfig kubectl get nodes
```

## 6. Access to VM

By default clusterctl use [image-builder](https://image-builder.sigs.k8s.io/capi/providers/proxmox) [public key](https://raw.githubusercontent.com/kubernetes-sigs/image-builder/refs/heads/main/images/capi/cloudinit/id_rsa.capi.pub) as ssh authorized_keys.

So private key to access VM is https://raw.githubusercontent.com/kubernetes-sigs/image-builder/refs/heads/main/images/capi/cloudinit/id_rsa.capi

To change edit this edit manifest in `KubeadmControlPlane` CR

```yaml
 users:
    - name: root
      sshAuthorizedKeys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFIKszT265HYuhwWJ3CwozCKXI3y94bQoocQf1/ERq7XkWJ57W3rkbpMXtM0l1IKfhjnkRzFkXDa5WgRYFvAosh68LeKmYhoJYOKnyvx/nYBT/aYWdLu/edgv8T8GYKG1MiU6RdNvsGsXIAKhknBtcsmTcR2niEwOmXQ5M/P3oMswWk+4WIcWyJU6BWAQbK/alVn5kIRQFas47k6Pkm1Tg7TKv+MOX6JPzv8gOqxvqcXFKoEcTthC2JsKvmRwAOtLrBHh5BMzOKV9G+CnmgzmM/p6qU1nfebvDNuBtzThURP0lTcJGmf+g5WtbJ8vdUd+MAFZGpvoARl1v1s4Ubked
```

and in:

```yaml
piVersion: bootstrap.cluster.x-k8s.io/v1beta1
kind: KubeadmConfigTemplate
metadata:
  name: proxmox-quickstart-worker
  namespace: default
spec:
  template:
    spec:
      joinConfiguration:
        nodeRegistration:
          kubeletExtraArgs:
            provider-id: proxmox://'{{ ds.meta_data.instance_id }}'
      users:
      - name: root
        sshAuthorizedKeys:
        - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFIKszT265HYuhwWJ3CwozCKXI3y94bQoocQf1/ERq7XkWJ57W3rkbpMXtM0l1IKfhjnkRzFkXDa5WgRYFvAosh68LeKmYhoJYOKnyvx/nYBT/aYWdLu/edgv8T8GYKG1MiU6RdNvsGsXIAKhknBtcsmTcR2niEwOmXQ5M/P3oMswWk+4WIcWyJU6BWAQbK/alVn5kIRQFas47k6Pkm1Tg7TKv+MOX6JPzv8gOqxvqcXFKoEcTthC2JsKvmRwAOtLrBHh5BMzOKV9G+CnmgzmM/p6qU1nfebvDNuBtzThURP0lTcJGmf+g5WtbJ8vdUd+MAFZGpvoARl1v1s4Ubked
```

Or set:

```yaml
SSH_AUTHORIZED_KEY: "ssh-rsa AAAAB3Nz ..."
```

in cluster config file
