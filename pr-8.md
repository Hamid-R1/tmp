# AWS 3 Tier Architecture
- 



## Step-01: VPC Complete Network Creation in Singapore-Region (ap-southeast-1)
- 1 vpc
- 6 subnets (2 public subnets, 2 private subnets, 2 database subnets)
- 1 Internet gateway
- 1 route table for public subnets
- 1 route table for private subnets
- 1 route table for database subnets
- 1 nat gateway


### Step-01-A: create vpc in Singapore-Region
- Name tag: pr8-vpc
- IPv4 CIDR: 10.0.0.0/16


### Step-01-B: create 6 subnets (2 public subnets, 2 private subnets, 2 database subnets)
- create 2 public subnets with these details:
	- VPC: pr8-vpc
	- Subnet name: pr8-public-subnet-1
	- Availability Zone: ap-southeast-1a
	- IPv4 CIDR block: 10.0.1.0/24
	-
	- Subnet name: pr8-public-subnet-2
	- Availability Zone: ap-southeast-1b
	- IPv4 CIDR block: 10.0.2.0/24
- create 2 private subnets with these details:
	- VPC: pr8-vpc
	- Subnet name: pr8-private-subnet-1
	- Availability Zone: ap-southeast-1a
	- IPv4 CIDR block: 10.0.3.0/24

	- Subnet name: pr8-private-subnet-2
	- Availability Zone: ap-southeast-1b
	- IPv4 CIDR block: 10.0.4.0/24
- create 2 database subnets with these details:
	- VPC: pr8-vpc
	- Subnet name: pr8-database-subnet-1
	- Availability Zone: ap-southeast-1a
	- IPv4 CIDR block: 10.0.5.0/24

	- Subnet name: pr8-database-subnet-2
	- Availability Zone: ap-southeast-1b
	- IPv4 CIDR block: 10.0.6.0/24
