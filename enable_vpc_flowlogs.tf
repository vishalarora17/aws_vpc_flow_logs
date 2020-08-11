
module "enable_vpc_flowlogs_cmk" {
  source = "./modules"
  vpc_id = "vpc-xxxxxxx" # Enter your VPC ID
  region = "ap-south-1"
  retention_in_days = 7
}




