resource "aws_vpc" "devsu_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "devsu_vpc"
  }
}

resource "aws_internet_gateway" "devsu_igw" {
  vpc_id = aws_vpc.devsu_vpc.id

  tags = {
    Name = "devsu_igw"
  }
}

# ---- Subnets ----
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.devsu_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_a"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.devsu_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.devsu_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private_subnet"
  }
}
# ---- Subnets ----

# ---- Route Tables ----
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.devsu_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devsu_igw.id
  }

  tags = {
    Name = "public_route_table"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.devsu_vpc.id

  tags = {
    Name = "private_route_table"
  }
}
# ---- Route Tables ----

# ---- NAT ----
resource "aws_eip" "nat_eip_a" {}
resource "aws_eip" "nat_eip_b" {}

resource "aws_nat_gateway" "devsu_nat_gateway_a" {
  allocation_id = aws_eip.nat_eip_a.id
  subnet_id     = aws_subnet.public_subnet_a.id

  tags = {
    Name = "rancher_nat_gateway"
  }
}

resource "aws_nat_gateway" "devsu_nat_gateway_b" {
  allocation_id = aws_eip.nat_eip_b.id
  subnet_id     = aws_subnet.public_subnet_b.id

  tags = {
    Name = "rancher_nat_gateway"
  }
}
# ---- NAT ----

# ---- Route ----
resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.devsu_nat_gateway_a.id
}
# ---- Route ----

# ---- Route Table Association ----
resource "aws_route_table_association" "public_subnet_association_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_association_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}
# ---- Security Group ----
resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.devsu_vpc.id

  tags = {
    Name = "private_sg"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.public_sg.id]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

}

resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.devsu_vpc.id
  tags = {
    Name = "public_sg"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# ---- Security Group ----
