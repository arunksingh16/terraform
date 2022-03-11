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



## Scenrios

### How to use Azure Resource Manager (ARM) with Terraform

```
resource "azurerm_template_deployment" "template_deployment" {
  name                = "terraform-ARM-deployment"
  resource_group_name = azurerm_resource_group.resource_group.name
  template_body       = file("${path.module}/templates/fie.json")
  deployment_mode     = "Incremental"
 
  parameters = {
    xx = "yy"
  }
}
```


### How to manage terraform state? 

```
# create sp
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<subcription-id>" --name "tf-remote-bk"
```

above command will produce output, please update following env variables
- ARM_SUBSCRIPTION_ID	     === SUBSCRIPTION_ID from the last command's input.
- ARM_CLIENT_ID	           === appID from the last command's output.
- ARM_CLIENT_SECRET	       === password from the last command's output. (Sensitive)
- ARM_TENANT_ID	           ===tenant from the last command's output.

```
# if sp is not in use 
$ az ad sp delete --id "xxx-xxxx-xxxx--xxxxx"
```


### How to control developers to stay/access in one resource group

There can be multiple scenerios. 

Option 1: You can control it at service principle level as well. Give access to Svc Prin to specific resource group only.
Option 2: In terraform deployment provide option of specific resource groups to select only 


### Import existing resources in terraform 
- Greenfield implementation is not viable everytime
- use terraform import


