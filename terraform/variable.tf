variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "db-name" {
  type = string
  default = "terraform-state-lock"
}
