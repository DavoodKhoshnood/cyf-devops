resource "aws_vpc" "second-vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "second-API"
    }
}

resource "aws_internet_gateway" "gw2" {
  vpc_id = aws_vpc.second-vpc.id
}

resource "aws_route_table" "second-route-table" {
    vpc_id = aws_vpc.second-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw2.id
    }
    route {
        ipv6_cidr_block = "::/0"
        gateway_id = aws_internet_gateway.gw2.id
    }

    tags = {
        Name = "second"
    }
 }

resource "aws_subnet" "subnet-2" {
    vpc_id = aws_vpc.second-vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1a"

    tags = {
        Name = "prod-subnet2"
    }
}

resource "aws_route_table_association" "b" {
    subnet_id = aws_subnet.subnet-2.id
    route_table_id = aws_route_table.second-route-table.id
}

resource "aws_security_group" "allow_web2" {
    name = "allow_web_traffic2"
    description = "Allow web traffic"
    vpc_id = aws_vpc.second-vpc.id

    ingress {
        description = "HTTPs"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    ingress {
        description = "HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    tags = {
        Name = "allow_web2"
    }
}
