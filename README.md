# terraform
Terraform Deployment



### How to Debug terraform

You can set TF_LOG to one of the log levels TRACE, DEBUG, INFO, WARN or ERROR to change the verbosity of the logs.

```
mkdir logs
export TF_LOG_PATH="./logs/terraform.log"
export TF_LOG="INFO" 
```
