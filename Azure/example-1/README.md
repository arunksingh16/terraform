Manual Creation of SVC Principle


- Create

```
subscriptionId=$(az account show --query id -o tsv)

az ad sp create-for-rbac -n "MyApp" --role Contributor \
--scopes /subscriptions/{SubID}/resourceGroups/{ResourceGroup1} /subscriptions/{SubID}/resourceGroups/{ResourceGroup2}
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
