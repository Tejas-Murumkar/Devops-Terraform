provider "aws" {
	region = "us-east-1"
	profile = "Devops_Rushi"
}
# create a iam user and group 
resource "aws_iam_user""First"{
	name = "Raj"
}

resource "aws_iam_user""Second"{
	name = "Rohan"
}

resource "aws_iam_user""Third"{
	name = "Nipun"
}

resource "aws_iam_user""fourth"{
	name = "Ali"
}

resource "aws_iam_group""friends"{
	name = "College"
}

resource "aws_iam_user_group_membership""memberadd1"{
	user = aws_iam_user.First.name
	
	groups = [
		aws_iam_group.friends.name
	]
}

resource "aws_iam_user_group_membership""memberadd2"{
	user = aws_iam_user.Second.name

	groups = [
		aws_iam_group.friends.name
	]

}

# create a s3 bucket with private ACL

resource "aws_s3_bucket" "bucket1" {
  bucket = "cap-buck-bucket"
}

resource "aws_s3_bucket_ownership_controls" "owner" {
  bucket = aws_s3_bucket.bucket1.id
  rule {
	object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "acl" {
	bucket = aws_s3_bucket.bucket1.id
	acl = "private"
   depends_on = [ aws_s3_bucket_ownership_controls.owner ]
}

# Create S3 bucket with public-read ACL 
resource "aws_s3_bucket" "bucket2" {
  bucket = "cap-buck-bucket-1"
}

resource "aws_s3_bucket_ownership_controls" "owner2" {
  bucket = aws_s3_bucket.bucket2.id
  rule {
	object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "public" {
  bucket = aws_s3_bucket.bucket2.id

  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false

}

resource "aws_s3_bucket_acl" "name" {
	depends_on = [ aws_s3_bucket_ownership_controls.owner2, aws_s3_bucket_public_access_block.public ]
	bucket = aws_s3_bucket.bucket2.id
	acl = "public-read"
}

resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"


    tags = {
        name = "aws_vpc",
    } 
}

resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true 

  tags = {
    name = "aws_subnet_1",
  }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = {
      name = "aws_internet_gateway_1"
    }
  
}


resource "aws_route_table" "RT1" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    
    }
  
}

resource "aws_route_table_association" "association" {
  subnet_id = aws_subnet.subnet1.id
  route_table_id = aws_route_table.RT1.id
}
# Launch the  on demand general purpose Instance 

resource "aws_security_group" "ssh" {
  name = "allow_Ssh"
  description = "Allow SSH access"
  vpc_id = aws_vpc.vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "inbound" {
  security_group_id = aws_security_group.ssh.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}

resource "aws_vpc_security_group_egress_rule" "outbound" {
  security_group_id = aws_security_group.ssh.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}
resource "aws_network_interface" "network" {
  subnet_id = aws_subnet.subnet1.id
  private_ip = "10.0.1.100/24"
}



data "aws_key_pair" "key" {
  key_name = "nat"
  include_public_key = true 

  filter {
    name = "tag:nat_nv"
    values = [ "N.virginia" ]
  }
}

output "fingerprint" {
  value = data.aws_key_pair.key.fingerprint
}

output "name" {
  value = data.aws_key_pair.key.key_name
}

output "id" {
  value = data.aws_key_pair.key.id
}

data "aws_ami" "ami" {
    most_recent = true
    owners = [ "amazon" ]
    
    filter {
      name = "name"
      values = [ "al2023-ami-2023.*-x86_64"]
    }
}

resource "aws_network_interface_sg_attachment" "sg2" {
  security_group_id = aws_security_group.ssh.id
  network_interface_id = aws_instance.instace.primary_network_interface_id
}
resource "aws_instance" "instace" {
  ami = data.aws_ami.ami.id
  instance_type = "t2.micro"
  key_name = "nat" 
  network_interface {
    network_interface_id = aws_network_interface.network.id
    device_index = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
}
