# VPC
resource "aws_vpc" "ohio_vpc" {
  provider = aws.us-east-2
  cidr_block           = "172.31.0.0/16"
  enable_dns_hostnames = true
  tags = {
    "Name" = "ohio-pr8-vpc"
  }
}


# public subnet
resource "aws_subnet" "ohio-public-subnet-1" {
  provider = aws.us-east-2
  vpc_id            = aws_vpc.ohio_vpc.id
  cidr_block        = "172.31.1.0/24"
  availability_zone = "us-east-2a"
  tags = {
    Name = "public-subnet-1"
  }
}


# Internet Gateway
resource "aws_internet_gateway" "ohio_igw" {
  provider = aws.us-east-2
  vpc_id = aws_vpc.ohio_vpc.id
  tags = {
    "Name" = "ohio-pr8-igw"
  }
}


######################################################
# public route table
# public subnets association into public route table
# Add Internet Gateway into public route table
######################################################
# public route table
resource "aws_route_table" "ohio-public-rt" {
  provider = aws.us-east-2
  vpc_id = aws_vpc.ohio_vpc.id
  tags = {
    "Name" = "ohio-public-rt"
  }
}

# Associate public subnet with public route table
resource "aws_route_table_association" "public_subnet_association-1" {
  provider = aws.us-east-2
  route_table_id = aws_route_table.ohio-public-rt.id
  subnet_id      = aws_subnet.ohio-public-subnet-1.id
}


# Add Internet Gateway into public route table
resource "aws_route" "ohio-route-igw" {
  provider = aws.us-east-2
  route_table_id         = aws_route_table.ohio-public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ohio_igw.id
}
