```
az account set --subscription XXXX
az aks get-credentials --resource-group aksrg1 --name aks-cluster1
appgwId=$(az network application-gateway show -n ApplicationGateway1  -g aksrg1 -o tsv --query "id")
az aks enable-addons -n aks-cluster1 -g aksrg1 -a ingress-appgw --appgw-id $appgwId
```
https://github.com/bart-jansen/terraform-aks-appgw-acr-keyvault-loganalytics/blob/main/modules/appgw/main.tf
https://github.com/nicholasjackson/terraform-azure-k8s/blob/master/pods.tf
https://blog.bart.je/deploying-a-fully-configured-aks-cluster-in-azure-using-terraform/
