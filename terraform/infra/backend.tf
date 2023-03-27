terraform {
  backend "s3" {
    bucket                      = "pve-homelab-7ae2"
    endpoint                    = "https://s3.us-central-1.wasabisys.com"
    key                         = "infra-terraform.tfstate"
    region                      = "us-central-1"
    force_path_style            = true
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }
}