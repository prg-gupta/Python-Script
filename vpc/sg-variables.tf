
####### VPC CIDR bloco #############
variable	 "vpc_cidr_blocks" {
  default     = "10.75.0.0/16"
  description = "CIDR  block of VPC"
}

############## blr office CIDR **************
variable "company_office_cidr_blocks" {
  default     = "10.0.0.0/8"
  description = "CIDR for Bangalore office"
}
############ MV office CID #################
variable "office_cidr_blocks" {
  default     = "10.5.0.0/16"
  description = "CIDR for Bangalore office"
}

########## Public CIRD ##################
variable "global_cidr_blocks" {
  default     = "0.0.0.0/0"
  description = "CIDR for global"
}
### Tags
variable "tag_name" {
  # SUN 01:00AM-02:00AM ET
  default = "companu"
}
variable "tag_environment" {
  # SUN 01:00AM-02:00AM ET
  default = "company"
}
variable "tag_application" {
  # SUN 01:00AM-02:00AM ET
  default = "company"
}
variable "tag_team" {
  # SUN 01:00AM-02:00AM ET
  default = "QA"
}

	
