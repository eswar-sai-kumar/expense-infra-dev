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
- EC2 → launch template → 

