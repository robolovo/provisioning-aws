data "terraform_remote_state" "this" {
  backend = "s3"

  config {
    bucket = "robolovo-terraform"
    region = "ap-northeast-2"
    key    = "regional/vpc/terraform.tfstate"
  }
}