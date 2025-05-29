# How to create target groups, load balancer, auto scaling manually in AWS

### Create 2 EC2 instance (AMI: RHEL-9-devops-practice, instance_type: t2.micro, sg: allow_everything, give below given user data also)

Below given are 2 user datas for 2 instances
```
sudo su -
dnf install nginx -y
systemctl enable nginx
systemctl start nginx
echo "<h1>This is from nginx-1</h1>" > /usr/share/nginx/html/index.html
```

```
sudo su -
dnf install nginx -y
systemctl enable nginx
systemctl start nginx
echo "<h1>This is from nginx-2</h1>" > /usr/share/nginx/html/index.html
```

### Create target group
- Target group → create → Instances → name (nginx) → default vpc → health check port (traffic port) → healthy threshold (2) → unhealthy threshold (2) → Interval → next → select instance → create

### Create LoadBalancer
- Load Balancer → appn load balancer → name (nginx) → Internet facing (public access) → VPC (select atleast 2 subnets) → sg (allow_everything) → Listeners (HTTP, 80, nginx) → create

### Stop the server and create image
- ec2 instance → actions → Image and templates → create image → name → create  

- We can see our image in AMI (owned by me)

### Launch template
- EC2 → launch template → name (nginx) → My AMIs → owned by me → AMI (created previously) → t2.micro → key pair (don't include) → sg (allow-everything) → adv details shut down behaviour (Terminate) → create

### Create auto scaling
- Auto Scaling → create → name → launch template(select template which created previously) → VPC (default) → AZ(us-east-1a) → next > attach to an existing load balancer → select target groups → health check grace period (10 sec) → next → desired capacity (2) → min desired capacity (2) → max desired capacity (10) → target tracking scaling policy → name → metric type (avd cpu utilization) → target value (75) → Instance warm up (60) → next → next → create




