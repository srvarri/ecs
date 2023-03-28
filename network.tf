# Create a VPC 

resource "aws_vpc" "engro" {
  cidr_block = "10.10.0.0/16"
    tags = {
    Name = "engro"
  }
}  


# Create a subnet  

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.engro.id 
  cidr_block = "10.10.1.0/24"

  tags = {
    Name = "public"
  }
  depends_on = [
    aws_vpc.engro
  ]
}

# Create InternetGateway 

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.engro.id 

  tags = {
    Name = "igw"
  }
}

# Create Route Table 

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.engro.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# create Route Table Association 

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.rt.id 
}

#Create Security Group 

resource "aws_security_group" "sgroup" {
  name        = "sgroup"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.engro.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "sgroup"
  }
}