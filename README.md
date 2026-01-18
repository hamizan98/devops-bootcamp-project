# DevOps Bootcamp Final Project

## 1. Project Overview
Projek ini menunjukkan implementasi Automasi Infrastruktur (Terraform), Application & Configuration Management (Ansible), dan Domain & Cloudflare Configuration (Cloudflare).

## 2. Infrastructure Architecture (Final URLs)
- **Web Application URLs**: Host aplikasi di `https://web.jangaiman.com`
- **Monitoring Server**: Host Prometheus & Grafana di `https://monitoring.jangaiman.com`
- **Domain & Cloudflare Configuration**: Monitoring server tidak mempunyai akses awam (No Public IP Access) dan dilindungi oleh Cloudflare Tunnel dan Configuration IP Public Web Server point to web.jangaiman.com
- **GitHub repository URL**: https://github.com/hamizan98/devops-bootcamp-project

## 3.Preparation & Prerequisites of this Devops Bootcamp Project
- Have active AWS account, registered domain name added to Cloudflare and GitHub account.
- Got local tools such as Terraform, AWS CLI and Git

## 4. Step-by-step guide
- **Terraform – Infrastructure Provisioning**
a) Create an Amazon S3 bucket to store the Terraform state file at AWS Console:
-Bucket Name: devops-bootcamp-terraform-hamizanaimanbinhamid
-Region: ap-southeast-1

b) Configure Terraform backend to use the S3 bucket
-Refer backend.tf

c) Provision networking resources:
-VPC : Refer main.tf
-Public and private subnets: Refer main.tf
-Route tables: Refer main.tf
-Internet Gateway: Refer main.tf
-NAT Gateway: Refer main.tf

d) Create required security groups.
-Refer security.tf 

e) Provision EC2 instances:
-Web Server (public subnet + Elastic IP): Refer instances.tf
-Ansible Controller (private subnet): Refer instances.tf
-Monitoring Server (private subnet): Refer instances.tf

f) Enable AWS Systems Manager (SSM) access on all servers.
-Refer iam.tf

g) Create an ECR repository.
- Refer ecr.tf

h) Execute terraform init-->terraform plan-->terraform apply -auto-approve
-✅ At this stage, all infrastructure should be running successfully.

- **Application & Configuration Management (Ansible)**
a) Configure for access Ansible Controller via SSM
Refer iam.tf. This code will Ansible Controller, Web Server, & Monitoring Server able access via SSM

b) Install Ansible at Ansible Controller
-Execte command below:
sudo apt update && sudo apt upgrade -y
sudo apt install pipx
pipx install --include-deps ansible
pipx ensurepath

-Verify Ansible version after installation
ansible --version

c) Configure Ansible inventory private IP address
-Refer inventory.ini

d) Use Ansible to Install Docker on all relevant servers
-Refer install_docker.yml
-Run ansible-playbook -I inventory.ini install docker.yml

- **Build docker Image & Deploy**
a) Clone final project lab repo and build docker image : https://github.com/Infratify/lab-final-project 

b) Push to ECR
- Run command below on Ansible controller:
- sudo docker compose up --build -d
- aws ecr get-login-password --region ap-southeast-1 | sudo docker login --username AWS --password-stdin 147845229479.dkr.ecr.ap-southeast-1.amazonaws.com
- sudo docker tag lab-final-project-final-project:latest 147845229479.dkr.ecr.ap-southeast-1.amazonaws.com/devops-bootcamp/final-project-hamizanaimanbinhamid:latest
- sudo docker push 147845229479.dkr.ecr.ap-southeast-1.amazonaws.com/devops-bootcamp/final-project-hamizanaimanbinhamid:latest

c) Deploy it on web server
- run "ansible-playbook -i inventory.ini deploy_app.yml" on Ansible controller

d) Verify by access the web server public IP and should get the web page 
-<img width="911" height="987" alt="Web Server verify success" src="https://github.com/user-attachments/assets/f29d2225-db63-4f5a-ab20-0ec3d8628595" />
