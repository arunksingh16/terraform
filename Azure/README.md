# Terraform for Azure Resources

The repository to support Azure Specific Terraform assisted deployment example scenerios.

## How to connect
- Using Azure CLI
- Using Azure Svc Principle
- Using Azure Mgd Identity


### Example -1
Service Principle creation using Terraform.

### Example -2
Azure Network Components Creation

### Example -3
Validations using Terraform.

### Example -4
Using DATA to fetch config from Azure Cloud external resource

### Example -5
AKS Cluster Deployment

### Example -6
AKS Cluster with Gateway Deployment



# Scenrios

## How to manage terraform state? 


## How to control developers to stay/access in one resource group

There can be multiple scenerios. 

Option 1: You can control it at service principle level as well. Give access to Svc Prin to specific resource group only.
Option 2: In terraform deployment provide option of specific resource groups to select only 


## Import existing resources in terraform 
- Greenfield implementation is not viable everytime
- use terraform import


