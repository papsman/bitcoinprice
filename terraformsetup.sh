# Ensure that your system is up to date and you have installed the gnupg, software-properties-common, 
# and curl packages installed. You will use these packages to verify HashiCorp's GPG signature and install HashiCorp's Debian package repository.

sudo apt-get update && sudo apt-get install -y gnupg software-properties-common


# Install the HashiCorp GPG key.
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null


# Verify the key's fingerprint.
gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint


# Add the official HashiCorp repository to your system. The lsb_release -cs command finds the distribution release codename for your current system, such as buster, groovy, or sid.

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update


sudo apt-get install terraform

terraform -l


# run from terraform folder
terraform init -upgrade


terraform plan -out main.tfplan


terraform apply main.tfplan


resource_group_name=$(terraform output -raw resource_group_name)


az aks list --resource-group $resource_group_name --query "[].{\"K8s cluster name\":name}" --output table

# Get the Kubernetes configuration from the Terraform state and store it in a file that kubectl can read using the following command.

echo "$(terraform output kube_config)" > ./azurek8s

cat ./azurek8s

# If you see << EOT at the beginning and EOT at the end, remove these characters from the file. Otherwise, you may receive the following error message: error: error loading config file "./azurek8s": yaml: line 2: mapping values are not allowed in this context


export KUBECONFIG=~/microsoft/terraform-test/azurek8s

. ~/.bashrc
printenv | grep ^KUBE*

# Install Kubectl

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl


# Install kubeadm

sudo apt-get update
# apt-transport-https may be a dummy package; if so, you can skip that package
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
# If the folder `/etc/apt/keyrings` does not exist, it should be created before the curl command, read the note below.
# sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg


echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl



# install helm


curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh



kubectl get service --namespace default ingress-nginx-controller --output wide --watch

# Check RBAC on aks

az aks show -g rg-saved-roughy -n cluster-gorgeous-sponge | grep enableAzureRbac
