data "terraform_remote_state" "this" {
  backend = "s3"

  config = {
    bucket = "robolovo-test-terraform"
    region = "us-west-2"
    key    = "regional/vpc/terraform.tfstate"
  }
}
