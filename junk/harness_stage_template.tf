
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

# Create a Harness Stage Template
resource "harness_platform_template" "stage_template" {
  name        = "Reusable Deploy Stage"
  identifier  = "reusable_deploy_stage"
  org_id      = "default"
  project_id  = "default"
  version     = "v1"
  type        = "Stage"

  yaml = <<EOF
template:
  name: Reusable Deploy Stage
  identifier: reusable_deploy_stage
  versionLabel: v1
  type: Stage
  projectIdentifier: default
  orgIdentifier: default
  spec:
    type: Deployment
    spec:
      service:
        serviceRef: <+input>
      environment:
        environmentRef: <+input>
        infrastructureDefinitions:
          - identifier: <+input>
      execution:
        steps:
          - step:
              name: Echo Message
              identifier: echo_message
              type: ShellScript
              spec:
                shell: Bash
                command: echo "Deploying via reusable stage template"
EOF
}
