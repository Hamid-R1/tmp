# VPC
resource "aws_vpc" "wp_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    "Name" = "pr8-vpc"
  }
}


# public subnet
resource "aws_subnet" "wp-public-subnet-1" {
  vpc_id            = aws_vpc.wp_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-southeast-1a"
  tags = {
    Name = "public-subnet-1"
  }
}


# Internet Gateway
resource "aws_internet_gateway" "wp_igw" {
  vpc_id = aws_vpc.wp_vpc.id
  tags = {
    "Name" = "pr8-igw"
  }
}


######################################################
# public route table
# public subnets association into public route table
# Add Internet Gateway into public route table
######################################################
# public route table
resource "aws_route_table" "wp-public-rt" {
  vpc_id = aws_vpc.wp_vpc.id
  tags = {
    "Name" = "public-rt"
  }
}

# Associate public subnet with public route table
resource "aws_route_table_association" "public_subnet_association-1" {
  route_table_id = aws_route_table.wp-public-rt.id
  subnet_id      = aws_subnet.wp-public-subnet-1.id
}


# Add Internet Gateway into public route table
resource "aws_route" "wp-route-igw" {
  route_table_id         = aws_route_table.wp-public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.wp_igw.id
}
