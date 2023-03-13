# Labs-ELB-All-Notes

### ===================  taken from udemy-stephen-mareek course  ==============================





### =================  Lab-1 for ALB  =======================
```
-launch 2 instance with 
	-amazon-linux-2, user-data=install apache server with index.html


-create application load balancer
	-one target group
	-one ALB

	
-ec2 >> target group >> 
	-Choose a target type:  Instances
	-Target group name:  demo-tg-alb
	-Protocol:  HTTP,	Port:  80
	-VPC:  default
	-Protocol version:  HTTP1
	-Health checks:  
		-Health check protocol:  HTTP
		-Health check path:  /
	-Advanced health check settings:
		-Port:  Traffic port
		-Healthy threshold:  5
		-Unhealthy threshold:  2
		-Timeout:  5
		-Interval:  30
	-next >>
	-select 2 available instances 
	-Ports for the selected instances:  80 
	-click on:  'Include as pending below'
	-create target group >> done.



-ec2 >> load balancer >> alb >>
	-Load balancer name:  DemoALB
	-Scheme:  Internet-facing
	-IP address type:  IPv4
	-Network mapping:
		-VPC: default
		-Mappings:  select 2 A.Z.(1a, 1b) with available subnetes (here we can add all 3 A.Z. with available subnetes)
	-Security groups: select security group which you will create below
		-create new SG with allow 80 from anywhere
	-Listeners and routing:
		-Protocol:  HTTP
		-Port:  80
		-Default action (forward to):  demo-tg-alb(select traget-group)
		-create load balancer >> done.
	
	-Next >> copy dns name of alb & paste to new tab & refresh >> yes load is distributed.
	
	-go to traget-group (demo-tg-alb) >> 
		-select: demo-tg-alb >> targets >> see here instances are healthy,
	
	-Next >> stop one instance && now go to traget-group & see health of instances
		-here health status is 'unused' (Target is in the stopped state)
		-if you go to tab & refresh page then we get html page from only one instance that is running, mtlb yha load 
		 balancer sirf ek hi instance ko target kr rha hai qki 2nd instance stop hai, so 2nd stoped instance ko 
		 traffic ni send kr rha,
	
	-Next >> start instance which you stoped earlier & go to traget-group & see health of instances
		 -here health status is healthy
		 -if you go to tab & refresh page then we get html page from both instance
	
	-Next >> see security group setup:
		-copy public ip of instance-1 & paste to new tab, yes here 'hello world' is shown, so here we want to get
		 traffic from dns name of 'DemoALB' only so how can we configure this, see next step:
		-see we have to route(security group of instances), so our both instances get traffic only from 'DemoALB' see 
		 below:
		-go to security group of instances and allow 'http' 80 port from 'security group of DemoALB' only & save, now
		 if you paste public ip of instances then we wont get 'hello world' but you are able to get traffic from 'DemoALB'
		 so this is how we can secure our instances,

	-Next >> 
		-go to load-balancer >> DemoALB >> Listeners >> click on 'HTTP:80' >> Rules >> click on 'manage rules' >>
			-click on '+/plus icon' >> click on 'insert rule' >> 
				-add condition >> path >> is:  /error
				-add action >> Return fixed response... >> 
					-Response code:  404
					-Content-Type:  text/plain
					-Response body:  not found custom error
				-click on 'save' >>done.
			-noted: so here we can add rules for routing based on path, host header, http header, query string,
		     source ip, and so on.
		-paste in new tab dns of DemoALB & refresh it & add this string at the end of url '/error' & enter, here you
		 get this text 'not found custom error' which you add earlier.
```				
		 

### =================  upto here Lab-1 for ALB  =======================








### =================  Lab-1 for NLB  =======================

