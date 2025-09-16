
terraform {
  required_providers {
    harness = {
      source  = "harness/harness"
      version = "0.38.5"
    }
  }
}

provider "harness" {
  endpoint           = "https://app.harness.io/gateway"
  account_id         = "YOUR_HARNESS_ACCOUNT_ID"
  platform_api_key   = "YOUR_HARNESS_PLATFORM_API_KEY"
}

variable "env_names" {
  type    = list(string)
  default = ["tst", "acc", "prd"]
}

resource "harness_platform_environment" "env" {
  for_each    = toset(var.env_names)
  name        = each.value
  identifier  = each.value
  org_id      = "ing175org"
  project_id  = "ing175ip1"
  type        = "PreProduction"
  description = "Environment ${each.value} created via Terraform"
}

resource "harness_platform_infrastructure" "infra" {
  for_each    = toset(var.env_names)

  name        = "k8s-helm"
  identifier  = "k8shelm-${each.value}"
  org_id      = "ing175org"
  project_id  = "ing175ip1"
  env_id      = harness_platform_environment.env[each.key].identifier
  type        = "KubernetesDirect"
  deployment_type = "NativeHelm"

  spec {
    connector_ref = "k8sprod"
    namespace     = "default"
    release_name  = "release-<+INFRA_KEY_SHORT_ID>"
  }

  allow_simultaneous_deployments = true
  scoped_services = []
}
