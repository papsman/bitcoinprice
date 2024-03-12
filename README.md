Prerequisites:

Azure account with active subscription Terraform installed and configured kubectl installed


Step 1 - Deploy AKS Infrastructure:

Use the Terraform configuration files in terraform-test to start a an AKS cluster : **main.tf outputs.tf providers.tf ssh.tf variables.tf**

Detailed steps can be found in the terraformsetup.sh file.

Step 2 - Deploying apps and kubernetes services:

1. Create the docker images using the docker files in the folders serviceAdocker and serviceBdocker

2. Use the Deployment.yml file to create the Kubernetes deployment. It includes the bitcoin price app and the rest api service.
