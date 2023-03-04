project-08-V1


# AWS 3 Tier Architecture
- 1 vpc
- 6 subnets
- 3 route tables
- 1 Internet gateway
- 1 nat gateway
- 4 security groups
- 1 RDS-server
- 2 App-severs
- 1 ALB with target group
- 1 bastion-server



## Step-A: VPC Complete Network Creation in Singapore-Region (ap-southeast-1)
- 1 vpc
- 6 subnets (2 public subnets, 2 private subnets, 2 database subnets)
- 1 route table for public subnets
- 1 route table for private subnets
- 1 route table for database subnets
- 1 Internet gateway
- 1 nat gateway


### Step-A-01: create vpc in Singapore-Region
- Name tag: pr8-vpc
- IPv4 CIDR: 10.0.0.0/16


### Step-A-02: create 6 subnets (2 public subnets, 2 private subnets, 2 database subnets)
- create 2 public subnets with these details:
	- VPC: pr8-vpc
	- Subnet name: public-subnet-1
	- Availability Zone: ap-southeast-1a
	- IPv4 CIDR block: 10.0.1.0/24
	-
	- Subnet name: public-subnet-2
	- Availability Zone: ap-southeast-1b
	- IPv4 CIDR block: 10.0.2.0/24
	
- create 2 private subnets with these details:
	- VPC: pr8-vpc
	- Subnet name: private-subnet-1
	- Availability Zone: ap-southeast-1a
	- IPv4 CIDR block: 10.0.3.0/24
	-
	- Subnet name: private-subnet-2
	- Availability Zone: ap-southeast-1b
	- IPv4 CIDR block: 10.0.4.0/24
	
- create 2 database subnets with these details:
	- VPC: pr8-vpc
	- Subnet name: database-subnet-1
	- Availability Zone: ap-southeast-1a
	- IPv4 CIDR block: 10.0.5.0/24
	-
	- Subnet name: database-subnet-2
	- Availability Zone: ap-southeast-1b
	- IPv4 CIDR block: 10.0.6.0/24


### Step-A-03: create 3 route tables 
- 1 route table for public subnets & attach both public subnets into this route table
	- Name: public-rt
	- VPC: pr8-vpc
	-
	- public-rt >> Subnet associations >> select public-subnet-1 & public-subnet-2 and >> save.

- 1 route table for private subnets & attach both private subnets into this route table
	- Name: private-rt
	- VPC: pr8-vpc
	-
	- private-rt >> Subnet associations >> select private-subnet-1 & private-subnet-2 and >> save.

- 1 route table for database subnets & attach both database subnets into this route table
	- Name: database-rt
	- VPC: pr8-vpc
	-
	- database-rt >> Subnet associations >> select public-subnet-1 & public-subnet-2 and >> save.



### Step-A-04: create 1 Internet gateway & add this `pr8-igw` into public-rt
- Name: pr8-igw
- create
- attach to `pr8-vpc`
- 
- public-rt >> Routes >> edit route >> add `pr8-igw` >> save.
	- 0.0.0.0/0		pr8-igw


### Step-A-05: create 1 nat gateway in `public-subnet-1` & attach this `pr8-nat-gw` into `private-rt`
- Name: pr8-nat-gw
- Subnet: public-subnet-1
- Connectivity type: public
- Elastic IP allocation ID: allocate elastic ip & select
- create.
- 
- private-rt >> Routes >> edit route >> add `pr8-nat-gw` >> save.
	- 0.0.0.0/0		pr8-nat-gw




## Step-B: create all security groups for all compute resources
- 1 security group for bastion-server
- 1 security group for pr8-alb(application-load-balancer)
- 1 security group for app-servers
- 1 security group for rds-server
- add here security groups architecture


### Step-B-01: create 1 security group for bastion-server
- Security group name: bastion-sg
- Description: Allow port 22 from anywhere
- VPC: pr8-vpc
- add rule:
	- ssh	22		anywhere	Description: Allow port 22 from anywhere
- tags: sg-for-bastion-server
- create


### Step-B-02: create 1 security group for ALB
- Security group name: ALB-SG
- Description: Allow port 80 from anywhere
- VPC: pr8-vpc
- add rule:
	- http	80	anywhere		Description: Allow port 80 from anywhere
- tags: sg-for-pr8-alb
- create



### Step-B-03: create 1 security group for app-servers
- Security group name: App-SG
- Description: Allow port 22 from bastion-sg and 80 from ALB-SG
- VPC: pr8-vpc
- add rule:
	- ssh	22		Description: allow-trrafic-from-bastion-sg-only
	- http	80		Description: allow-trrafic-from-ALB-SG-only
- tags: sg-for-app-servers
- create



### Step-B-04: create 1 security group for RDS-server
- Security group name: DB-SG
- Description: Allow port 3306 from App-SG only
- VPC: pr8-vpc
- add rule:
	- mysql		3306		Description: allow-trrafic-from-App-SG-only
- tags: sg-for-RDS-server
- create





## 


