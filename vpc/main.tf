resource "aws_vpc" "lab_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "Lab VPC"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id = aws_vpc.lab_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Public Subnet 1"
  }
}

# second AZ
resource "aws_subnet" "public_subnet_2" {
  vpc_id = aws_vpc.lab_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "Public Subnet 2"
  }
}

# Web App
resource "aws_subnet" "private_subnet_1" {
  vpc_id = aws_vpc.lab_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Private Subnet 1"
  }
}

# Web App - us-east1b
resource "aws_subnet" "private_subnet_3" {
  vpc_id = aws_vpc.lab_vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "Private Subnet 3"
  }
}

resource "aws_internet_gateway" "gw_1" {
  vpc_id = aws_vpc.lab_vpc.id

  tags = {
    Name = "Gateway 1"
  }
}

resource "aws_eip" "nat_eip" {
  domain   = "vpc"
}


resource "aws_eip" "nat_eip_2" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "nat_gw_1" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "gw NAT"
  }

  depends_on = [aws_internet_gateway.gw_1]
}

resource "aws_nat_gateway" "nat_gw_2" {
  allocation_id = aws_eip.nat_eip_2.id
  subnet_id     = aws_subnet.public_subnet_2.id

  tags = {
    Name = "gw NAT 2"
  }

  depends_on = [aws_internet_gateway.gw_1]
}

resource "aws_route_table" "route_table_1" {
  vpc_id = aws_vpc.lab_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw_1.id
  }

  tags = {
    Name = "Main route table for public subnet 1"
  }
}

resource "aws_route_table" "route_table_2" {
  vpc_id = aws_vpc.lab_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_1.id
  }

  tags = {
    Name = "Route table for private subnet 1"
  }
}

resource "aws_route_table_association" "public_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.route_table_1.id
}

resource "aws_route_table_association" "private_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.route_table_2.id
}

resource "aws_route_table_association" "public_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.route_table_1.id
}

resource "aws_route_table_association" "private_association_2" {
  subnet_id      = aws_subnet.private_subnet_3.id
  route_table_id = aws_route_table.route_table_2.id
}