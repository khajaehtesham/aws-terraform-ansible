variable "vpc"{
    default = "172.16.0.0/16"
}
variable "region"{
    default = "us-east-1"
}



variable "availability_zone" {
  default = "us-west-2a"
}

variable "key_name" {
  default = "ec2-instance-key"
}


variable "size" {
  default = "t2.micro"
}

variable "subnet" {
  default = "172.16.10.0/24"
}