# Kubernetes

## Cheatsheet

### kubectl

**Configuration:**
- Context → cluster → namespace → user

**Run busybox and connect:**

```bash
kubectl run -i --tty busybox --image=busybox --restart=Never -- sh
```

### Service Accounts
> [!NOTE]
> Service Accounts are restricted to Namespace


#### 1. Create Service Account

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: mynamespace
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: mynamespace-user
  namespace: mynamespace
---
kind: Role
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: mynamespace-user-full-access
  namespace: mynamespace
rules:
  - apiGroups: ["", "extensions", "apps", "policy", "rbac.authorization.k8s.io", "batch"]
    resources: ["*"]
    verbs: ["*"]
---
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: mynamespace-user-binding
  namespace: mynamespace
subjects:
  - kind: ServiceAccount
    name: mynamespace-user
    namespace: mynamespace
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: mynamespace-user-full-access
```

#### 2. Get Login Token for Service Account

```bash
# Describe service account to find secret
kubectl describe sa mynamespace-user -n mynamespace

# Get token from secret
kubectl get secret mynamespace-user-token-7wpw7 -n mynamespace -o "jsonpath={.data.token}" | base64 -D
```

#### 3. Get Server Certificate

```bash
kubectl get secret mynamespace-user-token-7wpw7 -n mynamespace -o "jsonpath={.data['ca\.crt']}"
```

## Istio

### TLS Configuration

- [TLS Configuration Guide](https://istio.io/latest/docs/ops/configuration/traffic-management/tls-configuration/)
- [Example: Secure Ingress](https://istio.io/latest/docs/tasks/traffic-management/ingress/secure-ingress/)

## Overview

![2025-11-24_20-04.png](../assets/2025-11-24_20-04_1763975142462_0.png)

### Master Node Components

- **API server**
- **KV store (etcd)**
- **kube-scheduler**
- **controller-manager**

### Worker Node Components

**Kubelet**
- Interacts with API server

**Container Engine**
- e.g., `containerd`

**kube-proxy**
- Manages communications between pods
- Assigns IP per pod
- Load balances across pods in a service
