variable "region" {
  default = "eu-west-2"
  description = "AWS Region"
}

# Creating variables for VPC CIDR block.
variable "cidr_block" {
  default = "10.0.0.0/16"
  description = "VPC cidr_block"
}

# Creating variables for public Subnets

variable "pub-sub1-cidr_block" {
  default = "10.0.1.0/24"
  description = " Prod-pub-sub1"
}


variable "pub-sub2-cidr_block" {
  default = "10.0.2.0/24"
  description = " Prod-pub-sub2"
}

# Creating variables for private Subnets

variable "prod-priv-sub1-cidr_block" {
  default = "10.0.3.0/24"
  description = "Prod-priv-sub1"
}


variable "prod-priv-sub2-cidr_block" {
  default = "10.0.4.0/24"
  description = "Prod-priv-sub2"
}

# creating variables for Internet Gateway

variable "IG-cidr_block" {
  default = "0.0.0.0/0"
  description = "Internet-Gateway"
}