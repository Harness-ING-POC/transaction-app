resource "harness_platform_template" "app_deploy_template" {
  name        = "Kingsroad deployment"
  identifier  = "kingsroaddeployment"
  org_id      = var.org_id
  project_id  = var.proj_id
  version     = "1.0.0"
  description = "Template for rolling or canary deployment with approval"

  yaml = <<-EOT
    template:
      name: Kingsroad deployment
      identifier: kingsroaddeployment
      versionLabel: 1.0.0
      type: Stage
      projectIdentifier: "${var.proj_id}"
      orgIdentifier: "${var.org_id}"
      spec:
        type: Deployment
        spec:
          deploymentType: Kubernetes
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
                  name: Rolling Deployment
                  identifier: rolling_deploy
                  type: K8sRollingDeploy
                  when:
                    condition: <+input.strategy> == "Rolling"
                  spec:
                    timeout: 10m

              - step:
                  name: Canary Deployment
                  identifier: canary_deploy
                  type: K8sCanaryDeploy
                  when:
                    condition: <+input.strategy> == "Canary"
                  spec:
                    instances:
                      type: Percentage
                      spec:
                        value: 25
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
                  name: Canary Final Deployment
                  identifier: canary_final
                  type: K8sCanaryDelete
                  when:
                    condition: <+input.strategy> == "Canary"
                  spec:
                    timeout: 10m
  EOT
}