variable "region" {
  description = "the default region"
  type        = string
  default     = "eu-central-1"
}

variable "ami_pg" {
  description = "The ID of the AMI we are using for instances"
  type        = string
  default     = "ami-0c4c4bd6cf0c5fe52"
}

variable "ami_frontend" {
  description = "The ID of the AMI we are using for the frontend instance"
  type        = string
  default     = "ami-04e601abe3e1a910f"
}

variable "instance_type" {
  description = "the type of the instance"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "the key pair for our ec2 instance"
  type        = string
  default     = "terraformansible"
}

variable "name_pg" {
  description = "the name of the ec2 instance"
  type        = string
  default     = "db-postgress-01"
}

variable "name_front" {
  description = "the name of the fronend ec2 instance"
  type        = string
  default     = "app-01"
}

variable "env" {
  description = "The Enviroment"
  type        = string
  default     = "test"
}

variable "backend_sg" {
  description = "the name of the backend security group"
  type        = string
  default     = "backend"
}

variable "frontend_sg" {
  description = "the name of the frontend security group"
  type        = string
  default     = "frontend"
}


