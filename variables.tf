variable "aws_region" {
  type        = string
  default     = "us-west-2"
  description = "Default AWS region for use in my free-tier account"
}

variable "aws_cred_file" {
  type    = string
  default = "/c/Users/Pavel_Lysianok/.aws"
  description = "Default path to AWS credential file"

}
