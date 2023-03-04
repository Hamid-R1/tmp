project-08-V1


# AWS Infra Architecture for this project
![Untitled Diagram drawio (25)](https://user-images.githubusercontent.com/112654341/222919120-badf7588-0589-49de-a8d0-fc88a059d092.png)

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


![Untitled Diagram drawio (23)](https://user-images.githubusercontent.com/112654341/222919709-71b2828d-ac46-4694-af8c-76a31df782af.png)


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





## Step-C: create rds instance with mysql engine
- create subnet-group for rds-server
- create rds-server with mysql engine



### Step-C-01: create subnet-group for rds-server
- Name: db-subnet-group
- Description: db-subnet-group-for-rds-server
- VPC: pr8-vpc
- Availability Zones: 
	- ap-southeast-1a:	database-subnet-1(10.0.5.0/24)
	- ap-southeast-1b:	database-subnet-2(10.0.6.0/24)
- create.



### Step-C-02: create rds-server with mysql engine
- Choose a database creation method:  Standard create
- Engine type:  MySQL
- Templates:  Free tier
- DB instance identifier:  rds-server
- Master username:  admin
- Master password:  Project8
- DB instance class:  db.t3.micro
- Storage type:  gp2
- Allocated storage:  20GB
- Storage autoscaling:  disable
-
- Compute resource:  Don’t connect to an EC2 compute resource
- Network type:  IPv4
- Virtual private cloud (VPC):  pr8-vpc
- DB subnet group:  db-subnet-group
- Public access:  No
- VPC security group (firewall):  DB-SG
- Availability Zone:  ap-southeast-1a
- Database port:  3306
- Database authentication options:  Password authentication
- Initial database name:  HR_RDS_DB
- Rest things:  default
- create database.




## Step-D: create 2 ec2-instances in private-subnets
- launch 1 ec2-instance in `private-subnet-1`
	- Name:  app-server-1
	- ami:  amazon-linux-2
	- Instance type:  t2.micro
	- Key pair:  wp-project (select existing one)
	- VPC:  pr8-vpc
	- subnet:  private-subnet-1
	- Auto-assign public IP:  Disable
	- Firewall (security groups) :  App-SG (select existing one)
	- launch instance.
-
- launch 1 ec2-instance in `private-subnet-2`
	- Name:  app-server-2
	- ami:  amazon-linux-2
	- Instance type:  t2.micro
	- Key pair:  wp-project (select existing one)
	- VPC:  pr8-vpc
	- subnet:  private-subnet-2
	- Auto-assign public IP:  Disable
	- Firewall (security groups) :  App-SG (select existing one)
	- launch instance.




## Step-E: create Application load-balancer
- create target group
- create alb


### Step-E-01: create target group
- Choose a target type:  Instance
- Target group name:  pr8-target-group
- Protocol:  HTTP,		Port:  80
- VPC:  pr8-vpc
- 
- Healthy threshold:  3
- Unhealthy threshold:  2
- Timeout:  2
- Interval: 5
-
- Register targets: select both available instances & click on `Include as pending below`
- create target group.



### Step-E-02: create alb
- Load balancer types:  Application Load Balancer
- Load balancer name:  pr8-alb
- Scheme: Internet-facing
- IP address type: IPv4
- VPC:  pr8-vpc
- Mappings:  
	- A.Z.:  ap-southeast-1a,		Subnet:  public-subnet-1
	- A.Z.:  ap-southeast-1b,		Subnet:  public-subnet-2
- Security groups:  ALB-SG
- Listeners and routing: 
	- Protocol: HTTP     Port: 80      Forward to: pr8-target-group
- create load balancer.



## Step-F: create bastion-server
- to be continue...............



## Step-G: Deploy application and configure to make available for end-users
- to be continue...............
	







