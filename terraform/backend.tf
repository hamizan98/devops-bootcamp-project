terraform {
  backend "s3" {
    bucket       = "devops-bootcamp-terraform-hamizanaimanbinhamid"
    key          = "terraform.tfstate"
    region       = "ap-southeast-1"
    encrypt      = true
    use_lockfile = true
  }
}