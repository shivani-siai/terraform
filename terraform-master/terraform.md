#Get Started Terraform - AWS

##Introduction to Terraform
[Introduction to Infrastructure as Code with Terraform](https://learn.hashicorp.com/tutorials/terraform/infrastructure-as-code)

##Install Terraform

[Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

##Build Infrastructure

[Build Infrastructure](https://learn.hashicorp.com/tutorials/terraform/aws-build)

Some Important commands used:

```shell script
terraform init        #to initialize the current directory and download all the providers plugins 
terraform fmt         #updates configurations for easy readability and consistency
terraform apply       #for creating infrastructure
terraform show        #to show the created resources
terraform state list  #to list the resources created
```

## Change Infrastructure

[Change Inftrastructure](https://learn.hashicorp.com/tutorials/terraform/aws-change)

Here we have changed EC2 instance AMI-Id in which it deletes the previous instance and recreates the new one.

## Destroy Infrastructure

[Destroy Infrastructure](https://learn.hashicorp.com/tutorials/terraform/aws-destroy)

To destroy the overall infrastructure `terraform destroy`

## Input Variables

[Input Variables](https://learn.hashicorp.com/tutorials/terraform/aws-variables)

Usage of variables in the terraform script

## Query Data with Output Variables

[Query Data with Output Variables](https://learn.hashicorp.com/tutorials/terraform/aws-outputs)

To use the resource outputs for further queries.


# YouTube - [freeCodeCamp.org](https://www.youtube.com/watch?v=SLB_c_ayRMo)

```shell script
terraform plan  #dryrun
```

* The terraform shell commands will display some signs such as +(create resource), -(delete resource) and ~(modify resource).

* If we want to get rid of typing "yes" for the `terraform apply`, use `--auto-approve` flag with `terraform apply`.  Such as this `terraform apply --auto-approve`  

* The declaration of resource sequence in terraform script does not matter. We can define any resource in the script first and reference its id when required, it does not matter. Because Terraform is intelligent enough to handle that behalf of us.

* The .terraform folder contains the provider information, the terraform creates that folder after executing `terraform init` command. If anytime the .terrform folder gets deleted, execute the `terraform init` command again for creating that folder

* The terraform.tfstate file stores the infrastructure status and resources state. Never mess with this file.

* To list all resources that are created by terraform script use `terraform state list` command. To get the details for any particular resource use `terraform state show "state-resource-name"`

* To delete just the particular resource from the terraform script, use `terraform destroy -target aws_resourcename.terraform-resource-name` command

* To relaunch the particular resource again in the infrastructure, use `terraform apply -target -target aws_resourcename.terraform-resource-name` command

* To refresh the terraform state, use `terraform refresh` command

* To provide some inputs on terminals after `terraform apply`, use variables as specified in [main.tf](./youtube/main.tf). The default variable file is [variable file](youtube/terraform.tfvars)

* If we need to provide only input or type the string character manually on the terminal for the variable, then use `type = string` in the variable block, which is shown is this file [main.tf](./youtube/main.tf) 1st Way

* If we need to specify the list of variables in the variables file which is also shown in the [variable file](youtube/terraform.tfvars). Also check the [main.tf](./youtube/main.tf) how we have used the list variables for the subnets cidr. 2nd Way

* If we need to use both strings and list at the same type for same variable see 3rd Way in both [variable file](youtube/terraform.tfvars) [main.tf](./youtube/main.tf) 

* To provide variables while executing `terraform apply`, use `terraform apply -var "subnet-cidr=10.0.1.0/24"`

* To provide our custom variable file, provide variable flag while executing the `terraform apply` command. Such as 
`terraform apply -var-file "custom-var-file"`


# Udemy: Hashicorp Terraform Certified - Zeal Vora

## Chapter 3: Deploying Infrastructure with Terraform

Authentication for AWS can be done using the following methods:
1. Static Credentials
2. Environment Variables
3. Shared Credentials file
4. EC2 Role

* Whenever we define a new provider or modify the provider versions, always execute `terraform init` command after the changes has been made. 

* Resources are the references to the individual series which the provider has to offer.
Example:
    * resource aws_instance - to create aws ec2 instance
    * resource aws_alb - to create aws application load balancer
    * resource iam_user - to create aws iam user
    * resource digitalocean_droplet - to create droplet server 
    
* Destroying Specific Resource `terraform destroy -target aws_instance.myec2`

### State Files

* Terraform stores the state of the infrastructure that is being created from the TF files. 
* This state allows terraform to map real world resource to our existing configuration.
* Whenever a resource is created or deleted, the terraform stores the resources status in the terraform state file. If a resource is deleted, the terraform will also delete its associated state file as well.

* **Desired States and Current States**
    * Desired State: The state which we have mentioned within the resource block in our tf files.

    * Current States: The state which is currently on AWS. For example, if we have created an instance with t2.micro and some random guy changes the type of the AWS EC2 t2.micro to t2.nano. Then our desired state which is written in the terraform tf file is not the same as the current state. So to update the desired state within the terraform.tfstate file to the current state use `terraform refresh` command. So that the AWS EC2 instance which was t2.micro in the terraform.tfstate file which update to the t2.nano. Now, the terraform.tfstate file has the cuurent state which is modified t2.nano. But in the ec2.tf file it is still t2.micro. So to change the t2.nano to t2.micro on the AWS. Use `terraform plan` command, which will show the difference and then use `terraform apply` command. 
    
* To see the contents of your tfstate files: `terraform show`


## Provider Versioning

* Provider plugins are released separately from Terraform itself
* They have different set of version numbers 
* During terraform init, if version flag is not specified, the most recent provider will be downloaded during the initialization.
* For production use, we should constrain the acceptable provider versions via configuration, to ensure that new versions with breaking changes will no be automatically installed. *It is best practice to provide the provder version flag.*
 For example:
 
 ```hcl-terraform
provider "aws" {
region = "eu-west-1"
version = "2.7"
}
```

* Arguments for Specifying provider: There are multiple ways for specifying the version of a provider.

![Provider Versions](./hashicorp-terraform(zealvora)/videos-screenshots/providerversion.png)


## Provider Type

* There are two major categories for terraform providers

```plantuml
digraph Test {
"Terraform Providers" -> "HashiCorp Distributed"
"Terraform Providers" -> "Third Party(Community Provider)"
}
```

* **Overview of 3rd Party Provider**
    * It can be happen that the official provider do not support a specific functionality
    * Some organizations might have their proprietary platform for which they want to use Terraform.
    * For such cases, individuals can decide to develop / use 3rd Party providers
    * *Third-Party providers must be manually installed,* since terraform init cannot automatically download them.
    * Install third-party providers by placing their plugin executables in the user plugins directory(~/.terraform.d/plugins).
    

# Chapter 4: Read, Generate, Modify Configurations

## Attributes and Output Values

* Terraform has the capability to output the attribute of a resource with the output values.

* An outputed attribute cannot only be used for the user reference but it can also act as a input to other resources being created via terraform.

* For example: After EIP(Elastic IP Address) gets created, its IP address should automatically get whitelisted in the security group.

## Variables

* Repeated static values can create more work in the future.

![Variables](./hashicorp-terraform(zealvora)/videos-screenshots/variables.png)

* We can have a central source from which we can import the values from.