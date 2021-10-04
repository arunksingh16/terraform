# Terraform 

Terraform Deployment Examples and advance topics.


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

### Variables

 Input variables are created by a variable block, but you reference them as attributes on an object named var. They can be set in a number of ways:
 
- Individually, with the -var command line option. `terraform apply -var="image_id=ami-abc123"`
- In variable definitions (.tfvars) files, either specified on the command line or automatically loaded. `terraform apply -var-file="testing.tfvars"`
- As environment variables. `export TF_VAR_image_id=ami-abc123` Terraform can search for environment variables named `TF_VAR_` followed by the name of a declared variable.


### data sources

`data` resource can be use to pull information from remote system or in some cases locally.
example
```
# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}

# use it 
module "vpc" {
   source  = "terraform-aws-modules/vpc/aws"
   version = "2.64.0"
   cidr = var.vpc_cidr_block
   azs  = data.aws_availability_zones.available.names

 }

# you can print o/p 
output "azname-1" {
  value = "${data.aws_availability_zones.available.names[0]}"
}

output "azname-2" {
  value = "${data.aws_availability_zones.available.names[1]}"
}

```

### explicit dependency
Implicit dependencies are the primary way that Terraform understands the relationships between your resources. Sometimes there are dependencies between resources that are not visible to Terraform. Use `depends_on` in that case.
```
resource "azurerm_key_vault_secret" "winvm_kv_secret" {
  name         = "winvm-pass"
  value        = "${random_password.vm_pass.result}"
  key_vault_id = "${azurerm_key_vault.kv.id}"
  depends_on = [
    azurerm_key_vault.kv,
    ]
}
```


### terraform functions
The Terraform language includes a number of built-in functions that you can call from within expressions to transform and combine values. 
`templatefile` function
```
#!/bin/bash
sudo apt-get -y -qq install curl wget git vim apt-transport-https ca-certificates
sudo groupadd -r ${department}
sudo useradd -m -s /bin/bash ${name}
sudo usermod -a -G ${department} ${name}
```
using it in resource
```
resource "aws_instance" "srv" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subnet_public.id
  vpc_security_group_ids      = [aws_security_group.sg_8080.id]
  associate_public_ip_address = true
  user_data                   = templatefile("user_data.tftpl", { department = var.user_department, name = var.user_name })
}
```


### terraform modules tips

By default, Terraform interprets the path relative to the current working directory
path.module - Returns the filesystem path of the module where the expression is defined.
path.root - Returns the filesystem path of the root module.
path.cwd - Returns the filesystem path of the current working directory
 
 
 ### Good to read blogs
- https://kevingimbel.de/blog/2021/06/validating-variables-in-terraform/#:~:text=%20Validating%20variables%20in%20terraform%20%201%20Syntax,alltrue%20and...%205%20Further%20reading.%20%20More%20
- https://faun.pub/azure-devops-deploying-azure-resources-using-terraform-1f2fe46c6aa0
- https://www.terraform.io/docs/language/values/variables.html#custom-validation-rules

### Best Practises
https://www.terraform-best-practices.com/
</br>
https://github.com/antonbabenko/terraform-best-practices
</br>
https://github.com/ozbillwang/terraform-best-practices
</br>
https://github.com/antonbabenko/terraform-best-practices-workshop
