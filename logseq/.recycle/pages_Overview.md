## Overview
-
![Machine generated alternative text:Node Node nux Master KV O Linux Node Node ](Exported%20image%2020241121214720-0.png)

![Machine generated alternative text:Master Cluster KV Store scheduler Controller apiserver { } JSON $kubectl ](Exported%20image%2020241121214723-1.png)

Master > Node
 
Node = Kubectl + Container Engine (e.g. docker) + kube proxy
 
Node = runs multiple pod  
Kube-proxy

- assigns IP per pod
- Load balances across pods in a service   
  ![Machine generated alternative text:Kubelet Main Kubernetes agent Container engine Docker or rkt kube-proxy Kubernetes networking Node Linux ](Exported%20image%2020241121214724-2.png)