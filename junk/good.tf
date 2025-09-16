resource "harness_platform_template" "stage_template_inline" {
  identifier    = "identifier"
  org_id        = var.org_id
  project_id    = var.proj_id
  name          = "name"
  comments      = "comments"
  version       = "ab"
  is_stable     = true
  template_yaml = <<-EOT
template:
  name: "name"
  identifier: "identifier"
  versionLabel: "ab"
  type: Stage
  projectIdentifier: ${var.proj_id}
  orgIdentifier: ${var.org_id}
  tags: {}
  spec:
    type: Deployment
    spec:
      deploymentType: Kubernetes
      service:
        serviceRef: <+input>
        serviceInputs: <+input>
      environment:
        environmentRef: <+input>
        deployToAll: false
        environmentInputs: <+input>
        infrastructureDefinitions: <+input>
      execution:
        steps:
          - step:
              type: ShellScript
              name: Shell Script_1
              identifier: ShellScript_1
              spec:
                shell: Bash
                onDelegate: true
                source:
                  type: Inline
                  spec:
                    script: <+input>
                environmentVariables: []
                outputVariables: []
              timeout: <+input>
        rollbackSteps: []
    failureStrategies:
      - onFailure:
          errors:
            - AllErrors
          action:
            type: StageRollback

  EOT
}