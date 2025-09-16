resource "harness_platform_environment" "onboard_envs" {
  for_each    = toset(var.env_names)
  name        = each.value
  identifier  = each.value
  org_id      = var.org_id
  project_id  = var.proj_id
  type        = "PreProduction"
  description = "Environment ${each.value} created via Terraform"
}


resource "harness_platform_infrastructure" "infra" {
  for_each    = toset(var.env_names)

  name        = "k8s-helm"
  identifier  = "k8shelm${each.key}"
  org_id      = var.org_id
  project_id  = var.proj_id
  env_id      = harness_platform_environment.onboard_envs[each.key].identifier
  type        = "KubernetesDirect"
  deployment_type = "NativeHelm"

  yaml = <<-EOT
infrastructureDefinition:
  name: k8s-helm
  identifier: k8shelm-${each.key}
  orgIdentifier: ${var.org_id}
  projectIdentifier: ${var.proj_id}
  environmentRef: ${each.key}
  deploymentType: NativeHelm
  type: KubernetesDirect
  spec:
    connectorRef: k8sprod
    namespace: ing175-ns
    releaseName: ${var.service_name}-<+INFRA_KEY_SHORT_ID>
  allowSimultaneousDeployments: true
  scopedServices: []
EOT
}
