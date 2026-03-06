terraform {
    backend "s3" {
        bucket = "yaini-terraform"
        dynamodb_table = "terraform-lock"
        key = "tfstate/3-tier-architecture/dev/terraform.tfstate"
        region = "ap-northeast-2"
        encrypt=true
    }
}