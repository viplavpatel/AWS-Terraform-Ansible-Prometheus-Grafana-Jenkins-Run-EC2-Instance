# AWS Infrastructure Automation with Terraform, Ansible & Jenkins

A complete CI/CD infrastructure automation project that provisions AWS resources using Terraform and configures monitoring tools using Ansible, all orchestrated through Jenkins.

##  Architecture Overview

This project demonstrates a modern DevOps workflow:
- **Infrastructure as Code (IaC)** with Terraform
- **Configuration Management** with Ansible
- **CI/CD Automation** with Jenkins
- **Cloud Platform**: AWS (VPC, EC2, Security Groups, Elastic IP)
- **Monitoring Stack**: Grafana, Prometheus

##  Features

- **Automated Infrastructure Provisioning**: Creates complete AWS networking and compute resources
- **GitOps Workflow**: Jenkins pulls code from GitHub and deploys automatically
- **Configuration Management**: Ansible playbooks for repeatable software installation
- **High Availability**: Elastic IP ensures persistent public access
- **Security**: Properly configured security groups with minimal required ports
- **Monitoring**: Pre-configured Grafana and Prometheus installation

##  Project Structure

```
aws mini project/
├── main.tf                          # Main Terraform entry point
├── providers.tf                     # AWS provider configuration
├── variables.tf                     # Variable definitions
├── terraform.tfvars                 # Variable values
├── modules/
│   └── Compute/
│       └── VirtualMachines/
│           ├── main.tf              # EC2, VPC, networking resources
│           ├── variables.tf         # Module variables
│           └── outputs.tf           # Module outputs
├── playbooks/
│   ├── grafana.yml                  # Grafana installation playbook
│   ├── prometheus.yml               # Prometheus installation playbook
│   └── jenkins.yml                  # Jenkins installation playbook
├── inventory                        # Ansible inventory file
├── aws_hosts                        # Auto-generated inventory (by Terraform)
└── ansible.cfg                      # Ansible configuration
```

## 🛠️ Technologies Used

| Category | Technology |
|----------|-----------|
| **IaC** | Terraform 1.x |
| **Cloud** | AWS (VPC, EC2, Security Groups, Elastic IP) |
| **Configuration Management** | Ansible 2.15+ |
| **CI/CD** | Jenkins |
| **Version Control** | Git, GitHub |
| **Operating System** | Amazon Linux 2023 |
| **Monitoring** | Grafana, Prometheus |

##  AWS Resources Created

- **VPC** with CIDR `172.16.0.0/16`
- **Subnet** with CIDR `172.16.10.0/24`
- **Internet Gateway** for internet access
- **Route Table** with public internet routing
- **Security Group** with ports:
  - 22 (SSH)
  - 80 (HTTP)
  - 3000 (Grafana)
  - 8080 (Jenkins)
  - 9090 (Prometheus)
- **EC2 Instance** (t3.small)
- **Elastic IP** for persistent public access

##  Prerequisites

- AWS Account with appropriate IAM permissions
- Terraform installed (v1.0+)
- Ansible installed (v2.15+)
- AWS CLI configured
- SSH key pair created in AWS (linuxkey)
- Git installed
- Jenkins server (can be installed via playbook)

##  Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/godsofhell/vnet-peering.git
cd "aws mini project"
```

### 2. Configure AWS Credentials

**Option A: Environment Variables (Linux/Mac)**
```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="eu-west-2"
```

**Option B: Environment Variables (Windows PowerShell)**
```powershell
$env:AWS_ACCESS_KEY_ID="your-access-key"
$env:AWS_SECRET_ACCESS_KEY="your-secret-key"
$env:AWS_DEFAULT_REGION="eu-west-2"
```

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Review Infrastructure Plan

```bash
terraform plan
```

### 5. Deploy Infrastructure

```bash
terraform apply
```

Type `yes` when prompted to confirm.

### 6. Configure Software with Ansible

After infrastructure is created, run Ansible playbooks:

```bash
# Install Grafana
ansible-playbook -i aws_hosts playbooks/grafana.yml

