# variables.tf

variable "aws_region" {
  description = "Región de AWS donde se desplegará la infraestructura"
  type        = string
  default     = "us-east-1"  # Recomendada para free tier
}

variable "key_name" {
  description = "Nombre del par de claves (Key Pair) para SSH"
  type        = string
  default     = "autohealing-key"  # Cambiar si usas otro nombre
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t3.micro"  # Elegible para free tier
}

variable "ami_id" {
  description = "AMI base para las instancias"
  type        = string
  default     = "ami-08a6efd148b1f7504"  # Amazon Linux 2 en us-east-1
}

variable "vpc_cidr" {
  description = "Bloque CIDR para la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_count" {
  description = "Número de subnets públicas a crear"
  type        = number
  default     = 2
}

variable "asg_min_size" {
  description = "Número mínimo de instancias en el Auto Scaling Group"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Número máximo de instancias en el Auto Scaling Group"
  type        = number
  default     = 1
}

variable "repo_url" {
  description = "URL del repositorio con los playbooks de Ansible"
  type        = string
  default     = "https://github.com/41R3/autohealing-infra-terraform-ansible.git"
}
