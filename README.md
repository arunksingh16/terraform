# Terraform 

Terraform Deployment Examples and advance topics



### How to Debug terraform

You can set TF_LOG to one of the log levels TRACE, DEBUG, INFO, WARN or ERROR to change the verbosity of the logs.

```
mkdir logs
export TF_LOG_PATH="./logs/terraform.log"
export TF_LOG="INFO" 
```

### Terraform can validate input variables!
```
variable "cloudenv" {
  type        = string
  description = "Cloud Environment"

  validation {
    condition = anytrue([
      var.env == "prd",
      var.env == "qa",
      var.env == "uat",
      var.env == "dev"
    ])
    error_message = "Must be a valid Cloud Env, values can be prd, qa, uat, or dev."
  }
}
```

### Sensitive Values
Setting a variable as sensitive prevents Terraform from showing its value in the plan or apply output,

```
variable "some_info" {
  type = object({
    name    = string
    address = string
  })
  sensitive = true
}
```

## Variables

 Input Variable Values 
 
 
 
 ## Good to read blogs
 
 
 
 https://kevingimbel.de/blog/2021/06/validating-variables-in-terraform/#:~:text=%20Validating%20variables%20in%20terraform%20%201%20Syntax,alltrue%20and...%205%20Further%20reading.%20%20More%20
