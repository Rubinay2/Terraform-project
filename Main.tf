# Tenacity network configuration 

resource "aws_vpc" "Tenacity-VPC" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "Tenacity-VPC"
  }
}

# Creating Public Subnet

resource "aws_subnet" "Prod-pub-sub1" {
  vpc_id     = aws_vpc.Tenacity-VPC.id
  cidr_block = var.pub-sub1-cidr_block
  availability_zone = "eu-west-2a"

  tags = {
    Name = "Prod-pub-sub1"
    
  }
}

resource "aws_subnet" "Prod-pub-sub2" {
  vpc_id     = aws_vpc.Tenacity-VPC.id
  cidr_block = var.pub-sub2-cidr_block
  availability_zone = "eu-west-2b"

  tags = {
    Name = "Prod-pub-sub2"
  }
}

# Creating Private Subnets

resource "aws_subnet" "Prod-priv-sub1" {
  vpc_id     = aws_vpc.Tenacity-VPC.id
  cidr_block = var.prod-priv-sub1-cidr_block

  tags = {
    Name = "Prod-priv-sub1"
  }
}

resource "aws_subnet" "Prod-priv-sub2" {
  vpc_id     = aws_vpc.Tenacity-VPC.id
  cidr_block = var.prod-priv-sub2-cidr_block

  tags = {
    Name = "Prod-priv-sub2"
  }
}

# Creating public route table

resource "aws_route_table" "Prod-pub-route-table" {
  vpc_id = aws_vpc.Tenacity-VPC.id

  tags = {
    Name = "Prod-pub-route-table"
  }
}

# Creating Private Route Table

resource "aws_route_table" "Prod-priv-route-table" {
  vpc_id = aws_vpc.Tenacity-VPC.id

  tags = {
    Name = "Prod-priv-route-table"
  }
}

# Subnets and Route table associations

resource "aws_route_table_association" "public-route-association" {
  subnet_id      = aws_subnet.Prod-pub-sub1.id
  route_table_id = aws_route_table.Prod-pub-route-table.id
}

resource "aws_route_table_association" "public-route-association1" {
  subnet_id      = aws_subnet.Prod-pub-sub2.id
  route_table_id = aws_route_table.Prod-pub-route-table.id
}

resource "aws_route_table_association" "private-route-association" {
  subnet_id      = aws_subnet.Prod-priv-sub1.id
  route_table_id = aws_route_table.Prod-priv-route-table.id
}

resource "aws_route_table_association" "private-route-association1" {
  subnet_id      = aws_subnet.Prod-priv-sub2.id
  route_table_id = aws_route_table.Prod-priv-route-table.id
}


# Creation of internet Gateway

resource "aws_internet_gateway" "Prod-IGW" {
  vpc_id = aws_vpc.Tenacity-VPC.id

  tags = {
    Name = "Prod-IGW "
  }
}



# Public Route table and Internet Gateway Association

resource "aws_route_table" "Prod-pub-route-tabble-IGW" {
  vpc_id = "${aws_vpc.Tenacity-VPC.id}"
route {
    cidr_block = var.IG-cidr_block
    gateway_id = aws_internet_gateway.Prod-IGW.id
  }

}


# Creation of EIP for NAT Gateway

resource "aws_eip" "EIP_Tenacity" {
    vpc = true
    associate_with_private_ip = "var.eip_association_address"  
}


# Creation of NAT Gateway

resource "aws_nat_gateway" "Prod-Nat-gateway" {
    allocation_id = aws_eip.EIP_Tenacity.id 
    subnet_id = aws_subnet.Prod-priv-sub1.id
}


# Private Route Table and NAT Gateway Association

resource "aws_route_table_association" "b" {
  gateway_id     = aws_internet_gateway.Prod-IGW.id
  route_table_id = aws_route_table.Prod-pub-route-table.id
}



