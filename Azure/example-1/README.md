# Terraform & using Azure Service Principle

Manual Creation of SVC Principle using `az ad sp create-for-rbac`. This will create a service principal and configure its access to Azure resources. By default, this command assigns the 'Contributor' role to the service principal at the subscription scope.


- Create

```
subscriptionId=$(az account show --query id -o tsv)

az ad sp create-for-rbac -n "MyApp" --role Contributor \
--scopes /subscriptions/{SubID}/resourceGroups/{ResourceGroup1} /subscriptions/{SubID}/resourceGroups/{ResourceGroup2}

# or

az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/SUBSCRIPTION_ID"

```

- test
```

# login using svc principle
az login --service-principal -u $servicePrincipalAppId \
         --password $spPassword --tenant $tenantId
         
# list role assignment
az role assignment list --all -o tsv

az role assignment list --assignee $servicePrincipalAppId --all
```

- Search your SVC Principle
```
az ad sp list  --filter "displayname eq 'spn-example'"
```

URL for reading -
- https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret
- 
