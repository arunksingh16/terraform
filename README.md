# Terraform 

Terraform Deployment Examples and advance topics.

### Why terraform in IaaC

- Terraform HCL is generic in respect to every cloud provider so it is easy to transfer knowledge or infra using same set of understanding. 
- In Cloud Deployment you may be using other tools or interacting with other technologies in that case ARM templates / CloudFormation wont help you but terraform can.
- Terraform is not perfect but improvement is continuous process.
- Resource created in dependen
- Single resource creation using CloudFormation or Azure ARM needs 100s of lines. This needs little more maintainibility effort and error prone process compare to few lines of code.
- Modular design promotes usability


### Greenfield vs Brownfield

In brownfield you may need to reverse engineer the process.

Terraform State -> Diff -> Define and HardCode -> Test (Smoke Test - Security Scan 


### Production Structure Scenerios 

- Use workspaces if required not mandatory though
- Use `terraform_remote_state` 
- Use `tf lint` or git precommit hook
- Use suitable design pattern
- Use `terraforming` cli for import if required 
- Lock specific version
- Use `terraform fmt` in precommit hook
- Use `terraform docs` to generate documentation
- Use saved `plan` for deployment
- To prevent resource deletion add `prevent_destroy`

### Using Terraform Modules

- Totally depends on your org. Org needs to decide how much level of abstraction they can afford.
- How much `terraform apply` will impact
- How much `terraform destroy` will impact
- Rate of change in your org
- Consider writing examples and tests
- Module depth

### terraform output and validate

`terraform output` values allow you to export structured data about your resources. You can use this data to configure other parts of your infrastructure with automation tools.
```
output "ami-1" {
  value = "${data.aws_ami.amazon_linux.id}"
}
```
o/p
```
$ terraform output                
ami-1 = "ami-087c17d1fe0178315"

$ terraform output -json
{
  "ami-1": {
    "sensitive": false,
    "type": "string",
    "value": "ami-087c17d1fe0178315"
  },
```
### terraform locals.
Terraform locals are named values that you can refer to in your configuration.  Terraform's locals don't change values during or between Terraform runs such as plan, apply, or destroy. Combining it with variables gives you more power.
```
locals {
  name_suffix = "${var.resource_tags["project"]}-${var.resource_tags["environment"]}"
}
```
### terraform resource lifecycle

- To prevent destroy operations for specific resources, you can add the prevent_destroy attribute to your resource definition.

```
resource "aws_instance" "example" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg_web.id]
  user_data              = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
  tags = {
    Name          = "terraform-learn-state-ec2"
    drift_example = "v1"
  }

 lifecycle {
   prevent_destroy = true
 }
}

```
- Create resources before they are destroyed

```
  lifecycle {
   create_before_destroy = true
  }

```

- Ignore changes
```
  lifecycle {
   ignore_changes        = [tags]
  }
}
```


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

### terraform_remote_state Data Source 

When possible, we recommend explicitly publishing data for external consumption to a separate location instead of accessing it via remote state.
```
data "terraform_remote_state" "stage-network" {
  backend = "s3"
  config = {
    bucket          = "mybket"
    key             = "stage/dev/terraform.tfstate"
  }
}

resource "aws_instance" "demo"
{
  subnet_id = "${data.terraform_remote_state.vpc.subnet_id}"
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

ex 2
Using slice function, it takes list as input and slice it. In the below example we are taking list `data.aws_availability_zones.available.names` and starting it from 0 and cutting it of with the number `var.subnet_count`
```
  azs = slice(data.aws_availability_zones.available.names, 0, var.subnet_count)
```

### Terraform Lock file

You should include the lock file in your version control repository to ensure that Terraform uses the same provider versions across your team and in ephemeral remote execution environments.



### terraform modules tips

By default, Terraform interprets the path relative to the current working directory
path.module - Returns the filesystem path of the module where the expression is defined.
path.root - Returns the filesystem path of the root module.
path.cwd - Returns the filesystem path of the current working directory
 


### terraform .gitignore

add following in your `.gitignore` file
```
.terraform
*.tfstate
*.tfstate.backup
```




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
