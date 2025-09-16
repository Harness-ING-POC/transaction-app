resource "harness_platform_template" "app_deploy_template" {
  name        = "Kingsroad deployment"
  identifier  = "kingsroaddeployment"
  org_id      = var.org_id
  project_id  = var.proj_id
  version     = "1.0.0"
  description = "Template for rolling or canary deployment with approval"

  git_details {
    branch_name    = "main"
    file_path      = "additional_templates/deploy.yaml"
    connector_ref  = "harnessconnector"
    store_type     = "REMOTE"
    repo_name      = "transaction-app"
    commit_message = "Sync Kingsroad deployment template"
  }
}
