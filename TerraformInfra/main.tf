provider "aws" {
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
	
	user_data = <<-EOF
		#!/bin/bash
		
		#Install Docker Repo
		curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
		echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

		#Update repos
		sudo apt-get update

		#Install Docker
		apt-cache policy docker-ce
		sudo apt install docker-ce -y

		#Start Services
		sudo systemctl start docker

		#Allow current user (ansiuser) to run docker commands without sudo
		sudo usermod -aG docker ansiuser
		su - ansiuser

		sudo apt-get dist-upgrade -y
		sudo reboot
	EOF

	tags = {
		Name = "${var.instance_name}-${count.index}"
	}
}

resource "aws_network_interface_sg_attachment" "SG_Workers_Attachement" {
	count = var.quantity
	security_group_id = aws_security_group.SG_WORKER.id
	network_interface_id = aws_instance.WorkerEC2[count.index].primary_network_interface_id
}
