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
  name: "Kingsroad deployment"
  identifier: kingsroaddeployment
  versionLabel: 1.0.0
  type: Stage
  projectIdentifier: ${var.proj_id}
  orgIdentifier: ${var.org_id}
  tags: {}
  spec:
    type: Deployment
    spec:
      deploymentType: NativeHelm
      environment:
        environmentRef: <+input>
        deployToAll: false
        environmentInputs: <+input>
        serviceOverrideInputs: <+input>
        infrastructureDefinitions: <+input>
      service:
        serviceRef: <+input>
        serviceInputs: <+input>
        failureStrategies:
          - onFailure:
              errors:
                - AllErrors
              action:
                type: PipelineRollback
      execution:
        steps:
          - step:
              name: Helm Deployment
              identifier: helmDeployment
              type: HelmDeploy
              timeout: 10m
              spec:
                skipDryRun: false
                ignoreReleaseHistFailStatus: false
              when:
                stageStatus: Success
                condition: <+stage.variables.strategy> == "rolling"
          - step:
              type: HelmCanaryDeploy
              name: Deploy Canary
              identifier: Deploy_Canary
              spec:
                ignoreReleaseHistFailStatus: false
                skipSteadyStateCheck: false
                instanceSelection:
                  type: Count
                  spec:
                    count: 1
              timeout: 10m
              when:
                stageStatus: Success
                condition: <+stage.variables.strategy> == "canary"
          - step:
              type: HarnessApproval
              name: Approval
              identifier: Approval
              spec:
                approvalMessage: Please review the following information and approve the pipeline progression
                includePipelineExecutionHistory: true
                isAutoRejectEnabled: false
                approvers:
                  userGroups:
                    - _project_all_users
                  minimumCount: 1
                  disallowPipelineExecutor: false
                approverInputs: []
              timeout: 1d
              when:
                stageStatus: Success
                condition: <+stage.variables.strategy> == "canary"
          - step:
              type: HelmCanaryDelete
              name: HelmCanaryDelete_1
              identifier: HelmCanaryDelete_1
              spec: {}
              timeout: 10m
              when:
                stageStatus: Success
                condition: <+stage.variables.strategy> == "canary"
          - step:
              type: HelmDeploy
              name: HelmDeploy_2
              identifier: HelmDeploy_2
              spec:
                skipDryRun: false
                ignoreReleaseHistFailStatus: false
              timeout: 10m
              when:
                stageStatus: Success
                condition: <+stage.variables.strategy> == "canary"
        rollbackSteps:
          - step:
              name: Helm Rollback
              identifier: helmRollback
              type: HelmRollback
              timeout: 10m
              spec: {}
    failureStrategies:
      - onFailure:
          errors:
            - AllErrors
          action:
            type: StageRollback
    variables:
      - name: strategy
        type: String
        description: ""
        required: true
        value: <+input>.default(rolling)

  EOT
}



# resource "harness_platform_template" "stage_template_inline" {
  
#   identifier    = "kingsroaddeployment"
#   org_id        = var.org_id
#   project_id    = var.proj_id
#   name          = "Kingsroad deployment"
#   comments      = "comments"
#   version       = "1.0.0"
#   is_stable     = true
#   template_yaml = <<-EOT
# template:
#   name: Kingsroad deployment
#   identifier: kingsroaddeployment
#   versionLabel: 1.0.0
#   type: Stage
#   projectIdentifier: ${var.proj_id}
#   orgIdentifier: ${var.org_id}
#   spec:
#     type: Deployment
#     spec:
#       deploymentType: NativeHelm
#       service:
#         serviceRef: <+input.service>
#       environment:
#         environmentRef: <+input.environment>
#         deployToAll: false
#         infrastructureDefinitions:
#           - identifier: <+input.infrastructure>
#       execution:
#         steps:
#           - step:
#               name: Strategy Selector
#               identifier: strategy_selector
#               type: ShellScript
#               spec:
#                 shell: Bash
#                 command: echo "Selected strategy: <+input.strategy>"
#               timeout: 10m

#           - step:
#               name: Helm Rolling Deploy
#               identifier: helm_rolling_deploy
#               type: NativeHelm
#               when:
#                 condition: <+input.strategy> == "Rolling"
#               spec:
#                 timeout: 10m

#           - step:
#               name: Helm Canary Deploy
#               identifier: helm_canary_deploy
#               type: NativeHelm
#               when:
#                 condition: <+input.strategy> == "Canary"
#               spec:
#                 timeout: 10m

#           - step:
#               name: Manual Approval
#               identifier: canary_approval
#               type: HarnessApproval
#               when:
#                 condition: <+input.strategy> == "Canary"
#               spec:
#                 approvalMessage: "Approve canary deployment continuation"
#                 includePipelineExecutionHistory: true
#                 approvers:
#                   userGroups:
#                     - <+input.user_group>
#                 timeout: 1h

#           - step:
#               name: Helm Final Deploy
#               identifier: helm_final_deploy
#               type: NativeHelm
#               when:
#                 condition: <+input.strategy> == "Canary"
#               spec:
#                 timeout: 10m

#   EOT
# }