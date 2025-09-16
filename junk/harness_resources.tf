
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

# Create a Harness Environment
resource "harness_platform_environment" "example_env" {
  name        = "Example Environment"
  identifier  = "example_env"
  org_id      = "default"
  project_id  = "default"
  type        = "PreProduction"
  description = "Environment created via Terraform"
}

# Create a Harness Infrastructure Definition
resource "harness_platform_infrastructure" "example_infra" {
  name        = "Example Infra"
  identifier  = "example_infra"
  org_id      = "default"
  project_id  = "default"
  env_id      = harness_platform_environment.example_env.identifier
  type        = "KubernetesDirect"

  spec {
    connector_ref = "account.k8s_connector"
    namespace     = "default"
  }
}

# Create a Harness Pipeline
resource "harness_platform_pipeline" "example_pipeline" {
  name        = "Example Pipeline"
  identifier  = "example_pipeline"
  org_id      = "default"
  project_id  = "default"

  yaml = <<EOF
pipeline:
  name: Example Pipeline
  identifier: example_pipeline
  projectIdentifier: default
  orgIdentifier: default
  tags: {}
  stages:
    - stage:
        name: Deploy Stage
        identifier: deploy_stage
        type: Deployment
        spec:
          service:
            serviceRef: example_service
          environment:
            environmentRef: example_env
            infrastructureDefinitions:
              - identifier: example_infra
          execution:
            steps:
              - step:
                  name: Shell Script
                  identifier: shell_script
                  type: ShellScript
                  spec:
                    shell: Bash
                    command: echo "Hello from Terraform provisioned pipeline"
EOF
}
