provider "aws" {
  region = var.region
}

locals {
cloudwatch_log_group_name = "vpc_flow_logs_${var.vpc_id}"
}

################################

resource "aws_flow_log" "this" {
  iam_role_arn    = aws_iam_role.vpc_flow_log_cloudwatch.arn
  log_destination = aws_cloudwatch_log_group.vpc_cloudwatch_lg.arn
  traffic_type    = "ALL"
  vpc_id          = var.vpc_id
}

################################

resource "aws_cloudwatch_log_group" "vpc_cloudwatch_lg" {

  name  = local.cloudwatch_log_group_name
  retention_in_days = var.retention_in_days

}


###########
# IAM Role
###########
resource "aws_iam_role" "vpc_flow_log_cloudwatch" {
  name_prefix        = "enable-vpc-flow-log-role-"
  assume_role_policy = data.aws_iam_policy_document.flow_log_cloudwatch_assume_role.json
}

data "aws_iam_policy_document" "flow_log_cloudwatch_assume_role" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    effect = "Allow"

    actions = ["sts:AssumeRole"]
  }
}


resource "aws_iam_role_policy_attachment" "vpc_flow_log_cloudwatch" {
  role       = aws_iam_role.vpc_flow_log_cloudwatch.name
  policy_arn = aws_iam_policy.vpc_flow_log_cloudwatch.arn
}


###########
# IAM Policy
###########
resource "aws_iam_policy" "vpc_flow_log_cloudwatch" {
  name_prefix = "vpc-flow-log-cloudwatch-"
  policy      = data.aws_iam_policy_document.vpc_flow_log_cloudwatch.json
}

data "aws_iam_policy_document" "vpc_flow_log_cloudwatch" {
  statement {
    sid = "AWSVPCFlowLogsPushToCloudWatch"

    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["*"]
  }
}

