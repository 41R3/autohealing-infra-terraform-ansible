# AutoHealing Infra Terraform + Ansible

**Self-healing AWS infrastructure with Terraform and Ansible**  
This project deploys an AWS infrastructure setup that automatically heals itself: EC2 instances in an Auto Scaling Group with monitoring and automation to keep everything running smoothly.

##  Features & Benefits

- **Auto-Healing Capability**: Automatically replaces failed instances
- **High Availability**: Load balancer distributes traffic across instances
- **Infrastructure as Code**: Fully reproducible with Terraform
- **Zero-Touch Configuration**: Ansible automates server setup
- **Cost Optimized**: Uses AWS Free Tier eligible resources
- **Resilient Architecture**: Survives instance failures without downtime

## Stack

- **Terraform**: Infrastructure provisioning
- **Ansible**: Server configuration
- **AWS Services**:
  - EC2 (t3.micro instances)
  - VPC & Subnets
  - Auto Scaling Groups
  - Application Load Balancer
- **GitHub**: Version control and CI/CD

##  Works

1. Terraform creates the infrastructure:
   - VPC with public subnets
   - Auto Scaling Group
   - Load Balancer
   - Security Groups
2. On instance launch:
   - User Data script clones this repo
   - Ansible playbook configures the server
   - Nginx installed with custom homepage
3. When an instance fails:
   - Auto Scaling Group detects failure
   - Terminates unhealthy instance
   - Launches new replacement
   - Ansible auto-configures new instance
4. Load Balancer routes traffic to healthy instances

### Prerequisites
- AWS account with IAM user
- AWS CLI configured (`aws configure`)
- Terraform installed
- SSH key pair in AWS

###  Deployment

1. **Clone the repository**:
```bash
git clone https://github.com/41R3/autohealing-infra-terraform-ansible.git
cd autohealing-infra-terraform-ansible
```

2. **Create SSH key pair**:
```bash
aws ec2 create-key-pair --key-name autohealing-key \
  --query 'KeyMaterial' --output text > ~/.ssh/autohealing-key.pem
chmod 400 ~/.ssh/autohealing-key.pem
```

3. **Configure variables**:
Edit `terraform/variables.tf` or create `terraform.tfvars`:
```hcl
aws_region   = "us-east-1"
key_name     = "autohealing-key"
instance_type = "t3.micro"
# Amazon Linux 2023 AMI (us-east-1)
ami_id       = "ami-0f34c5ae932e6f07e"
vpc_cidr     = "10.0.0.0/16"
subnet_count = 2
asg_min_size = 2
asg_max_size = 2
repo_url     = "https://github.com/41R3/autohealing-infra-terraform-ansible.git"
```

4. **Deploy infrastructure**:
```bash
cd terraform
terraform init
terraform apply -auto-approve
```

5. **Access your application**:
```bash
echo "http://$(terraform output -raw load_balancer_dns)"
```

### Testing 

1. **Get an instance ID**:
```bash
INSTANCE_ID=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=autohealing-instance" \
  --query "Reservations[0].Instances[0].InstanceId" --output text)
```

2. **Simulate failure**:
```bash
aws ec2 terminate-instances --instance-ids $INSTANCE_ID
```

3. **Monitor recovery**:
```bash
watch -n 5 "aws autoscaling describe-auto-scaling-instances \
  --query 'AutoScalingInstances[?contains(AutoScalingGroupName, \`$(terraform output -raw asg_name)\`)].{ID:InstanceId, Status:LifecycleState}' \
  --output table"
```

### Clean Up
```bash
terraform destroy -auto-approve
```

---

##   Structure
```
autohealing-infra-terraform-ansible/
├── terraform/                   # Infrastructure code
│   ├── main.tf                  # Primary infrastructure definitions
│   ├── outputs.tf               # Output variables
│   ├── variables.tf             # Configurable parameters
│   └── templates/
│       └── user_data.sh.tpl     # Instance initialization script
├── ansible/                     # Configuration management
│   ├── playbook.yml             # Main Ansible playbook
│   └── roles/
│       └── webserver/           # Web server setup role
│           ├── tasks/
│           │   └── main.yml     # Installation tasks
│           └── templates/
│               └── index.html.j2 # Homepage template
├── .gitignore                   # Files to exclude from version control
└── README.md                    # Project documentation
```

##  Notes

- **Free Tier Limitations**: Stay within AWS Free Tier limits
- **Educational Purpose**: Not for production use without modifications
- **Security**: This demo uses open security groups - tighten for production
- **Cost**: Always destroy resources when not in use (`terraform destroy`)



