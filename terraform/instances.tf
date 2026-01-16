# Cari AMI ID Ubuntu 24.04 
data "aws_ami" "ubuntu_24" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

# 1. Web Server
resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.ubuntu_24.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_subnet.id
  private_ip             = "10.0.0.5"
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
  
  tags = { Name = "Web Server" }
}

resource "aws_eip" "web_eip" {
  instance = aws_instance.web_server.id
  domain   = "vpc"
}

# 2. Ansible Controller
resource "aws_instance" "ansible_controller" {
  ami                    = data.aws_ami.ubuntu_24.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private_subnet.id
  private_ip             = "10.0.0.135"
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  associate_public_ip_address = false
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name

  tags = { Name = "Ansible Controller" }
}

# 3. Monitoring Server
resource "aws_instance" "monitoring_server" {
  ami                    = data.aws_ami.ubuntu_24.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private_subnet.id
  private_ip             = "10.0.0.136"
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  associate_public_ip_address = false
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name

  tags = { Name = "Monitoring Server" }
}