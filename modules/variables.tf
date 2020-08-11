variable "region" {
  description = "region for aws resource"
  type = string
  default = ""
}

variable "vpc_id" {
  description = "VPC id"
  type = string
  default = ""
}


variable  "retention_in_days" {
    description = "default retention is 15 days"
    type = number
    default = 14
}