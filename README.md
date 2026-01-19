# DevOps Bootcamp Final Project

## 1. Project Overview
Projek ini menunjukkan implementasi Automasi Infrastruktur (Terraform), Application & Configuration Management (Ansible), dan Domain & Cloudflare Configuration (Cloudflare).

## 2. Infrastructure Architecture (Final URLs)
- **Web Application URLs**: Host aplikasi di `https://web.jangaiman.com`
- **Monitoring Server**: Host Prometheus & Grafana di `https://monitoring.jangaiman.com`
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

- **Monitoring & Observability**
By Using Ansible 

a) Deploy Prometheus & Grafana on the monitoring server using Docker.
- Refer prometheus.yml & deploy_monitoring.yml
- Run "ansible-playbook -i inventory.ini deploy_monitoring.yml"

b) Configure Grafana dashboards to visualize the metrics from Prometheus & Configure the Prometheus to collect data from the web server resources such as CPU usage, RAM usage and DISK usage.
1) Access Grafana: open http://localhost:3000 (Login: admin / admin)
<img width="1296" height="768" alt="Grafana verify" src="https://github.com/user-attachments/assets/d0af2cd2-23dd-4131-b081-69944fda427b" />

2) -Add Data Source:
-Click Add your first data source.
-Choose Prometheus.
-Insert URL: http://10.0.0.136:9090 (Use IP Private Monitoring Server).
-Click Save & Test.
3) -Import Dashboard:
-Click icon + (New) > Import.
-Key in ID: 1860 (Official Dashbord for Node Exporter that include CPU, RAM, and Disk).
-Click Load, choose data source Prometheus, dan click Import.

c) -Verify metrics are updating in real time.
-Open Prometheus at http://localhost:9090.
-Go to Status > Targets.
-Verify status 10.0.0.5:9100 is UP.
<img width="1905" height="308" alt="Prometheus verify" src="https://github.com/user-attachments/assets/f1a2ac04-97e9-41b1-bd2c-2f70a125855e" />

-Open Grafana at http://localhost:3000
-Go to Dashboards > Node Exporter Full
<img width="1894" height="907" alt="image" src="https://github.com/user-attachments/assets/8628ccfc-2682-438b-a05d-a7cbfd8f10ae" />

d) Use AWS SSM Port Forwarding
-Use AWS SSM Port Forwarding to access Prometheus & Grafana using http://localhost:9090 & http://localhost:3000 respectively.
-Run command below at laptop terminal Linux

(Terminal 1 For Grafana)
aws ssm start-session --target i-0ce12ba3ab2c7a3e8 \
--document-name AWS-StartPortForwardingSession \
--parameters '{"portNumber":["3000"],"localPortNumber":["3000"]}'
<img width="781" height="190" alt="image" src="https://github.com/user-attachments/assets/21a2b543-1130-4d06-be7f-dc7a899f8f05" />

(Terminal 2 For Prometheus)
aws ssm start-session --target i-0ce12ba3ab2c7a3e8 \
--document-name AWS-StartPortForwardingSession \
--parameters '{"portNumber":["9090"],"localPortNumber":["9090"]}'
<img width="766" height="187" alt="image" src="https://github.com/user-attachments/assets/be20541e-4e07-41e0-aed1-4b38ffce3aee" />

- **Domain & Cloudflare Configuration**
-Monitoring server tidak mempunyai akses awam (No Public IP Access) dan dilindungi oleh Cloudflare Tunnel dan Configuration IP Public Web Server point to web.jangaiman.com
a) Configure Cloudflare DNS. Point web.jangaiman.com to point the Web Server Elastic IP (52.220.121.68)
<img width="1869" height="1025" alt="image" src="https://github.com/user-attachments/assets/04d2d554-7fdc-49be-bd31-a663589ea815" />

b) Set Cloudflare SSL mode to Flexible
<img width="1814" height="766" alt="image" src="https://github.com/user-attachments/assets/94e2a526-697f-47a6-b27a-7a35093386a5" />

c) Create a Cloudflare Tunnel:
-Expose Grafana securely via monitoring.yourdomain.com & ensure no public access
<img width="1888" height="756" alt="image" src="https://github.com/user-attachments/assets/cb9d5dc9-47a2-4d22-a0cb-e05cd36f9c7f" />

d) Verify Web application accessible via domain
<img width="940" height="981" alt="image" src="https://github.com/user-attachments/assets/b8642539-7282-4ba0-8864-ad7c8c832d77" />

e) Grafana accessible only via Cloudflare Tunnel
<img width="1897" height="936" alt="image" src="https://github.com/user-attachments/assets/382c9c70-71b8-4afb-8595-f2f377003ce8" />





