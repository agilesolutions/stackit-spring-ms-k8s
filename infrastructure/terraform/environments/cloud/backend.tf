terraform {
  backend "s3" {
    bucket = "terraform-state"

    key    = "cloud/terraform.tfstate"

    endpoints = {
      s3 = "https://object.storage.eu01.onstackit.cloud"
    }
    region = "eu01"

    # Also use remote locking
    use_lockfile = true

    # AWS specific checks must be skipped as they do not work on STACKIT.
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true

    use_path_style = true
  }
}