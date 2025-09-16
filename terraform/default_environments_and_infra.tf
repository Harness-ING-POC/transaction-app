resource "harness_platform_environment" "onboard_envs" {
  for_each    = toset(var.env_names)
  name        = each.value
  identifier  = each.value
  org_id      = var.org_id
  project_id  = var.project_id
  type        = "PreProduction"
  description = "Environment ${each.value} created via Terraform"
}


resource "harness_platform_infrastructure" "infra" {
  for_each    = toset(var.env_names)

  name        = "helm-infrastructure"
  identifier  = "helminfra-${each.value}"
  env_id      = harness_platform_environment.env[each.key].identifier
  type        = "KubernetesDirect"
  deployment_type = "NativeHelm"

  spec {
    connector_ref = "k8sprod"
    namespace     = "ing175-ns"
    release_name  = "${var.service_name}-<+INFRA_KEY_SHORT_ID>"
  }

  allow_simultaneous_deployments = true
  scoped_services = []
}