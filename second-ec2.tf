resource "aws_network_interface" "web-server-nic2" {
    subnet_id = aws_subnet.subnet-2.id
    private_ips = [ "10.0.2.50" ]
    security_groups = [aws_security_group.allow_web2.id]
}

resource "aws_eip" "two" {
    vpc = true
    network_interface = aws_network_interface.web-server-nic2.id
    associate_with_private_ip = "10.0.2.50"
    depends_on = [aws_internet_gateway.gw2]
}

resource "aws_instance" "second-api-server-instance" {
    ami = "ami-08c40ec9ead489470"
    instance_type = "t2.micro"
    availability_zone = "us-east-1a"
    key_name = "main-key"

    network_interface {
      device_index = 0
      network_interface_id = aws_network_interface.web-server-nic2.id
    }
    
    user_data =  file("second-vm-bash-script.sh")

    tags = {
      Name = "second-api-server"
    }
}

# resource "aws_eip" "eip2" {
#   instance = aws_instance.second-api-server-instance.id
#   vpc      = true
# #   security_groups = [aws_security_group.allow_web.id]
# }