```
-launch 2 instance with 
	-amazon-linux-2, 
	-allow-22-80-from-anywhere,
	-user-data=install apache server with index.html


-create network load balancer
	-one target group
	-one NLB

	
-ec2 >> target group >> 
	-Choose a target type:  Instances
	-Target group name:  demo-tg-nlb
	-Protocol:  TCP,	Port:  80
	-VPC:  default
	-Health checks:  
		-Health check protocol:  HTTP
		-Health check path:  /
	-Advanced health check settings:
		-Port:  Traffic port
		-Healthy threshold:  2
		-Unhealthy threshold:  2
		-Timeout:  2
		-Interval:  5
	-next >>
	-select 2 available instances 
	-Ports for the selected instances:  80 
	-click on:  'Include as pending below'
	-create target group >> done.
	


-ec2 >> load balancer >> nlb >>
	-Load balancer name:  DemoNLB
	-Scheme:  Internet-facing
	-IP address type:  IPv4
	-Network mapping:
		-VPC: default
		-Mappings:  
			-ap-southeast-1a (apse1-az2)
				-Subnet:  select available one
				-IPv4 address:  Assigned by AWS (Noted:here we can also use own elastic ip)
			-ap-southeast-1b (apse1-az1)
				-Subnet:  select available one
				-IPv4 address:  Assigned by AWS (Noted:here we can also use own elastic ip)
	-Imp Notes:  
		-in NLB if you are choose 'Internet-facing' then there is 'IPv4 settings', this is bcuz NLB has a one fixed/static 
		 ip address per AZ that you are deploying to, and you can either choose a ip address assigned by aws or you can 
		 choose elastic ip which you have.
		-Security groups is not available in NLB
	-Listeners and routing:
		-Protocol:  TCP
		-Port:  80
		-Default action (forward to):  demo-tg-nlb(select traget-group)
		-create load balancer >> done.
	
	-Next >> copy dns name of nlb & paste to new tab & refresh >> yes load is distributed, but yha load bas 1 hi instance
	 se aa rha hai r 1-2 minutes bad refresh krne se phir 2nd instance se traffic ata hai r usi pe stay rhta hai 2-3 minutes
	 tak, yani traffic 2-3 minutes tak 1 instance pe rhta h r phir 2-3 minut bad 2nd instance pe, stephen-mareek ka bhi
	 aisa hi hua tha but usne ni btaya reson.
```	
### =================  upto here Lab-1 for NLB  =======================








### =================  Lab for Stickiness  =========================
```
-Lab/Demo: for ELB Sticky Sessions or Stickiness
	-here hmne Application Load Balancer k liye jo infra create kiya tha usi me ye 'Stickiness' ka lab
	 kr rhe hai, see below:
	-ec2 >> target group >> demo-tg-alb >> Attributes >> edit >> Stickiness:
		-Stickiness:  enabled it
			-Stickiness type:  Load balancer generated cookie
			-Noted:here we have 2 'Stickiness type' 
				-Load balancer generated cookie
				-Application-based cookie
		-Stickiness duration: 1 days		#(1 second - 7 days)
		-save changes >> done.
	-Next >> open dns name in new tab & refresh, yes content is come from only one instance.
```
### =================  upto here Lab for Stickiness  =========================






### =====================  Cross-Zone Load Balancing  ==========================

```
-Lab/Demo: for Cross-Zone Load Balancing,

-ALB:
	-Imp Noted: Enabled by default (can be disabled at the Target Group level) 
	-ec2 >> select 'DemoALB' >> Attributes >> edit >>
		-Cross-zone load balancing: by default enabled,   #here we can not disabled it, but we can disabled at the
		 Target Group level, see below:
	-ec2 >> target group >> demo-tg-alb >> Attributes >> edit >> 
		-Cross-zone load balancing:  off		#(by default it is on)
			-Imp Notes: The load balancer sends traffic to targets in each zone independently. Stickiness cannot 
			 be turned on when cross-zone load balancing is turned off. yani 'Cross-Zone load balancing' off krna hai
			 to 'Stickiness' on ni ho skta.


-NLB:
	-ec2 >> select 'DemoNLB' >> Attributes >> edit >>
		-Cross-zone load balancing:  enabled 

		
-GLB:
	-Noted: here hmne 'GLB' ka demo ni kiya hai, but iska 'Cross-Zone Load balancing' enabled krne ka process same hai, 
	 jaise NLB ka h,
	-ec2 >> select 'DemoGLB' >> Attributes >> edit >>
		-Cross-zone load balancing:  enabled 
```

### =====================  upto here Cross-Zone Load Balancing  ==========================




### =====================  SSL/TLS - Basics  ===========================
```
-Lab/Demo: for SSL/TLS
	-here isne bas overview visit krk btaya hai ssl/tls install ni kiya hai, see details:
	
	-for ALB:
	-ec2 >> load balancer >> DemoALB >> Listeners >> Add Listener >> Listener details :
		-Protocol:  HTTPS
		-Port:  443
		-Default actions: 
			-Add action:  Forward
			-Target group:  demo-tg-alb
		-Secure listener settings:
			-Security policy:  ELBSecurityPolicy-2016-08        #(here having multiple options)
			-Default SSL/TLS certificate:
				-select:  From ACM
				-select:  select a certificate			#here we dont have any certificate so this Lab/Demo is incomplete,#
		-click on 'add' >> done.
		
	-for NLB:    (almost similar process as ALB)
	-ec2 >> load balancer >> DemoNLB >> Listeners >> Add Listener >> Listener details :
		-Protocol:  TLS
		-Port:  443
		-Default actions: 
			-Forward to:  demo-tg-nlb
		-Secure listener settings:
			-Security policy:  ELBSecurityPolicy-TLS13-1-2-2021-06 (recommended)        #(here having multiple options)
			-Default SSL/TLS certificate:
				-select:  From ACM
				-select:  select a certificate			#here we dont have any certificate so this Lab/Demo is incomplete,#
			-ALPN policy:  None
		-click on 'add' >> done.
```
### =====================  upto here SSL/TLS - Basics  ===========================





======== 

















