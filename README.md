# SCS / POC / Rancher

![](https://rancher.com/imgs/rancher-logo-horiz-color.png)

## Overview

All relevant steps for a setup and installation is located here. Credentials are located on `scs-secrets` repository.


## Links:

## Lab Setup

- Provider: Openstack (Betacloud)
- Project: SCS (shared Loodse/Rancher Project)




- history and steps:

```
# all used tools are installed and running
direnv allow

cd openstack

# create file secrets.d/scs-kubermatic-openrc.sh via gopass
gopass scs-kubermatic-openrc.sh > ../secure.d/scs-kubermatic-openrc.sh

# enable the secrets for openstack
source ../secure.d/scs-kubermatic-openrc.sh

# start an ssh-agent add the ssh private-key for the remote-exec step
# for the password see secrets repo
eval $(ssh-agent)
ssh-add ../work/poc-rancher

# start the terraforming
terraform init 
terraform plan
terraform apply -auto-approve

# Create cluster via RKE
rke up

# check the kubeconfig, set via direnv
stat $KUBECONFIG

# use the kubernetes-cli aka kubectl to check the cluster
kubectl get nodes -o wide

# cert-manager
# create namespace
kubectl create namespace cert-manager

# add repo
helm repo add jetstack https://charts.jetstack.io
helm repo update

# install cert-manager
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v0.16.1 \
  --set installCRDs=true

# install rancher
# add repo
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest

# create namespace
kubectl create namespace cattle-system

# install
helm install rancher rancher-latest/rancher \
  --namespace cattle-system \
  --set hostname=<IP>.xip.io

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