# Install Prometheus
ansible-playbook -i aws_hosts playbooks/prometheus.yml

# Install Jenkins
ansible-playbook -i aws_hosts playbooks/jenkins.yml
```

##  Jenkins Automation Workflow

Once Jenkins is set up:

1. **Configure Jenkins Job**:
   - Create a new Freestyle project
   - Connect to GitHub repository
   - Add build steps:
     - Execute Terraform commands
     - Run Ansible playbooks

2. **Automated Deployment**:
   - Push code to GitHub
   - Jenkins detects changes
   - Runs `terraform apply`
   - Executes Ansible playbooks
   - Infrastructure updated automatically

##  Access Your Services

After deployment, access services at:

- **Jenkins**: `http://<ELASTIC_IP>:8080`
- **Grafana**: `http://<ELASTIC_IP>:3000` (default: admin/admin)
- **Prometheus**: `http://<ELASTIC_IP>:9090`

Get your Elastic IP:
```bash
terraform output
```

##  Security Best Practices Implemented

-  SSH key-based authentication (no passwords)
-  Security groups with minimal required ports
-  Private subnet isolation (future enhancement ready)
-  Elastic IP for consistent access
-  AWS credentials managed via environment variables
-  Proper file permissions for SSH keys (chmod 400)

##  Testing

### Verify Terraform Deployment
```bash
terraform show
```

### Test Ansible Connectivity
```bash
ansible all -i aws_hosts -m ping
```

### Check Service Status (SSH to EC2)
```bash
ssh -i linuxkey.pem ec2-user@<ELASTIC_IP>
sudo systemctl status grafana-server
sudo systemctl status prometheus
sudo systemctl status jenkins
```

##  Troubleshooting

### Ansible SSH Permission Issues
If you get "UNPROTECTED PRIVATE KEY FILE" error:
```bash
chmod 400 linuxkey.pem
```

### Terraform AWS Credentials Error
Ensure AWS credentials are set in environment variables:
```bash
aws sts get-caller-identity  # Verify credentials work
```

### Jenkins Disk Space Warning
If Jenkins shows disk space warnings:
- Set threshold to 0 in Jenkins → Manage Jenkins → Configure System → Disk Space Monitoring

### Memory Issues on t3.micro
Upgrade to t3.small or t3.medium in `main.tf`:
```hcl
instance_type = "t3.small"
```

##  Future Enhancements

- [ ] Add S3 backend for Terraform state
- [ ] Implement AWS IAM roles instead of access keys
- [ ] Add auto-scaling group for high availability
- [ ] Implement blue-green deployment strategy
- [ ] Add CloudWatch monitoring and alerting
- [ ] Containerize applications with Docker
- [ ] Add SSL/TLS certificates with ACM
- [ ] Implement VPC peering for multi-region deployment

##  Key Learning Outcomes

This project demonstrates proficiency in:

1. **Infrastructure as Code**: Writing maintainable, version-controlled infrastructure
2. **Cloud Architecture**: Designing secure, scalable AWS environments
3. **Automation**: Eliminating manual deployment steps
4. **CI/CD Pipelines**: Building end-to-end automated workflows
5. **Configuration Management**: Ensuring consistent server configurations
6. **DevOps Best Practices**: GitOps, immutable infrastructure, automation

##  License

This project is open source and available under the MIT License.

##  Author

**Viplav Patel**
- GitHub: [@viplavpatel](https://github.com/viplavpatel)
- LinkedIn: [www.linkedin.com/in/viplav-patel-13b2812a9]

##  Acknowledgments

- HashiCorp for Terraform
- Red Hat for Ansible
- AWS for cloud infrastructure
- Jenkins community for CI/CD automation

---

** If you find this project useful, please consider giving it a star!**
