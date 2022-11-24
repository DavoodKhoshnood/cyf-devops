resource "aws_network_interface" "web-server-nic" {
    subnet_id = aws_subnet.subnet-1.id
    private_ips = [ "10.0.1.50" ]
    security_groups = [aws_security_group.allow_web.id]
}

resource "aws_eip" "one" {
    vpc = true
    network_interface = aws_network_interface.web-server-nic.id
    associate_with_private_ip = "10.0.1.50"
    depends_on = [aws_internet_gateway.gw]
}

resource "aws_instance" "first-api-server-instance" {
    ami = "ami-08c40ec9ead489470"
    instance_type = "t2.micro"
    availability_zone = "us-east-1a"
    key_name = "main-key"

    network_interface {
      device_index = 0
      network_interface_id = aws_network_interface.web-server-nic.id
    }
    
    user_data =  file("first-vm-bash-script.sh")

    tags = {
      Name = "first-api-server"
    }
}

# resource "aws_eip" "eip" {
#   instance = aws_instance.first-api-server-instance.id
#   vpc      = true
# #   security_groups = [aws_security_group.allow_web.id]
# }