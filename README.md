# Before you begin

## System and software requirements:

Ubuntu version 16.04
Ansible 2.2.1.0+

## Network requirements

Note: The information in this article is specific to the system and software versions noted above and may not be accurate for other versions.
Networking requirements: All nodes must be interconnected and reachable on the same network. There must be two additional network namespaces
that do not overlap: the service IP addresses reange and the pod IP addresses range.

# Configuration files

## hosts

This file describes the hosts that Kubernetes will be installed on. It is divided in 3 main groups: master, worker and etcd.
More infomation about Ansible hosts can be found at http://docs.ansible.com/ansible/intro_inventory.html

* There must be at least 3 etcd nodes. Ideally there would be 5 to allow for 2 node failure.
* There must be at least 3 master nodes. Ideally there would be 5 to allow for 2 node failure.
* There must be at least 1 worker node. Add more workers as cluster workload increases.

While the same machine may be used for multiple purposes, this is generally discouraged.

## group_vars/all

The main file which describes feature and configuration values.

### version

Kubernetes version to use. Tested with 1.5.3.

### etcd_version

Etcd version to use. Tested with 3.1.2.

### cni_version

Container Network Interface (CNI) version to use. Tested with 0.4.0.

### cluster_name

Name of this Kubernetes cluster.

### context_name

Name of the Kubernetes context

### pod_network

Pod network range in CIDR format. Eg: 10.2.0.0/16

### service_ip_range

Service network range in CIDR format. Eg: 10.3.0.0/24

### service_ip

The IP of the Kubernetes API Manager on the Service network. Typically the first IP within the service IP Range. Eg: 10.3.0.1

### dns_service_ip

The IP of the DNS Service on the Service network. Eg: 10.3.0.10

### cluster_domain

Internal domain name of the Kubernetes cluster. Typically "cluster.local".

### apiserver_lb

Name of the load-banacer fronting the API servers (master nodes). Eg: "kube-master.dev".

### apiserver_server_ip

IP of the load-balancer. Eg: "10.3.0.1"

### apiserver_port

HTTPS port for the API Server. Eg: 6443. (May want to avoid 443 since that may be used by incoming traffic)

### traffic_iface

Internal traffic network interface. This network should not be publically accessable. Eg: enp0s8.

### public_iface

Public traffic network interface. Eg: enp0s3.

### enable_rbac

Enables RBAC alpha resource.

### enable_cluster_monitoring

Enables Heapster/InfluxDB/Graphana based cluster resource monitoring.

### enable_cron_jobs

Enables Cron Job alpha resource.

### enable_pod_security_policy

Enabled POD security policy.

### ntp_servers

List of NTP servers to use for this cluster.

### add_registry

Start a Docker registry.

### add_ingress

Add an Nginx based Ingress controller.

# Running the playbook

```
ansible-playbook -i hosts -s k8s_playbook.yaml
```
