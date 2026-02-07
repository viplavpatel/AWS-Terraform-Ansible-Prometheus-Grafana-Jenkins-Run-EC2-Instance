resource "aws_vpc" "vpc" { //creating VPC
  cidr_block = "172.16.0.0/16" //CIDR block for VPC

  tags = {
    Name = "vpc-example"
  }
}

//using a single subnet in one availability zone
resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "eu-west-2a"
  map_public_ip_on_launch =  true //to assign public IPs to instances launched in this subnet

  tags = {
    Name = "subnet-example"
  }
}

//to allow internet access
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw-example"
  }
}

//to route traffic to internet gateway
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

//to associate route table with subnet
resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.public_rt.id
}
//Security rules for inbound and outbound traffic
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.vpc.id
  
  # Inbound rule - SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] //allow from anywhere
  }
  
  # Inbound rule - HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # Inbound rule - Grafana
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound rule - Prometheus
  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound rule - Jenkins
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Outbound rule - Allow all
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "web-security-group"
  }
}

data "aws_ami" "amazon_linux_2" { //to get latest Amazon Linux 2023 AMI
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "ec2_instance" {
   ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.micro"
  
  subnet_id              = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  associate_public_ip_address = true //to associate public IP

  key_name = "linuxkey" //SSH key already created in AWS

  tags = {
    Name = "ec2-instance-example"
  }

  # Wait for SSH to be ready and instance to boot
  provisioner "remote-exec" {
    inline = [
      "echo 'Instance is ready!'"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${path.root}/linuxkey.pem")
      host        = aws_eip.ec2_ip.public_ip
    }
  }

  # Create Ansible inventory file automatically
  provisioner "local-exec" { // provisioner is used to execute local commands
    command = <<-EOT
      echo '[webservers]' > ${path.root}/inventory
      echo '${aws_eip.ec2_ip.public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=${path.root}/linuxkey.pem ansible_python_interpreter=/usr/bin/python3.9' >> ${path.root}/inventory
    EOT
  }

  # Run Grafana playbook from Windows/WSL
  /*provisioner "local-exec" {
    command = "ansible-playbook -i ${path.root}/inventory ${path.root}/playbooks/grafana.yml"
  }*/

  # Run Prometheus playbook from Windows/WSL
  provisioner "local-exec" {
    command = "ansible-playbook -i ${path.root}/inventory ${path.root}/playbooks/prometheus.yml"
  }

  # Run Jenkins playbook from Windows/WSL
  provisioner "local-exec" {
    command = "ansible-playbook -i ${path.root}/inventory ${path.root}/playbooks/jenkins.yml"
  }

  depends_on = [aws_eip.ec2_ip]
}

resource "aws_eip" "ec2_ip"{ //to assign static public IP
  domain = "vpc" //for VPC
  instance = aws_instance.ec2_instance.id
}