resource "harness_platform_template" "stage_template_inline" {
  
  identifier    = "kingsroaddeployment"
  org_id        = var.org_id
  project_id    = var.proj_id
  name          = "Kingsroad deployment"
  comments      = "comments"
  version       = "1.0.0"
  is_stable     = true
  template_yaml = <<-EOT
template:
  name: Kingsroad deployment
  identifier: kingsroaddeployment
  versionLabel: 1.0.0
  type: Stage
  projectIdentifier: ${var.proj_id}
  orgIdentifier: ${var.org_id}
  spec:
    type: Deployment
    spec:
      deploymentType: NativeHelm
      service:
        serviceRef: <+input.service>
      environment:
        environmentRef: <+input.environment>
        deployToAll: false
        infrastructureDefinitions:
          - identifier: <+input.infrastructure>
      execution:
        steps:
          - step:
              name: Strategy Selector
              identifier: strategy_selector
              type: ShellScript
              spec:
                shell: Bash
                command: echo "Selected strategy: <+input.strategy>"
              timeout: 10m

          - step:
              name: Helm Rolling Deploy
              identifier: helm_rolling_deploy
              type: NativeHelm
              when:
                condition: <+input.strategy> == "Rolling"
              spec:
                timeout: 10m

          - step:
              name: Helm Canary Deploy
              identifier: helm_canary_deploy
              type: NativeHelm
              when:
                condition: <+input.strategy> == "Canary"
              spec:
                timeout: 10m

          - step:
              name: Manual Approval
              identifier: canary_approval
              type: HarnessApproval
              when:
                condition: <+input.strategy> == "Canary"
              spec:
                approvalMessage: "Approve canary deployment continuation"
                includePipelineExecutionHistory: true
                approvers:
                  userGroups:
                    - <+input.user_group>
                timeout: 1h

          - step:
              name: Helm Final Deploy
              identifier: helm_final_deploy
              type: NativeHelm
              when:
                condition: <+input.strategy> == "Canary"
              spec:
                timeout: 10m

  EOT
}