terraform {
  required_providers {
    signalfx = {
      source = "splunk-terraform/signalfx"
      version = ">= 7.0.0"
    }
  }
}


provider "signalfx" {
  #auth_token = "your-apu-key-goes-here"
  #api_url = "observability-api-url-for-your-real" Example: https://api.us1.signalfx.com
}

## Create a dashboard group to reference with each dashboard
resource "signalfx_dashboard_group" "jenkins-apm" {
  name        = "Jenkins APM Dashboard Group"
  description = "Dashboard group for Jenkins APM data"
}