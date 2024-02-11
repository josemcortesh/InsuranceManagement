variable "ami_id" {
	type = string
	description = "AMI ID for the EC2 Instance"
}
variable "instance_name"{
	type = string
	description = "Name assigned to the instance"
}
variable "quantity"{
	type = number
	description = "Number of Instances to be created"
}
variable "keypair"{
	type = string
	description = "Key Pair to access EC2 instances"
}
