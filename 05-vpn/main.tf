resource "aws_key_pair" "vpn" {
  key_name   = "vpn"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDJU30dGg3ihXj7HSH9QG6Juz0MiAgbxpnZjy14Ie/xK0vQyPiBUOy48jUxbfkt1TcHN+fRE5wfniYv9vkT0Q9VPrpMXJeo3mJWBNqp41LUfPkbvxJRjhHmRg+/rlbhD8T1iSwmqzuE7TkuzbyYmsrLwFYgzcQqPeja1G8qUWJcBXJQdmdy6dDZ3u+ZAuLMRE6Rm5POCjSvCG67EXAdIWClIu27XGcoFap6a/+zYXSXfhVcu6FzRRZerW7IgIZ9w2vmNPMjrtdFSQsXe3HgejnwwdY+icLC6dy3TGNTWymFbhAhZDD5WfRJid6vnUZO5l8TDUvuuSQWfs1tPX0hMnjc0uMWWbr/1O6WwqQbYZR6ChhGrc8VzPA2CIwy//K2HmG7s0WnnR+6LGgcIp5h7cDB4NHWf8WOFf2FGwWLVrlJwynT3wq3uWtCY1O0LiFLLFHmn54YvBCsvUzGExxDgm6Ko6ec2rqEYEQhuGF0HVyfbD5e1boJ1bO+TE71qmX3NlhyN7UpKA5awQzJB/mjuMrcAp0h8ZMeTMt4jUwsl5VB32vcOFoxkTpvD5EK1X0f6gC5HROBSPvNoVlfonwAeHx31/c8mPEuhpGljWA8t6a/3csOF2ANNQg9TBd2zc+ovlEpZUy6pwdGruLRywhUEglbaqkktpvNaEyPf9WwUHU/UQ== 91995@saikumarsPC"
  # ~ means windows home directory
}

module "vpn" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  key_name = aws_key_pair.vpn.key_name
  name = "${var.project_name}-${var.environment}-vpn"

  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  # convert StringList to list and get first element
  subnet_id = local.public_subnet_id
  ami = data.aws_ami.ami_info.id
  
  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-vpn"
    }
  )
}