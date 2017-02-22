
variable "vpc_cidr" {
  default  = "0.0.0.0/16"
  description = "This is us-west-2 vpc id"
}
variable "private-sub-1" {
  default     = "0.0.0.0/19"
  description = "This is private subnet in us-west-2a"
}

variable "private-sub-2" {
  default     = "0.0.0.0/19"
  description = "This is private subnet in us-west-2b"
}
variable "private-sub-3" {
  default     = "0.0.0.0/19"
  description = "This is private subnet in us-west-2c"
}

variable "public-sub-1" {
  default     = "10.0.0.0/19"
  description = "This is public subnet in us-west-2a"
}

variable "public-sub-2" {
  default     = "10.96.128.0/19"
  description = "This is public subnet in us-west-2b"
}
variable "public-sub-3" {
  default     = "10.96.160.0/19"
  description = "This is public subnet in us-west-2b"
}


variable "az_a" {
  default     = "us-west-2a"
  description = "This us-west-2b zone"
}

variable "az_b" {
  default     = "us-west-2b"
  description = "this is us-west-2b zone"
}
variable "az_c" {
  default     = "us-west-2c"
  description = "this is us-west-2b zone"
}

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-west-2"
}

variable "num_nat_gateways" {
    description = "Number of NAT"
    default = "3"
}

