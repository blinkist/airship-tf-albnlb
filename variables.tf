
variable "shortname" {
	description = "Give a shortname which can be used for naming"
}

variable "subnets" {
	description = "Which subnets are the load balancer instances in" 
 	type = "list"
}

variable "lb_type" {
	description = "What type of load balancer is this, ALB or NLB, options are  application or network" 
}
variable "health_uri" {
	description = "In case of a HTTP backend, can a health URI be used"
}

variable "vpc_id" {
	description = "What is the VPC id of the VPC we are operating in"
}

variable "lb_sg_id" {
	description = "What is the security group of the load balancer (only application), empty in case of NLB"
}

variable "cluster_name" {
	description = "What is the cluster name this LB is attached to"
}

variable "internal"    { 
	description = "Is this an internal facing Load balancer, defaults to false"
	default = "false" 
}
variable "ssl_enabled" { 
	description = "For ALB, do we have SSL Enabled? Defaults to false"
	default = "false" 
}
variable "ssl_arn" { 
        default = "" 
	description = "For ALB, do we have SSL Enabled? Defaults to false"
}
