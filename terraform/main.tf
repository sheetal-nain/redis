resource "aws_vpc" "VPC" {
 cidr_block = "10.0.0.0/16"
 
 tags = {
   Name = "Redis VPC"
 }
}

resource "aws_subnet" "public_subnet" {
 count             = length(var.public_subnet_cidr)
 vpc_id            = aws_vpc.VPC.id
 cidr_block        = element(var.public_subnet_cidr, count.index)
 availability_zone = element(var.azs, count.index)
 map_public_ip_on_launch = true
 
 tags = {
   Name = "Public Subnet ${count.index +1}"
 }
}
 
resource "aws_subnet" "Database_subnets" {
 count             = length(var.Database_subnet_cidrs)
 vpc_id            = aws_vpc.VPC.id
 cidr_block        = element(var.Database_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
 
 tags = {
   Name = "Database Subnet ${count.index + 1}"
 }
}

resource "aws_internet_gateway" "gw" {
 vpc_id = aws_vpc.VPC.id
 
 tags = {
   Name = "Redis VPC IG"
 }
}

resource "aws_route_table" "Public_rt" {
 vpc_id = aws_vpc.VPC.id
 
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.gw.id
 }
 
 tags = {
   Name = "Public Route Table"
 }
}

resource "aws_route_table_association" "public_subnet_asso" {
 count = length(var.public_subnet_cidr)
 subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
 route_table_id = aws_route_table.Public_rt.id
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gateway" {
  count             = 1 
  allocation_id = aws_eip.nat.id
  subnet_id    = aws_subnet.public_subnet[0].id
  
  tags = {
    "Name" = "Database subnet NAT"
  }
}

resource "aws_route_table" "Database_rt" {
 vpc_id = aws_vpc.VPC.id
 
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_nat_gateway.nat_gateway[0].id
 }
 
 tags = {
   Name = "Database Route Table"
 }
}


resource "aws_route_table_association" "Database_subnet_asso" {
 count = length(var.Database_subnet_cidrs)
 subnet_id      = element(aws_subnet.Database_subnets[*].id, count.index)
 route_table_id = aws_route_table.Database_rt.id
}

resource "aws_security_group" "redis_sg" {
  name        = "redis_security_group"
  description = "Allow Redis traffic"
  vpc_id     = aws_vpc.VPC.id 

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
   ingress {
    from_port   = 16379
    to_port     = 16384
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
  ingress {
    from_port   = 8080  
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80 
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22  
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  
  }
}

resource "aws_instance" "Database_server" {
 count             = length(var.Database_server)
 subnet_id      = element(aws_subnet.Database_subnets[*].id, count.index)
 ami = "ami-053b12d3152c0cc71"
 instance_type = "t3.micro"
 security_groups = [aws_security_group.redis_sg.id]
 key_name = "ninja"
  
 tags = {
   Name = "Database Server ${count.index + 1}"
 }
}

resource "aws_instance" "Public_server" {
    ami = "ami-053b12d3152c0cc71"
    subnet_id = aws_subnet.public_subnet[0].id
    instance_type = "t3.micro"
    key_name = "ninja"
    user_data = file("shell.sh")
    security_groups = [aws_security_group.redis_sg.id]
    
tags = {
   Name = "Public Server"
 }
}

resource "aws_lb_target_group" "redis_tg" { 
 name     = "Redis-tg"
 port     = 80
 protocol = "HTTP"
 vpc_id = aws_vpc.VPC.id
}

resource "aws_lb_target_group_attachment" "tg_attachment" {
  count            = length(var.Database_server)
  target_group_arn = aws_lb_target_group.redis_tg.arn
  target_id        = element(aws_instance.Database_server[*].id, count.index)
  port             = 80
}
  
resource "aws_lb" "redis_alb" {
 name               = "redis-alb"
 internal           = false
 load_balancer_type = "application"
 security_groups    = [aws_security_group.redis_sg.id]
 subnets = [
    aws_subnet.public_subnet[0].id,  
    aws_subnet.public_subnet[1].id   
  ]

 tags = {
   Environment = "dev"
 }
}

resource "aws_lb_listener" "redis_alb_listener" {
 load_balancer_arn = aws_lb.redis_alb.arn
 port              = "80"
 protocol          = "HTTP"

 default_action {
   type             = "forward"
   target_group_arn = aws_lb_target_group.redis_tg.arn
 }
}

terraform {
  backend "s3" {
    bucket  = "terraform-bucket-a"
    key     = "terraform.tfstate"
    region  =  "ap-south-1"
    encrypt = true
  }
}
data "aws_vpc" "default" {
  filter {
    name   = "isDefault"
    values = ["true"]
  }
}

################### VPC Peering Connection ###################

resource "aws_vpc_peering_connection" "Redis_to_default" {
  vpc_id        = aws_vpc.VPC.id
  peer_vpc_id   = data.aws_vpc.default.id
  auto_accept   = true

  tags = {
    Name = "Redis-to-default-peering"
  }
}

################### Routes for Tool VPC ###################

resource "aws_route" "tool_to_default_public" {
  route_table_id            = aws_route_table.Public_rt.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.Redis_to_default.id
}

resource "aws_route" "tool_to_default_private" {
  route_table_id            = aws_route_table.Database_rt.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.Redis_to_default.id
}

################### Default VPC Route Table Update ###################

data "aws_route_table" "default" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_route" "default_to_tool" {
  route_table_id            = data.aws_route_table.default.id
  destination_cidr_block    = aws_vpc.VPC.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.Redis_to_default.id
}



