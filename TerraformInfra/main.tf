provider "aws" {
	region = "us-east-1"
}

resource "aws_security_group" "SG_WORKER"{
	name = "sg_worker"
  	description = "Allow inbound traffic on port TCP-22 and ICMP"

  	ingress {
		description		= "SSH"
		from_port		= 22
		to_port			= 22
		protocol		= "tcp"
		cidr_blocks		= ["0.0.0.0/0"]
	}
	ingress {
		description		= "ICMP"
		from_port		= -1
		to_port			= -1
		protocol		= "icmp"
		cidr_blocks		= ["0.0.0.0/0"]
	}
	ingress{
		description		= "HTTP-APP"
		from_port		= 80
		to_port			= 80
		protocol		= "tcp"
		cidr_blocks		= ["0.0.0.0/0"]
	}
	egress {
		from_port		= 0
		to_port			= 0
		protocol		= "-1"
		cidr_blocks		= ["0.0.0.0/0"]
	}
}

resource "aws_instance" "WorkerEC2" {
	count = var.quantity
	ami = var.ami_id
	instance_type = "t2.micro"
	key_name = var.keypair	
	tags = {
		Name = "${var.instance_name}-${count.index}"
	}
}

resource "aws_network_interface_sg_attachment" "SG_Workers_Attachement" {
	count = var.quantity
	security_group_id = aws_security_group.SG_WORKER.id
	network_interface_id = aws_instance.WorkerEC2[count.index].primary_network_interface_id
}
