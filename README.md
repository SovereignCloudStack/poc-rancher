# SCS / POC / Rancher

![](https://rancher.com/imgs/rancher-logo-horiz-color.png)

## Overview

All relevant steps for a setup and installation is located here. Credentials are located on `scs-secrets` repository.


## Links:

## Lab Setup

- Provider: Openstack (Betacloud)
- Project: SCS (shared Loodse/Rancher Project)



###  Master Cluster

- Services:

  - 3x Control-Plane Nodes with OS-Flavor `2C-4G-40G`
  - 3x Worker Nodes with the same OS-Flavor `2C-4G-40G`
  - 1x Loadbalancer VM is used KubernetesAPI (:6443) and Ingress (:80,:443), Backend Nodes: all Controlplane VM's

- Notes:

  - Beware a OpenStack example, at Betacloud we have more than one Avalabitity Zone (AZ),
    therefor the terraform HCL must be modified, or the machinedeployment must be set afterwards again!
  - at Betacloud we have no Loadbalancer-as-a-Service, we use a customized gobetween setup

- Prerequisites:

  This directory use some tool for faster development and onboarding people:

  - [direnv](https://direnv.net/)
  - [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-linux)
  - [terraform](https://releases.hashicorp.com/terraform/0.12.29/terraform_0.12.29_linux_amd64.zip)
  - [yq](https://github.com/mikefarah/yq)

- history and steps:

  ```shell=
  # This is a Shell

  ```

## Node Template config
The template below can be used to spawn new nodes in the betacloud openstack instance:

```
openstackConfig": {

    "activeTimeout": "200",
    "applicationCredentialId": "",
    "applicationCredentialName": "",
    "applicationCredentialSecret": "",
    "authUrl": "https://api-1.betacloud.de:5000/v3",
    "availabilityZone": "south-2",
    "cacert": "",
    "configDrive": false,
    "domainId": "",
    "domainName": "scs",
    "endpointType": "publicURL",
    "flavorId": "",
    "flavorName": "2C-4GB-40GB",
    "floatingipPool": "",
    "imageId": "",
    "imageName": "Ubuntu 20.04",
    "insecure": false,
    "ipVersion": "4",
    "keypairName": "poc-k8c-deployer-key",
    "netId": "",
    "netName": "net-to-external-scs-kubermatic",
    "novaNetwork": false,
    "region": "betacloud-1",
    "secGroups": "default,poc-k8c-cluster",
    "sshPort": "22",
    "sshUser": "ubuntu",
    "tenantDomainId": "",
    "tenantDomainName": "",
    "tenantId": "b6fc3afc5d90476196687fe427ed0725",
    "tenantName": "",
    "userDataFile": "",
    "userDomainId": "",
    "userDomainName": "",
    "userId": "",
    "username": "scs-kubermatic"

},
```
